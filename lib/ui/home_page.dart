import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:remember/model/actions.dart';
import 'package:remember/ui/action_screen.dart';

import '../AppLocalizations.dart';
import '../app_constants.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isAdmin = false;
  List<ActionsModel> actionModelList = [];
  bool isLoading = true;
  bool hasData = false;

  @override
  void initState() {
    super.initState();
    getAdmin();
    getActions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          )),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(AppLocalizations.of(context).translate('side_menu')),
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
                // Update the state of the app.
                // ...
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
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddActionScreen()));
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
                  : !hasData ? Center(
                child: Text(AppLocalizations.of(context).translate('no_act')),
              ) : GridView.count(
                  scrollDirection: Axis.vertical,
                  crossAxisCount: 3,
                  children: new List<Widget>.generate(
                      actionModelList.length, (index) {
                    return Center(
                      child: choiceCard(context, index),
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
                  child: Container(
                    child: Center(child: Text(
                        AppLocalizations.of(context).translate('no_result'))),
                  ),
                ),
              ),
            ),
          ),
        ]));
  }

  Container choiceCard(context, index) {
    return Container(
        padding: EdgeInsets.all(4.0),
        child: Center(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: InkWell(
                      onTap: () => {},
                      child: ClipOval(
                        child: Container(
                            color: backgroundColor2,
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Center(
                                child: Text(
                                  actionModelList[index].action ?? '',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: remWhite, fontWeight: FontWeight
                                      .bold),
                                ))),
                      ),
                    )),
              ]),
        ));
  }

  void getActions() {
    FirebaseFirestore.instance.collection("actions").get().then((
        querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print(result.data());
        List<String> elementList = [];
        elementList.clear();
        result.data()["element"].forEach((i) {
          elementList.add(i);
//                  print('profile$elementList');

        });
        setState(() {
          actionModelList.add(ActionsModel(action: result.data()["action"]
              , element: elementList));
        });
        print('profile$actionModelList');
        isLoading = false;
        hasData = true;
      });
    });
  }
}
