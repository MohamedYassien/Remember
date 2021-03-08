import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:remember/model/actions.dart';
import 'package:remember/model/points.dart';
import 'package:remember/ui/action_screen.dart';
import 'package:remember/ui/admin_screen.dart';
import 'package:remember/ui/my_action.dart';
import 'package:remember/ui/my_suggestion.dart';
import 'package:remember/ui/points_details.dart';

import '../AppLocalizations.dart';
import '../app_constants.dart';
import 'competitor_results.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isAdmin = false;
  List<ActionsModel> actionModelList = [];
  List<Points> pointsList = [];
  bool isLoading = true;
  bool hasData = false;
  bool isLoadingPoints = true;
  bool hasDataPoints = false;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd hh:mm:ss');
    String date = formatter.format(now);
    print('date>>>>>$date');
    getAdmin();
    getActions();
    getPoints();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: backgroundColor2,
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: backgroundColor,
            centerTitle: true,
            elevation: 0,
            title: Text(
              AppLocalizations.of(context).translate('Home'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
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
                child: Text(
                    AppLocalizations.of(context).translate('side_menu')),
                decoration: BoxDecoration(
                  color: backgroundColor,
                ),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context).translate('eb')),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              Divider(
                height: 2,
              ),
              ListTile(
                title: Text(AppLocalizations.of(context).translate('lovers')),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              Divider(
                height: 2,
              ),
              ListTile(
                title: Text(AppLocalizations.of(context).translate('quit')),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              Divider(
                height: 2,
              ),
              ListTile(
                title: Text(AppLocalizations.of(context).translate('sug')),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MySuggestion()));
                },
              ),
              Divider(
                height: 2,
              ),
              ListTile(
                title: Text(
                    AppLocalizations.of(context).translate('result_all')),
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
                Text(AppLocalizations.of(context).translate('admin')),
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
                title: Text(AppLocalizations.of(context).translate('setting')),
                onTap: () {
                  // Update the state of the app.
                  // ...
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
            height: MediaQuery
                .of(context)
                .size
                .height / 2.4,
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : !hasData
                  ? Center(
                child: Text(
                    AppLocalizations.of(context).translate('no_act')),
              )
                  : GridView.count(
                  scrollDirection: Axis.vertical,
                  crossAxisCount: 3,
                  children: new List<Widget>.generate(
                      actionModelList.length, (index) {
                    return Center(
                      child: choiceCard(context, index, true),
                    );
                  })),
            ),
          ),
          PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: Expanded(
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: isLoadingPoints
                      ? Center(child: CircularProgressIndicator())
                      : !hasDataPoints
                      ? Center(
                    child: Text(
                        AppLocalizations.of(context).translate('no_result')),
                  )
                      : GridView.count(
                      scrollDirection: Axis.vertical,
                      crossAxisCount: 3,
                      children: new List<Widget>.generate(
                          pointsList.length, (index) {
                        return Center(
                          child: choiceCard(context, index, false),
                        );
                      })),
//              Container(
//                child: Center(
//                    child: Text(
//                        AppLocalizations.of(context).translate('no_result'))),
//              ),
                ),
              ),
            ),
          ),
        ]));
  }

  Container choiceCard(context, index, bool isActionList) {
    return Container(
        padding: EdgeInsets.all(4.0),
        child: Center(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: InkWell(
                      onTap: isActionList ? () =>
                      {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) =>
                                MyAction(
                                  actionList: actionModelList[index],
                                ))),
                      } : () =>
                      {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) =>
                                PointsDetails(
                                  points: pointsList[index],
                                ))),
                      },
                      child: ClipOval(
                        child: Container(
                            color: backgroundColor2,
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Center(
                                child: isActionList ? Text(
                                  actionModelList[index].action ?? '',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: remWhite,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ) : Column(
                                  children: [
                                    Text(
                                      pointsList[index].competiation ?? '',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: remWhite,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                    Text(
                                      pointsList[index].sum.toString() ?? '',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: remWhite,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ],
                                ))),
                      ),
                    )),
              ]),
        ));
  }

  void getActions() {
    FirebaseFirestore.instance
        .collection("actions")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print(result.data());
        List<String> elementList = [];
        elementList.clear();
        result.data()["element"].forEach((i) {
          elementList.add(i);
        });
        List<String> pointList = [];
        pointList.clear();
        result.data()["point"].forEach((i) {
          pointList.add(i);
        });
        setState(() {
          actionModelList.add(ActionsModel(
              action: result.data()["action"],
              element: elementList, point: pointList));
        });
        print('profile$actionModelList');
        isLoading = false;
        hasData = true;
      });
    });
  }

  void getPoints() {
    DateTime now = DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String date = formatter.format(now);
    var firebaseUser = FirebaseAuth.instance.currentUser;

    FirebaseFirestore.instance
        .collection("point")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        if (result.id.contains(firebaseUser.uid.toString() + date)) {
          print(result.data());
          setState(() {
            pointsList.add(Points(
              username: result.data()["user_name"],
              date: result.data()["date"],
              competiation: result.data()["competiation"],
              sum: result.data()["points"],
            ));
          });
          print('profile$pointsList');
        }
      });
    }).whenComplete(() {
      setState(() {
        if (pointsList.isNotEmpty) {
          setState(() {
            isLoadingPoints = false;
            hasDataPoints = true;
          });
        } else {
          isLoadingPoints = false;
          hasDataPoints = false;
        }
      });
    });
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
