import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:remember/ui/action_screen.dart';

import '../AppLocalizations.dart';
import '../app_constants.dart';

class ActionDetails extends StatefulWidget {
  @override
  _ActionDetailsState createState() => _ActionDetailsState();
}

class _ActionDetailsState extends State<ActionDetails> {
  final GlobalKey<FormState> _detailsFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _textEditingControllerName = TextEditingController();
  TextEditingController _textEditingControllerElement = TextEditingController();
  TextEditingController _textEditingControllerPoint = TextEditingController();
  final focus = FocusNode();
  bool isEnableName = true;
  bool isEnableSaveName = true;
  bool isEnableElement = true;
  bool isEnableSaveElement = true;
  bool isEnablePoint = true;
  bool isEnableSavePoint = true;
  String name;
  String point = '0';

  List<String> elementList = [];
  List<String> pointList = [];
  bool isLoading = false;
  bool rememberMe = false;

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
                            AddActionScreen(
                            )));
              },
            ),
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: backgroundColor,
            centerTitle: true,
            elevation: 0,
            title: Text(
              AppLocalizations.of(context).translate('act_det'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontFamily: 'Tajawal-Regular',
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
                                      .translate('name_validate');
                                } else {
                                  return null;
                                }
                              },
                              enabled: isEnableName,
                              controller: this._textEditingControllerName,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                  fontFamily: 'Tajawal-Regular',
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
                                      .translate('name'))),
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
                                                  .translate('name_add'));
                                        } else {
                                          _showToast(
                                              AppLocalizations.of(context)
                                                  .translate('name'));
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
                                      .translate('element_validate');
                                } else {
                                  return null;
                                }
                              },
                              enabled: isEnableElement,
                              controller: this._textEditingControllerElement,
                              style: TextStyle(
                                  fontFamily: 'Tajawal-Regular',
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
                                    .translate('element'),
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
                                onPressed: isEnableSaveElement
                                    ? () {
                                        if (_textEditingControllerElement
                                            .text.isNotEmpty) {
                                          FocusScope.of(context)
                                              .requestFocus(focus);
                                          setState(() {
                                            elementList.add(
                                                _textEditingControllerElement
                                                    .text);
                                            _showToast(
                                                AppLocalizations.of(context)
                                                    .translate('element_add'));
                                            _textEditingControllerPoint.clear();
                                            isEnablePoint = true;
                                            isEnableSavePoint = true;
                                            isEnableSaveElement = false;
                                            isEnableElement = false;
                                          });
                                        } else {
                                          if (elementList.isEmpty) {
                                            _showToast(
                                                AppLocalizations.of(context)
                                                    .translate('element'));
                                          }
                                        }
                                      }
                                    : null))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * .6,
                          child: TextFormField(
                              enabled: isEnablePoint,
                              controller: this._textEditingControllerPoint,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                  fontFamily: 'Tajawal-Regular',
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
                                      .translate('point'))),
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
                                onPressed: isEnableSavePoint
                                    ? () {
                                        if (_textEditingControllerPoint
                                            .text.isNotEmpty) {
                                          FocusScope.of(context)
                                              .requestFocus(focus);
                                          setState(() {
                                            if (!pointList.contains(
                                                _textEditingControllerPoint.text
                                                    .toString())) {
                                              pointList.add(
                                                  _textEditingControllerPoint
                                                      .text
                                                      .toString());
                                            } else {
                                              pointList.add(
                                                  _textEditingControllerPoint
                                                          .text
                                                          .toString() +
                                                      ' ');
                                            }
                                            isEnablePoint = false;
                                            isEnableSavePoint = false;
                                            _textEditingControllerElement
                                                .clear();
                                            isEnableElement = true;
                                            isEnableSaveElement = true;
                                          });
                                          _showToast(
                                              AppLocalizations.of(context)
                                                  .translate('point_add'));
                                        } else {
                                          _showToast(
                                              AppLocalizations.of(context)
                                                  .translate('point'));
                                        }
                                      }
                                    : null))
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Container(
                          width: MediaQuery.of(context).size.width * .7,
                          child: Row(
                            children: [
                              Text(
                                  AppLocalizations.of(context).translate('rm')),
                              Checkbox(
                                  value: rememberMe,
                                  onChanged: _onRememberMeChanged),
                            ],
                          ))),
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
                                          .translate('submit'),
                                style: TextStyle(
                                    fontFamily: 'Tajawal-Regular',
                                    color: remWhite),
                                    ),
                              onPressed: () {
                                if (elementList.isNotEmpty) {
                                  if (_textEditingControllerName
                                      .text.isNotEmpty) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    FocusScope.of(context).requestFocus(focus);
                                    print(
                                        'name$name + list${elementList.length}');
                                    addActions();
                                    elementList.clear();
                                    pointList.clear();
                                    name = '';
                                  } else {
                                    _showToast(AppLocalizations.of(context)
                                        .translate('name'));
                                  }
                                } else {
                                  _showToast(AppLocalizations.of(context)
                                      .translate('element'));
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
            style: TextStyle(
              fontFamily: 'Tajawal-Regular',
              fontSize: chat_text_font_size,
              fontWeight: FontWeight.normal,
            ))));
  }

  void addActions() {
    FirebaseFirestore.instance.collection("actions").doc(name.toString()).set({
      "action": name,
      "element": FieldValue.arrayUnion(elementList),
      "point": FieldValue.arrayUnion(pointList),
      "remember": rememberMe,
    }).then((_) {
      setState(() {
        isLoading = false;
      });
      _showToast(AppLocalizations.of(context).translate('action_add'));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => AddActionScreen()));
      print("success!");
    });
  }

  void _onRememberMeChanged(bool newValue) => setState(() {
        rememberMe = newValue;
      });

  Future<bool> _onWillPop() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AddActionScreen(
                )));
    return Future(() => false);
  }
}
