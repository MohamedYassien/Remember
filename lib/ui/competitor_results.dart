import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remember/model/points.dart';

import '../AppLocalizations.dart';
import '../app_constants.dart';
import '../app_utils.dart';

class CompetitorResults extends StatefulWidget {
  @override
  _CompetitorResultsState createState() => _CompetitorResultsState();
}

class _CompetitorResultsState extends State<CompetitorResults> {
  bool isLoading = false;
  bool hasData;
  bool isAdmin = false;
  String dropdownValue = 'قم باختيار اسم المبادرة ';
  String dropdownValue2 = 'قم باختيار اسم المتسابق ';
  List<String> actionList = [];
  List<String> compititorName = [];
  List<Points> pointsList = [];
  List<int> pointsListSum = [];
  String selectData;
  String text;
  int sum;

  @override
  void initState() {
    super.initState();
    getAdmin();
    actionList.insert(0, dropdownValue);
    compititorName.insert(0, dropdownValue2);
    getUsers();
    getActions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor2,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: themeColor,
        centerTitle: true,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context).translate('result_all'),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontFamily: 'Tajawal-Regular',
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          isAdmin
              ? IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  isLoading = true;
                });
                getPointsSum();
              })
              : SizedBox(),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            isAdmin
                ? Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 1,
              margin: EdgeInsets.only(top: 15),
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
                child: compititorName.isNotEmpty
                    ? Container(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: DropdownButton<String>(
                      value: dropdownValue2,
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(fontFamily: 'Tajawal-Regular',
                          color: Colors.red, fontSize: 18),
                      onChanged: (String data) {
                        setState(() {
                          dropdownValue2 = data;
                        });
                      },
                      items: compititorName
                          .map<DropdownMenuItem<String>>(
                              (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Container(
                                  margin: EdgeInsets.only(
                                      right: 15, left: 15),
                                  child: Text(value)),
                            );
                          }).toList(),
                    ),
                  ),
                )
                    : SizedBox(),
              ),
            )
                : SizedBox(),
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 1,
              margin: EdgeInsets.only(top: 15),
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
                child: actionList.isNotEmpty
                    ? Container(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(fontFamily: 'Tajawal-Regular',
                          color: Colors.red,
                          fontSize: 18),
                      onChanged: (String data) {
                        setState(() {
                          dropdownValue = data;
                        });
                      },
                      items: actionList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Container(
                              margin:
                              EdgeInsets.only(right: 15, left: 15),
                              child: Text(value)),
                        );
                      }).toList(),
                    ),
                  ),
                )
                    : SizedBox(),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              padding: EdgeInsets.all(5),
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
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppLocalizations.of(context)
                            .translate('choose_date')),
                        IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () => showDatePickerfun(context)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            isLoading
                ? CircularProgressIndicator(
                    backgroundColor: remWhite,
                  )
                : hasData != null
                    ? hasData
                        ? pointList(context, pointsList)
                        : Container(
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.only(top: 150),
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('No_date'),
                                  style: TextStyle(
                                      fontFamily: 'Tajawal-Regular',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                            ),
                          )
                    : SizedBox(),
            isAdmin && sum != null
                ? pointListSumition(context, sum)
                : SizedBox(),

          ],
        ),
      ),
    );
  }

  Future<DateTime> showDatePickerfun(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2021, 2),
        lastDate: DateTime(2101));
    if (picked != null) {
      print('>>>>>>>>>>${picked.toString()}');
      setState(() {
        var formatter = new DateFormat('yyyy-MM-dd');

        selectData = formatter.format(picked);
        isLoading = true;
      });
      pointsList.clear();
      getPoints();
    } else {
      print('<<<<<<<<<cancel');
    }
    return picked;
  }

  void getPoints() {
    FirebaseFirestore.instance.collection("point").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        if (result.id.contains(selectData) &&
            result.data()["competiation"] == dropdownValue) {
          print('>>>>>>${result.data()}');
          setState(() {
            pointsList.add(Points(
              username: result.data()["user_name"],
              date: result.data()["date"],
              competiation: result.data()["competiation"],
              sum: result.data()["points"],
            ));
          });
        }
      });
    }).whenComplete(() {
      if (pointsList.isNotEmpty) {
        print('>>>>>${pointsList.length}');
        setState(() {
          isLoading = false;
          hasData = true;
        });
      } else {
        print('<<<<<<<${pointsList.length}');
        setState(() {
          isLoading = false;
          hasData = false;
        });
      }
    });
  }

  void getActions() {
    FirebaseFirestore.instance
        .collection("actions")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print(result.data()["action"]);
        setState(() {
          actionList.add(result.data()["action"]);
        });
      });
    });
  }

  Widget pointList(BuildContext context, List<Points> _list) {
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
              child: customCardPoint(
                _list.elementAt(index),
                context,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget pointListSumition(BuildContext context, int sum) {
    // backing data
    final size = MediaQuery
        .of(context)
        .size;
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: size.width,
          height: size.height * .1,
          child: Container(
            padding: EdgeInsets.all(5.0),
            child: customCardSumResult(
              sum.toString(),
              context,
            ),
          ),
        ),
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

  void getUsers() {
    FirebaseFirestore.instance.collection("users").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        setState(() {
          compititorName.add(result.data()["fname"] + result.data()["lname"]);
        });
      });
    });
  }

  void getPointsSum() {
    pointsListSum.clear();
    FirebaseFirestore.instance.collection("point").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        if (result.data()["user_name"] == dropdownValue2 &&
            result.data()["competiation"] == dropdownValue) {
          print('>>>>>>${result.data()["points"]}');
          setState(() {
            pointsListSum.add(
              result.data()["points"],
            );
          });
        }
      });
    }).whenComplete(() {
      setState(() {
        isLoading = false;
        calculateSum();
      });
    });
  }

  void calculateSum() {
    setState(() {
      sum = pointsListSum.fold(0, (previous, current) => previous + current);
//      isLoading = false;
    });
  }
}
