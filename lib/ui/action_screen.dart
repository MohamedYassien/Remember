import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:remember/model/actions.dart';
import 'package:remember/ui/action_details.dart';
import 'package:remember/ui/admin_screen.dart';

import '../AppLocalizations.dart';
import '../app_constants.dart';
import '../app_utils.dart';

class AddActionScreen extends StatefulWidget {
  @override
  _AddActionScreenState createState() => _AddActionScreenState();
}

class _AddActionScreenState extends State<AddActionScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  bool hasData = false;
  List<ActionsModel> actionsList = [];

  @override
  void initState() {
    super.initState();
    getAction();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: backgroundColor2,
        key: scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AdminPanel(
                          )));
            },
          ),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: backgroundColor,
          centerTitle: true,
          elevation: 0,
          title: Text(
            AppLocalizations.of(context).translate('add_act'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontFamily: 'Tajawal-Regular',
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ActionDetails()));
                })
          ],
        ),
        body: SafeArea(
          child: !isLoading
              ? Center(child: CircularProgressIndicator())
              : hasData
              ? Column(
            children: [
              actionList(context, actionsList),
            ],
          )
              : Center(
            child: Text(
              AppLocalizations.of(context).translate('no_act'),
              style: TextStyle(fontFamily: 'Tajawal-Regular',
              ),),
          ),
        ),
      ),
    );
  }

  Widget actionList(BuildContext context, List<ActionsModel> _list) {
    // backing data
    final size = MediaQuery.of(context).size;
    return Expanded(
      child: Container(
        width: size.width,
        height: size.height,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: _list.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.all(5.0),
              child: customCard(
                _list.elementAt(index),
                context,
              ),
            );
          },
        ),
      ),
    );
  }

  void getAction() {
    if (FirebaseFirestore.instance.collection("actions") != null) {
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
//                  print('profile$elementList');
          });
          setState(() {
            actionsList.add(ActionsModel(
                action: result.data()["action"], element: elementList));
          });
        });
        setState(() {
          hasData = true;
          isLoading = true;
        });
        print(">>>>>>>>>>>>");
      });
    } else {
      setState(() {
        isLoading = true;
        hasData = false;
      });
      print("<<<<<<<<<<<<<<");
    }
  }

  Future<bool> _onWillPop() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AdminPanel(
                )));
    return Future(() => false);
  }
}
