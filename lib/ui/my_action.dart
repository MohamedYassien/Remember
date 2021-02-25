import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remember/model/actions.dart';
import 'package:remember/ui/result.dart';

import '../AppLocalizations.dart';
import '../app_constants.dart';
import '../app_utils.dart';

class MyAction extends StatefulWidget {
  ActionsModel actionList;

  MyAction({this.actionList});

  @override
  _MyActionState createState() => _MyActionState();
}

class _MyActionState extends State<MyAction> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> elementList = [];
  List<String> pointList = [];
  bool isPoints = false;
  Map<int, bool> values = {};
  List<String> pointsIdsList = [];
  String date = '';
  bool isResult = false;
  bool isLoadingSaving = false;
  bool isLoadingSubmit = false;
  var username;
  bool isEdit;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initView();

    print('values$values');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
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
            widget.actionList.action,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          )),
      body: SafeArea(
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: remWhite,
                  ),
                )
              : isEdit
                  ? Center(
                      child: Container(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          AppLocalizations.of(context).translate('already'),
                          style: TextStyle(
                              color: remWhite,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        actionList(context, elementList),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width * .3,
                                child: RaisedButton(
                                    color: themeColor,
                                    child: isLoadingSaving
                                        ? CircularProgressIndicator(
                                            backgroundColor: remWhite,
                                          )
                                        : Text(
                                            AppLocalizations.of(context)
                                                .translate('save'),
                                            style: TextStyle(color: remWhite),
                                          ),
                                    onPressed: () {
                                      setState(() {
                                        isLoadingSaving = true;
                                      });
                                      addResults();
                                    })),
                            Container(
                                width: MediaQuery.of(context).size.width * .3,
                                child: RaisedButton(
                                    color: themeColor,
                                    child: isLoadingSubmit
                                        ? CircularProgressIndicator(
                                            backgroundColor: remWhite,
                                          )
                                        : Text(
                                            AppLocalizations.of(context)
                                                .translate('submit_points'),
                                            style: TextStyle(color: remWhite),
                                          ),
                                    onPressed: () {
                                      setState(() {
                                        isLoadingSubmit = true;
                                        isResult = true;
                                      });
                                      submitResults();
                                    })),
                          ],
                        )
                      ],
                    )),
    );
  }

  Widget actionList(BuildContext context, List<String> _list) {
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
              child: GestureDetector(
                onTap: () {},
                child: Container(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_list.elementAt(index),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16)),
                            Checkbox(
                                value: values[index],
                                onChanged: (value) => setState(() {
                                      values[index] = value;
                                      if (values[index]) {
                                        pointsIdsList.add(index.toString());
                                      } else {
                                        pointsIdsList.remove(index.toString());
                                      }
                                      print('pointListIDS$pointsIdsList');
                                    }))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> initView() async {
    getMyAction();
    setState(() {
      elementList = widget.actionList.element;
      pointList = widget.actionList.point;
      for (var i = 0; i < widget.actionList.element.length; i++) {
        values[i] = false;
      }
    });
    DateTime now = DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd hh:mm:ss');
    setState(() {
      date = formatter.format(now);
    });
    username = await getUserName();
    print('formatted$date');
    print('widget.actionList.points${pointList}');
  }

  void addResults() {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection("result")
        .doc(firebaseUser.uid + date.toString())
        .set({
      "date": date,
      "point_index": FieldValue.arrayUnion(pointsIdsList),
      "is_result": false,
      "competiation": widget.actionList.action,
      "user_name": username.toString(),
    }).then((_) {
      setState(() {
        isLoadingSaving = false;
      });
      _showToast(AppLocalizations.of(context).translate('save_done'));
      print("success!");
    });
  }

  void submitResults() {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection("result")
        .doc(firebaseUser.uid + date.toString())
        .update({
      "date": date,
      "point_index": FieldValue.arrayUnion(pointsIdsList),
      "is_result": true,
      "competiation": widget.actionList.action,
      "user_name": username.toString(),
    }).then((_) {
      setState(() {
        isLoadingSubmit = false;
      });
      _showToast(AppLocalizations.of(context).translate('save_done'));
      print('widget.actionList.points${widget.actionList.point}');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MyResult(
                    pointsIndex: pointsIdsList,
                    pointsList: widget.actionList.point,
                    competiation: widget.actionList.action,
                  )));
      print("success!");
    });
  }

  void _showToast(String message) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(message,
            style: TextStyle(
              fontSize: chat_text_font_size,
              fontWeight: FontWeight.normal,
            ))));
  }

  void getMyAction() {
    DateTime now = DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String dateNow = formatter.format(now);

    var firebaseUser = FirebaseAuth.instance.currentUser;

    FirebaseFirestore.instance.collection("result").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print('----------${result.data()}');
        if (result.id.contains(firebaseUser.uid.toString() + dateNow)) {
          if (widget.actionList.action == result.data()["competiation"]) {
            print('<<<<<<<<<>>>>>>>>');
            setState(() {
              isEdit = result.data()["is_result"];
            });
          }
        }
      });
    }).whenComplete(() {
      print('///////////');

      setState(() {
        isLoading = false;
        print('Edit$isEdit');
        if (isEdit == null) {
          setState(() {
            isEdit = false;
          });
        }
      });
    });
  }
}
