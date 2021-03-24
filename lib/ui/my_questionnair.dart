import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remember/model/questionnaire.dart';
import 'package:remember/ui/home_page.dart';

import '../AppLocalizations.dart';
import '../app_constants.dart';
import '../app_utils.dart';

class MyQuestionnair extends StatefulWidget {
  String quest;

  MyQuestionnair({this.quest});

  @override
  _MyQuestionnairState createState() => _MyQuestionnairState();
}

class _MyQuestionnairState extends State<MyQuestionnair> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String question;
  List<String> elementList = [];
  List<QuestionnaireModel> questionList = [];
  List<String> choiceElement = [];
  Map<int, bool> values = {};
  String date = '';
  bool isResult = false;
  bool isLoadingSubmit = false;
  var username;
  bool isEdit;
  bool isMulti;
  bool hasData = false;
  bool isLoading = true;
  int id = -1;

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
          backgroundColor: themeColor,
          centerTitle: true,
          elevation: 0,
          title: Text(
            AppLocalizations.of(context).translate('quest'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontFamily: 'Tajawal-Regular',
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
                          AppLocalizations.of(context)
                              .translate('already_ques'),
                          style: TextStyle(fontFamily: 'Tajawal-Regular',
                              color: remWhite,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
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
                                          borderRadius:
                                              BorderRadius.circular(15))),
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    padding: EdgeInsets.all(5),
                                    child: Text(
                                      'الاستفتاء : ' + question,
                                      style: TextStyle(
                                          fontFamily: 'Tajawal-Regular',
                                          fontSize: 15),
                                    ),
                                  ),
                                )),
                            actionList(context, elementList),
                            Container(
                                width: MediaQuery.of(context).size.width * .5,
                                height: MediaQuery.of(context).size.width * .1,
                                margin: EdgeInsets.only(bottom: 20),
                                child: RaisedButton(
                                    color: themeColor,
                                    child: isLoadingSubmit
                                        ? CircularProgressIndicator(
                                            backgroundColor: remWhite,
                                          )
                                        : Text(
                                            AppLocalizations.of(context)
                                                .translate('submit_qu'),
                                      style: TextStyle(
                                          fontFamily: 'Tajawal-Regular',
                                          color: remWhite),
                                          ),
                                    onPressed: () {
                                      setState(() {
                                        isLoadingSubmit = true;
                                      });
                                      addResults();
                                    }))
                          ],
                        )
                      : Center(
                          child: Text(AppLocalizations.of(context)
                              .translate('no_question')),
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
                                style: TextStyle(fontFamily: 'Tajawal-Regular',
                                    color: Colors.black, fontSize: 16)),
                            isMulti
                                ? Checkbox(
                                    value: values[index],
                                    onChanged: (value) => setState(() {
                                          values[index] = value;
                                          if (values[index]) {
                                            choiceElement
                                                .add(_list.elementAt(index));
                                          } else {
                                            choiceElement
                                                .remove(_list.elementAt(index));
                                          }
                                          print(
                                              'choiceElement : $choiceElement');
                                        }))
                                : Radio(
                                    value: index + 1,
                                    groupValue: id,
                                    activeColor: Colors.blue,
                                    onChanged: (value) => setState(() {
                                          print('>>>$value');
//                                values[value-1] = true;
                                          id = value;
                                          choiceElement.clear();
                                          choiceElement
                                              .add(_list.elementAt(index));

                                          print(
                                              'choiceElement : $choiceElement');
                                        })),
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
    getMyQuestion();
//    print('77777: $elementList');
//    setState(() {
//      for (var i = 0; i < elementList.length; i++) {
//        values[i] = false;
//      }
//    });
    DateTime now = DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd hh:mm:ss');
    setState(() {
      date = formatter.format(now);
    });
    username = await getUserName();
  }

  void addResults() {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection("result_questionnair")
        .doc(firebaseUser.uid + date.toString())
        .set({
      "date": date,
      "choice_elment": FieldValue.arrayUnion(choiceElement),
      "question": question,
      "user_name": username.toString(),
      "done": true,
    }).then((_) {
      setState(() {
        isLoadingSubmit = false;
      });
      _showToast(AppLocalizations.of(context).translate('save_done'));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
      print("success!");
    });
  }

  void _showToast(String message) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(message,
            style: TextStyle(fontFamily: 'Tajawal-Regular',
              fontSize: chat_text_font_size,
              fontWeight: FontWeight.normal,
            ))));
  }

  void getMyQuestion() {
    DateTime now = DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String dateNow = formatter.format(now);

    var firebaseUser = FirebaseAuth.instance.currentUser;
    if (FirebaseFirestore.instance.collection("result_questionnair") != null) {
      FirebaseFirestore.instance
          .collection("result_questionnair")
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          print('----------${result.data()}');
          if (result.id.contains(firebaseUser.uid) &&
              result.data()["question"] == widget.quest &&
              result.data()["done"] == true) {
            print('<<<<<<<<<>>>>>>>>');
            setState(() {
              isEdit = true;
              isLoading = false;
            });
          } else {
            print('hiiiiii');
          }
        });
      }).whenComplete(() {
        print('///////////');

        setState(() {
          print('Edit$isEdit');
          if (isEdit == null) {
            setState(() {
              isEdit = false;
            });
            getQuestionnaire();
          }
        });
      });
    } else {
      setState(() {
        isEdit = false;
      });
      getQuestionnaire();
    }
  }

  Future<void> getQuestionnaire() async {
    DateTime now = DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String date = formatter.format(now);
    username = await getUserName();

    FirebaseFirestore.instance
        .collection("questionnaires")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print('<><><>${result.data()}');
        if (result.data()["question"] == widget.quest) {
          List<String> elementQuestionList = [];
          elementList.clear();
          result.data()["element"].forEach((i) {
            elementQuestionList.add(i);
//                  print('profile$elementList');
          });
          setState(() {
            questionList.add(QuestionnaireModel(
                question: result.data()["question"],
                element: elementQuestionList,
                isMulti: result.data()["multi"]));
            elementList = elementQuestionList;
            question = result.data()["question"];
            isMulti = result.data()["multi"];
            isLoading = false;
            hasData = true;
          });
        }
      });
    }).whenComplete(() {
      setState(() {
        if (questionList != null) {
          setState(() {
            isLoading = false;
            hasData = true;
            for (var i = 0; i < elementList.length; i++) {
              values[i] = false;
            }
          });
        } else {
          isLoading = false;
          hasData = false;
        }
      });
    });
  }
}
