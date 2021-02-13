
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:remember/ui/login.dart';
import 'package:remember/ui/sign_up.dart';
import '../AppLanguage.dart';
import '../AppLocalizations.dart';
import '../app_constants.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          top: true,
          bottom: false,
          child: Stack(
            children: <Widget>[
              Positioned(
                width: MediaQuery.of(context).size.width,
                top: 330.0,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width *
                            button_width_percentage,
                        height: button_height,
                        margin: EdgeInsets.all(16),
                        child: RaisedButton(
                            child: Text(
                            AppLocalizations.of(context)
                                .translate('login'),
                              style: TextStyle(
                                color: remWhite,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(button_BorderRadius),
                            ),
                            color: themeColor,
                            onPressed: () => {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => (
                                      LoginScreen(
                                    ))))
                            })),

                    Container(
                        width: MediaQuery.of(context).size.width *
                            button_width_percentage,
                        height: button_height,
                        child: RaisedButton(
                            child: Text(
                          AppLocalizations.of(context)
                              .translate('sign_up'),
                              style: TextStyle(
                                color: remWhite,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(button_BorderRadius),
                            ),
                            color: themeColor,
                            onPressed: () => {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => (
                                      SignUpScreen(
                                      ))))
                                })),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<bool> _onWillPop() {
    buildAlertDialog();
    return Future(() => false);
  }
  void buildAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Column(
            children: <Widget>[
              Text(
                AppLocalizations.of(context)
                    .translate('exit'),
                style: TextStyle(
                  color: themeColor,
                  fontWeight: FontWeight.normal,
                ),
              )
            ],
          ),
          content: Text(
              AppLocalizations.of(context).translate('exit_message'),
              style: TextStyle(
                fontSize: chat_text_font_size,
                fontWeight: FontWeight.normal,
              )),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          actions: <Widget>[
            DecoratedBox(
              decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  color: Colors.grey),
              child: ButtonTheme(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                padding: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 0.0),
                child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    AppLocalizations.of(context)
                        .translate('no'),
                    style: TextStyle(
                      color: remWhite,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
            DecoratedBox(
              decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  color: themeColor),
              child: ButtonTheme(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                padding: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 0.0),
                child: FlatButton(
                  onPressed: () async {
                    exit(0);
                  },
                  child: Text(
                    AppLocalizations.of(context)
                        .translate('yes'),
                    style: TextStyle(
                      color: remWhite,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
