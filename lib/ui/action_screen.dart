import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:remember/model/actions.dart';
import 'package:remember/ui/action_details.dart';
import 'package:remember/ui/action_edit.dart';
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
          backgroundColor: themeColor,
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
          padding: const EdgeInsets.all(5.5),
          itemCount: _list.length,
          itemBuilder: _itemBuilder,
        ),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return InkWell(
        child: Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 0.5,
                blurRadius: 9,
                offset: Offset(0, 3), // changes position of shadow
              )
            ],
          ),
          child: ClipPath(
            clipper: ShapeBorderClipper(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(5),
              child: Text(actionsList[index].action,
                  style: TextStyle(fontFamily: 'Tajawal-Regular',
                      color: Colors.black,
                      fontSize: 16)),
            ),
          ),
        ),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) =>
                  ActionEdit(
                    actionsModel: actionsList[index],
                  )));
        });
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
          List<String> pointList = [];
          pointList.clear();
          result.data()["point"].forEach((i) {
            pointList.add(i);
//                  print('profile$elementList');
          });
          setState(() {
            actionsList.add(ActionsModel(
                action: result.data()["action"], element: elementList,
                point: pointList));
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
