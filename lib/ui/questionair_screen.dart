import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:remember/model/questionnaire.dart';
import 'package:remember/ui/admin_screen.dart';
import 'package:remember/ui/questionnair_details.dart';
import 'package:remember/ui/questionnair_result.dart';

import '../AppLocalizations.dart';
import '../app_constants.dart';

class QuestionnaireScreen extends StatefulWidget {
  @override
  _QuestionnaireScreenState createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  bool hasData = false;
  List<QuestionnaireModel> questionnaireList = [];

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
        backgroundColor: themeColor,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => AdminPanel()));
            },
          ),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: backgroundColor,
          centerTitle: true,
          elevation: 0,
          title: Text(
            AppLocalizations.of(context).translate('add_quest'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontFamily: 'Tajawal-Regular',
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => QuestionnairDetails()));
                })
          ],
        ),
        body: SafeArea(
          child: !isLoading
              ? Center(child: CircularProgressIndicator())
              : hasData
                  ? Column(
                      children: [
                        questionnaireListWidget(context, questionnaireList),
                      ],
                    )
                  : Center(
                      child: Text(
                          AppLocalizations.of(context).translate('no_quest')),
                    ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => AdminPanel()));
    return Future(() => false);
  }

  Widget questionnaireListWidget(
      BuildContext context, List<QuestionnaireModel> _list) {
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

  void getQuestionnaire() {
    FirebaseFirestore.instance
        .collection("questionnaires")
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
          questionnaireList.add(QuestionnaireModel(
              question: result.data()["question"], element: elementList));
        });
      });
      if (questionnaireList.isNotEmpty) {
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
              child: Text(questionnaireList[index].question,
                  style: TextStyle(fontFamily: 'Tajawal-Regular',
                      color: Colors.black,
                      fontSize: 16)),
            ),
          ),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => QuestionnaireResultScreen(
                        questionnaire: questionnaireList[index].question,
                        elementList: questionnaireList[index].element,
                      )));
        });
  }
}
