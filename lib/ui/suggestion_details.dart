import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remember/ui/suggestions_screen.dart';

import '../AppLocalizations.dart';
import '../app_constants.dart';

class SuggestionDetails extends StatefulWidget {
  @override
  _SuggestionDetailsState createState() => _SuggestionDetailsState();
}

class _SuggestionDetailsState extends State<SuggestionDetails> {
  final GlobalKey<FormState> _detailsFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _textEditingControllerName = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SuggestionsScreen(
                            )));
              },
            ),
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: themeColor,
            centerTitle: true,
            elevation: 0,
            title: Text(
              AppLocalizations.of(context).translate('sug_det'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontFamily: 'Tajawal-Regular',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            )),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Form(
                  key: _detailsFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.fromLTRB(10, 20, 10, 40),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * .2,
                        child: TextFormField(
                            validator: (value) {
                              if (value.length < 3) {
                                return AppLocalizations.of(context)
                                    .translate('sugg_validate');
                              } else {
                                return null;
                              }
                            },
                            controller: this._textEditingControllerName,
                            keyboardType: TextInputType.text,
                            style:
                            TextStyle(
                                fontFamily: 'Tajawal-Regular', color: Color(
                                0xFF0F2E48), fontSize: 14),
                            autofocus: false,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide:
                                    BorderSide(color: Color(0xFFAAB5C3))),
                                fillColor: Color(0xFFF3F3F5),
                                focusColor: Color(0xFFF3F3F5),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide:
                                    BorderSide(color: Color(0xFFAAB5C3))),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide:
                                    BorderSide(color: backgroundColor)),
                                hintText: AppLocalizations.of(context)
                                    .translate('name_sugg'))),
                      ),
                      Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * .5,
                          child: RaisedButton(
                              color: themeColor,
                              child: Text(
                                AppLocalizations.of(context).translate('save'),
                                style: TextStyle(fontFamily: 'Tajawal-Regular',
                                    color: remWhite),
                              ),
                              onPressed: () {
                                if (_detailsFormKey.currentState.validate()) {
                                  FocusScope.of(context).requestFocus();
                                  setState(() {
                                    isLoading = true;
                                  });
                                  addSuggestion();
                                }
                              }))
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void _showToast(String message) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(message,
            style: TextStyle(fontFamily: 'Tajawal-Regular',
              fontSize: chat_text_font_size,
              fontWeight: FontWeight.normal,
            ))));
  }

  void addSuggestion() {
    DateTime now = DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String date = formatter.format(now);
    FirebaseFirestore.instance.collection("suggestions").doc(date).set({
      "suggestion": _textEditingControllerName.text,
      "date": date,
    }).then((_) {
      setState(() {
        isLoading = false;
      });
      _showToast(AppLocalizations.of(context).translate('sugg_add'));
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => SuggestionsScreen()));
      print("success!");
    }).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<bool> _onWillPop() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SuggestionsScreen(
                )));
    return Future(() => false);
  }
}
