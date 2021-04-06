import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remember/model/questions.dart';
import 'package:remember/ui/available_suggestions.dart';
import 'package:remember/ui/basic_home.dart';

import '../AppLocalizations.dart';
import '../app_constants.dart';
import '../app_utils.dart';

class MySuggestion extends StatefulWidget {
  Questions adminSuggestions;

  MySuggestion({this.adminSuggestions});

  @override
  _MySuggestionState createState() => _MySuggestionState();
}

class _MySuggestionState extends State<MySuggestion> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _detailsFormKey = GlobalKey<FormState>();
  TextEditingController _textEditingControllerName = TextEditingController();
  bool isLoading = true;
  bool hasData = false;
  String question;
  String username;
  bool isLoadingButton = false;

  @override
  void initState() {
    super.initState();
    getQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AvilableSuggestionsScreen()));
            },
          ),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: backgroundColor,
          centerTitle: true,
          elevation: 0,
          title: Text(
            AppLocalizations.of(context).translate('sugg'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontFamily: 'Tajawal-Regular',
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          )),
      body: SafeArea(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: remWhite,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Form(
                      key: _detailsFormKey,
                      child: !hasData
                          ? Container(
                        margin: EdgeInsets.only(top: 150),
                        child: Center(
                          child: Text(AppLocalizations.of(context)
                              .translate('no_sugg'),
                            style: TextStyle(
                                fontFamily: 'Tajawal-Regular',
                                color: Color(0xFF0F2E48),
                                fontSize: 20),),
                        ),
                      )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.all(10),
                                  child: Text(question, style: TextStyle(
                                      fontFamily: 'Tajawal-Regular',
                                      color: Color(0xFF0F2E48),
                                      fontSize: 18),),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.fromLTRB(10, 20, 10, 40),
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * .2,
                                  child: TextFormField(
                                      validator: (value) {
                                        if (value.length < 3) {
                                          return AppLocalizations.of(context)
                                              .translate('sugg_validate');
                                        } else {
                                          return null;
                                        }
                                      },
                                      controller:
                                          this._textEditingControllerName,
                                      keyboardType: TextInputType.text,
                                      maxLines: 20,
                                      style: TextStyle(
                                          fontFamily: 'Tajawal-Regular',
                                          color: Color(0xFF0F2E48),
                                          fontSize: 14),
                                      autofocus: false,
                                      decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              borderSide: BorderSide(
                                                  color: Color(0xFFAAB5C3))),
                                          fillColor: Color(0xFFF3F3F5),
                                          focusColor: Color(0xFFF3F3F5),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              borderSide: BorderSide(
                                                  color: Color(0xFFAAB5C3))),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              borderSide: BorderSide(
                                                  color: backgroundColor)),
                                          hintText: AppLocalizations.of(context)
                                              .translate('name_sugg'),)),
                                ),
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width * .5,
                                    child: RaisedButton(
                                        color: themeColor,
                                        child: isLoadingButton
                                            ? (CircularProgressIndicator(
                                          backgroundColor: remWhite,
                                        ))
                                            : Text(
                                                AppLocalizations.of(context)
                                                    .translate('save'),
                                                style:
                                                TextStyle(
                                                    fontFamily: 'Tajawal-Regular',
                                                    color: remWhite),
                                              ),
                                        onPressed: () {
                                          if (_detailsFormKey.currentState
                                              .validate()) {
                                            FocusScope.of(context)
                                                .requestFocus();
                                            setState(() {
                                              isLoadingButton = true;
                                            });
                                            addSuggestion();
                                          }
                                        }))
                              ],
                            ))
                ],
              ),
      ),
    );
  }

  Future<void> getQuestions() async {
    DateTime now = DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String date = formatter.format(now);
    username = await getUserName();

    FirebaseFirestore.instance
        .collection("suggestions")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        if (result.id.contains(date) &&
            result.data()['suggestion'] == widget.adminSuggestions.question) {
          print(result.data());
          setState(() {
            question = result.data()["suggestion"];
            isLoading = false;
            hasData = true;
          });
        }
      });
    }).whenComplete(() {
      setState(() {
        if (question != null) {
          setState(() {
            isLoading = false;
            hasData = true;
          });
        } else {
          isLoading = false;
          hasData = false;
        }
      });
    });
  }

  void addSuggestion() {
    DateTime now = DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd hh:mm:ss');
    String date = formatter.format(now);

    var firebaseUser = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection("users_suggestions")
        .doc(firebaseUser.uid + date.toString())
        .set({
      "date": date,
      "username": username,
      "question": question,
      "answer": _textEditingControllerName.text,
    }).then((_) {
      setState(() {
        isLoadingButton = false;
      });
      _showToast(AppLocalizations.of(context).translate('sug_done'));
      _textEditingControllerName.clear();
      print("success!");
    }).whenComplete(() {
      setState(() {
        isLoadingButton = false;
      });
    });
  }

  void _showToast(String message) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(message,
            style: TextStyle(fontFamily: 'Tajawal-Regular',
              fontSize: chat_text_font_size,
              fontWeight: FontWeight.normal,
            ))));
  }
}
