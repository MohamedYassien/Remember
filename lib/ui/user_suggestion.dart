import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remember/model/suggestions.dart';

import '../AppLocalizations.dart';
import '../app_constants.dart';
import '../app_utils.dart';

class UserSuggestions extends StatefulWidget {
  String questions;

  UserSuggestions({this.questions});

  @override
  _UserSuggestionsState createState() => _UserSuggestionsState();
}

class _UserSuggestionsState extends State<UserSuggestions> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  bool hasData = false;
  List<Suggestions> suggestionList = [];

  @override
  void initState() {
    super.initState();
    getSuggestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor2,
      key: scaffoldKey,
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
            AppLocalizations.of(context).translate('sug_det'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontFamily: 'Tajawal-Regular',
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          )),
      body: SafeArea(
        child: !isLoading
            ? Center(child: CircularProgressIndicator())
            : hasData
                ? Column(
                    children: [
                      suggestionListWidget(context, suggestionList),
                    ],
                  )
                : Center(
                    child:
                    Text(AppLocalizations.of(context).translate('no_sugg'),
                      style: TextStyle(fontFamily: 'Tajawal-Regular',),),
                  ),
      ),
    );
  }

  Widget suggestionListWidget(BuildContext context, List<Suggestions> _list) {
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
              child: customCardSuggestion(
                _list.elementAt(index),
                context,
              ),
            );
          },
        ),
      ),
    );
  }

  void getSuggestions() {
    DateTime now = DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String date = formatter.format(now);
    FirebaseFirestore.instance
        .collection("users_suggestions")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        if (result.data()["question"] == widget.questions) {
          print(result.data());
          setState(() {
            suggestionList.add(Suggestions(
                username: result.data()["username"],
                date: result.data()["date"],
                answer: result.data()["answer"]));
          });
        }
      });
      if (suggestionList.isNotEmpty) {
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
}
