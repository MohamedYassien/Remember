import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:remember/ui/admin_screen.dart';
import 'package:remember/ui/home_page.dart';
import 'package:remember/ui/login.dart';
import 'package:remember/ui/lovers.dart';
import 'package:remember/ui/my_suggestion.dart';
import 'package:remember/ui/user_questionair_screen.dart';

import '../AppLocalizations.dart';
import '../app_constants.dart';
import 'competitor_results.dart';

class BasicHomePage extends StatefulWidget {
  @override
  _BasicHomePageState createState() => _BasicHomePageState();
}

class _BasicHomePageState extends State<BasicHomePage> {
  bool isAdmin = false;
  List<String> homeElement = ['الاقتراحات', 'الاستفتاءات', 'احبابى', 'عباداتى'];

  @override
  void initState() {
    super.initState();
    getAdmin();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: remWhite,
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: themeColor,
            centerTitle: true,
            elevation: 0,
            title: Text(
              AppLocalizations.of(context).translate('Home'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontFamily: 'Tajawal-Regular',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            )),
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text(AppLocalizations.of(context).translate('side_menu'),
                    style: TextStyle(
                      fontFamily: 'Tajawal-Regular',
                    )),
                decoration: BoxDecoration(
                  color: backgroundColor,
                ),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context).translate('eb'),
                    style: TextStyle(
                      fontFamily: 'Tajawal-Regular',
                    )),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
              ),
              Divider(
                height: 2,
              ),
              ListTile(
                title: Text(AppLocalizations.of(context).translate('lovers'),
                    style: TextStyle(
                      fontFamily: 'Tajawal-Regular',
                    )),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Lovers()));
                },
              ),
              Divider(
                height: 2,
              ),
              ListTile(
                title: Text(AppLocalizations.of(context).translate('quit'),
                    style: TextStyle(
                      fontFamily: 'Tajawal-Regular',
                    )),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserQuestionnaireScreen()));
                },
              ),
              Divider(
                height: 2,
              ),
              ListTile(
                title: Text(AppLocalizations.of(context).translate('sug'),
                    style: TextStyle(
                      fontFamily: 'Tajawal-Regular',
                    )),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MySuggestion()));
                },
              ),
              Divider(
                height: 2,
              ),
              ListTile(
                title:
                    Text(AppLocalizations.of(context).translate('result_all'),
                        style: TextStyle(
                          fontFamily: 'Tajawal-Regular',
                        )),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CompetitorResults()));
                },
              ),
              Divider(
                height: 2,
              ),
              isAdmin
                  ? ListTile(
                      title:
                          Text(AppLocalizations.of(context).translate('admin'),
                              style: TextStyle(
                                fontFamily: 'Tajawal-Regular',
                              )),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdminPanel()));
                      },
                    )
                  : SizedBox(),
              isAdmin
                  ? Divider(
                      height: 2,
                    )
                  : SizedBox(),
              ListTile(
                title: Text(AppLocalizations.of(context).translate('setting'),
                    style: TextStyle(
                      fontFamily: 'Tajawal-Regular',
                    )),
                onTap: () {
                  _signOut();
                },
              ),
              Divider(
                height: 2,
              ),
            ],
          ),
        ),
        body: buildBody(),
      ),
    );
  }

  void getAdmin() {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser.uid)
        .get()
        .then((value) {
      if (value.data()["isAdmin"] == true) {
        setState(() {
          isAdmin = true;
        });
      }
      print('isAdmin :${value.data()["isAdmin"]}');
    });
  }

  Widget buildBody() {
    return SafeArea(
        child: Column(children: <Widget>[
      Container(
        padding: EdgeInsets.all(10.0),
        child: GridView.count(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            crossAxisCount: 2,
            children: new List<Widget>.generate(homeElement.length, (index) {
              return Center(
                child: choiceCard(context, index, true),
              );
            })),
      ),
    ]));
  }

  Container choiceCard(context, index, bool isActionList) {
    print('size${(MediaQuery.of(context).size.width - 20) / 3}');
    var size = (MediaQuery.of(context).size.width - 20) / 3;
    return Container(
        padding: EdgeInsets.all(4.0),
        child: Center(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: InkWell(
                  onTap: () {
                    print('index : $index');
                    switch (index) {
                      case 0:
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MySuggestion()));
                        break;
                      case 1:
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    UserQuestionnaireScreen()));
                        break;
                      case 2:
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Lovers()));
                        break;
                      case 3:
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()));
                        break;
                    }
                  },
                  child: ClipOval(
                    child: Container(
                        color: backgroundColor2,
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Center(
                            child: FittedBox(
                          child: Text(
                            homeElement[index],
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: 'Tajawal-Regular',
                              color: remWhite,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ))),
                  ),
                )),
              ]),
        ));
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
                AppLocalizations.of(context).translate('exit'),
                style: TextStyle(
                  fontFamily: 'Tajawal-Regular',
                  color: themeColor,
                  fontWeight: FontWeight.normal,
                ),
              )
            ],
          ),
          content: Text(AppLocalizations.of(context).translate('exit_message'),
              style: TextStyle(
                fontFamily: 'Tajawal-Regular',
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
                    AppLocalizations.of(context).translate('no'),
                    style: TextStyle(
                      fontFamily: 'Tajawal-Regular',
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
                    AppLocalizations.of(context).translate('yes'),
                    style: TextStyle(
                      fontFamily: 'Tajawal-Regular',
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

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => LoginScreen()));
  }
}
