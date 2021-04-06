import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remember/ui/questionair_screen.dart';

import '../AppLocalizations.dart';
import '../app_constants.dart';

class QuestionnairDetails extends StatefulWidget {
  @override
  _QuestionnairDetailsState createState() => _QuestionnairDetailsState();
}

class _QuestionnairDetailsState extends State<QuestionnairDetails> {
  final GlobalKey<FormState> _detailsFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _textEditingControllerName = TextEditingController();
  TextEditingController _textEditingControllerElement = TextEditingController();
  final focus = FocusNode();
  bool isEnableName = true;
  bool isEnableSaveName = true;
  bool isMulti = false;

  String name;

  List<String> elementList = [];
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
                        builder: (context) => QuestionnaireScreen()));
              },
            ),
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: backgroundColor,
            centerTitle: true,
            elevation: 0,
            title: Text(
              AppLocalizations.of(context).translate('quest_det'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontFamily: 'Tajawal-Regular',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            )),
        body: SafeArea(
          child: buildBody(),
        ),
      ),
    );
  }

  Widget buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        SizedBox(
          height: 0,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Form(
              key: _detailsFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * .6,
                          child: TextFormField(
                              validator: (value) {
                                if (value.length < 3) {
                                  return AppLocalizations.of(context)
                                      .translate('name_quest');
                                } else {
                                  return null;
                                }
                              },
                              enabled: isEnableName,
                              controller: this._textEditingControllerName,
                              maxLines: 10,
                              keyboardType: TextInputType.text,
                              style: TextStyle(fontFamily: 'Tajawal-Regular',
                                  color: Color(0xFF0F2E48), fontSize: 14),
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
                                      .translate('name_quest'))),
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width * .2,
                            child: RaisedButton(
                                color: themeColor,
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('save'),
                                  style: TextStyle(
                                      fontFamily: 'Tajawal-Regular',
                                      color: remWhite),
                                ),
                                onPressed: isEnableSaveName
                                    ? () {
                                        if (_textEditingControllerName
                                            .text.isNotEmpty) {
                                          FocusScope.of(context)
                                              .requestFocus(focus);
                                          setState(() {
                                            name =
                                                _textEditingControllerName.text;
                                            isEnableName = false;
                                            isEnableSaveName = false;
                                          });
                                          _showToast(
                                              AppLocalizations.of(context)
                                                  .translate('quest_added'));
                                        } else {
                                          _showToast(
                                              AppLocalizations.of(context)
                                                  .translate('name_quest'));
                                        }
                                      }
                                    : null))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 34, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * .6,
                          child: TextFormField(
                              focusNode: focus,
                              validator: (value) {
                                if (value.length < 3) {
                                  return AppLocalizations.of(context)
                                      .translate('quest_validate');
                                } else {
                                  return null;
                                }
                              },
                              controller: this._textEditingControllerElement,
                              style: TextStyle(fontFamily: 'Tajawal-Regular',
                                  color: Color(0xFF0F2E48), fontSize: 14),
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide:
                                        BorderSide(color: Color(0xFFAAB5C3))),
                                filled: true,
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
                                    .translate('element_quest'),
                              )),
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width * .2,
                            child: RaisedButton(
                                color: themeColor,
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('save'),
                                  style: TextStyle(
                                      fontFamily: 'Tajawal-Regular',
                                      color: remWhite),
                                ),
                                onPressed: () {
                                  if (_textEditingControllerElement
                                      .text.isNotEmpty) {
                                    FocusScope.of(context).requestFocus(focus);
                                    setState(() {
                                      elementList.add(
                                          _textEditingControllerElement.text);
                                      _showToast(AppLocalizations.of(context)
                                          .translate('element_add_quest'));
                                      _textEditingControllerElement.clear();
                                    });
                                  } else {
                                    if (elementList.isEmpty) {
                                      _showToast(AppLocalizations.of(context)
                                          .translate('element_quest'));
                                    }
                                  }
                                }))
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Container(
                            width: MediaQuery.of(context).size.width * .7,
                            child: Row(
                              children: [
                                Checkbox(
                                    value: isMulti, onChanged: _onMultiChanged),
                                Text(AppLocalizations.of(context)
                                    .translate('multi')),
                              ],
                            ))),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 34, horizontal: 20),
                      child: Container(
                          width: MediaQuery.of(context).size.width * .7,
                          child: RaisedButton(
                              color: themeColor,
                              child: isLoading
                                  ? CircularProgressIndicator(
                                      backgroundColor: remWhite,
                                    )
                                  : Text(
                                      AppLocalizations.of(context)
                                          .translate('submit_quest'),
                                style: TextStyle(fontFamily: 'Tajawal-Regular',
                                    color: remWhite),
                                    ),
                              onPressed: () {
                                if (elementList.isNotEmpty) {
                                  if (name != null) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    FocusScope.of(context).requestFocus(focus);
                                    print(
                                        'name$name + list${elementList.length}');
                                    addQuestionnaire();
                                    elementList.clear();
                                    name = '';
                                  } else {
                                    _showToast(AppLocalizations.of(context)
                                        .translate('name_quest'));
                                  }
                                } else {
                                  _showToast(AppLocalizations.of(context)
                                      .translate('element_quest'));
                                }
                              })))
                ],
              ),
            ),
          ),
        ),
      ],
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

  void addQuestionnaire() {
    DateTime now = DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd hh:mm:ss');
    String date = formatter.format(now);
    FirebaseFirestore.instance.collection("questionnaires").doc(date).set({
      "question": name,
      "element": FieldValue.arrayUnion(elementList),
      "multi": isMulti,
    }).then((_) {
      setState(() {
        isLoading = false;
      });
      _showToast(AppLocalizations.of(context).translate('quest_add'));
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => QuestionnaireScreen()));
      print("success!");
    });
  }

  void _onMultiChanged(bool newValue) => setState(() {
        isMulti = newValue;
      });

  Future<bool> _onWillPop() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => QuestionnaireScreen()));
    return Future(() => false);
  }
}
