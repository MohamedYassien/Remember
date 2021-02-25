import 'package:cloud_firestore/cloud_firestore.dart';
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

  List<Points> pointsList = [];
  String selectData;
  String text;

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
          backgroundColor: backgroundColor,
          centerTitle: true,
          elevation: 0,
          title: Text(
            AppLocalizations.of(context).translate('result_all'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          )),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
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
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                            ),
                          )
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
        if (result.id.contains(selectData)) {
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
}
