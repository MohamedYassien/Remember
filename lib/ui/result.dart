import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remember/ui/home_page.dart';

import '../AppLocalizations.dart';
import '../app_constants.dart';
import '../app_utils.dart';

class MyResult extends StatefulWidget {
  List<String> pointsIndex;
  List<String> pointsList;
  String competiation;

  MyResult({this.pointsIndex, this.pointsList, this.competiation});

  @override
  _MyResultState createState() => _MyResultState();
}

class _MyResultState extends State<MyResult> {
  List<int> point = [];
  int sum;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    calculateResult();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: themeColor,
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: backgroundColor,
            centerTitle: true,
            elevation: 0,
            title: Text(
              AppLocalizations.of(context).translate('result'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontFamily: 'Tajawal-Regular',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            )),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10.0),
                height: MediaQuery.of(context).size.height / 2.4,
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Center(
                          child: choiceCard(context),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
    return Future(() => false);
  }

  void calculateResult() {
    for (var i = 0; i < widget.pointsIndex.length; i++) {
      print('widget.pointsIndex${widget.pointsIndex[i].trimRight()}');
      print(
          ">>>>>>>>${widget.pointsList[int.parse(widget.pointsIndex[i].trimRight())]}");
      point.add(int.parse(
          widget.pointsList[int.parse(widget.pointsIndex[i].trimRight())]));
    }
    setState(() {
      sum = point.fold(0, (previous, current) => previous + current);
      isLoading = false;
    });
    addPoints();
  }

  Container choiceCard(context) {
    return Container(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: InkWell(
                  onTap: () {},
                  child: ClipOval(
                    child: Container(
                        color: backgroundColor2,
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Center(
                            child: Text(
                          sum.toString() ?? '',
                          textAlign: TextAlign.center,
                              style: TextStyle(fontFamily: 'Tajawal-Regular',
                              color: remWhite,
                              fontWeight: FontWeight.bold,
                              fontSize: 100),
                        ))),
                  ),
                )),
              ]),
        ));
  }

  Future<void> addPoints() async {
    DateTime now = DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd hh:mm:ss');
    String date = formatter.format(now);
    String username = await getUserName();
    var firebaseUser = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection("point")
        .doc(firebaseUser.uid + date.toString())
        .set({
      "date": date,
      "points": sum,
      "user_name": username.toString(),
      "competiation": widget.competiation,
    }).then((_) {
//      setState(() {
//        isLoadingSaving = false;
//      });
//      _showToast(AppLocalizations.of(context).translate('save_done'));
      print("success!");
    });
  }
}
