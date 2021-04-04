import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remember/model/user_questionnaire.dart';
import 'package:sticky_headers/sticky_headers.dart';

import '../AppLocalizations.dart';
import '../app_constants.dart';
import '../app_utils.dart';

class QuestionnaireResultScreen extends StatefulWidget {
  String questionnaire;
  List<String> elementList;

  QuestionnaireResultScreen({this.questionnaire, this.elementList});

  @override
  _QuestionnaireResultScreenState createState() =>
      _QuestionnaireResultScreenState();
}

class _QuestionnaireResultScreenState extends State<QuestionnaireResultScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  bool hasData = false;
  List<String> mixedList = [];
  var map = Map();
  List<QuestionnaireModelList> questionnairelist = [];

  @override
  void initState() {
    super.initState();
    getQuestionnaire();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
          backgroundColor: themeColor,
          centerTitle: true,
          elevation: 0,
          title: Text(
            AppLocalizations.of(context).translate('res_quest'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontFamily: 'Tajawal-Regular',
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
        ),
        body: SafeArea(
          child: !isLoading
              ? Center(child: CircularProgressIndicator())
              : hasData
                  ? Column(
                      children: [
                        Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 0.5,
                                  blurRadius: 9,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                )
                              ],
                            ),
                            alignment: Alignment.topRight,
                            child: ClipPath(
                              clipper: ShapeBorderClipper(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15))),
                              child: Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  'الاستفتاء : ' + widget.questionnaire,
                                  style: TextStyle(
                                      fontFamily: 'Tajawal-Regular',
                                      fontSize: 15),
                                ),
                              ),
                            )),
                        questionnairListWidget(context, questionnairelist),
                        questionnaireElementListWidget(
                            context, widget.elementList),
                      ],
                    )
                  : Center(
                      child: Text(AppLocalizations.of(context)
                          .translate('no_res_quest')),
                    ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() {
    Navigator.of(context).pop();
    return Future(() => false);
  }

  Widget questionnaireElementListWidget(
      BuildContext context, List<String> _list) {
    // backing data
    final size = MediaQuery.of(context).size;
    return Expanded(
      child: Container(
        alignment: Alignment.bottomCenter,
        width: size.width,
        height: size.height,
        child: ListView.builder(
          padding: const EdgeInsets.all(5.5),
          itemCount: _list.length,
          itemBuilder: _itemBuilder2,
        ),
      ),
    );
  }

  Widget _itemBuilder2(BuildContext context, int index) {
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
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.elementList[index] + ' : ',
                            style:
                            TextStyle(fontFamily: 'Tajawal-Regular',
                                color: Colors.black,
                                fontSize: 16)),
                        Text(
                            map[widget.elementList[index]] != null
                                ? (map[widget.elementList[index]]).toString()
                                : '0',
                            style:
                            TextStyle(fontFamily: 'Tajawal-Regular',
                                color: Colors.black,
                                fontSize: 16)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        onTap: () {});
  }

  void getQuestionnaire() {
    mixedList.clear();
    map.clear();
    DateTime now = DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String date = formatter.format(now);
    FirebaseFirestore.instance
        .collection("result_questionnair")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        List<String> elementList = [];
        elementList.clear();
        if (result.data()["question"] == widget.questionnaire) {
          print(result.data());
          result.data()["choice_elment"].forEach((i) {
            elementList.add(i);
          });
          result.data()["choice_elment"].forEach((i) {
            mixedList.add(i);
          });
          setState(() {
            questionnairelist.add(QuestionnaireModelList(
                question: result.data()["question"],
                choiceElement: elementList,
                userName: result.data()["user_name"],
                date: result.data()["date"]));
          });
        }
      });
      setState(() {
        mixedList.forEach((element) {
          if (!map.containsKey(element)) {
            map[element] = 1;
          } else {
            map[element] += 1;
          }
        });
        print('mixed $mixedList');
        print('map ${map["نعم"]}');
      });
      if (map.isNotEmpty) {
        setState(() {
          hasData = true;
          isLoading = true;
        });
        print(">>>>>>>>>>>>");
      } else {
        setState(() {
          isLoading = true;
          hasData = false;
        });
        print("<<<<<<<<<<<<<<");
      }
    });
  }

  Widget questionnairListWidget(
      BuildContext context, List<QuestionnaireModelList> _list) {
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
              child: customCardQuestionnair(
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
