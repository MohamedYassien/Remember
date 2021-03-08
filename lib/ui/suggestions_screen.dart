import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:remember/model/questions.dart';
import 'package:remember/ui/suggestion_details.dart';
import 'package:remember/ui/user_suggestion.dart';

import '../AppLocalizations.dart';
import '../app_constants.dart';

class SuggestionsScreen extends StatefulWidget {
  @override
  _SuggestionsScreenState createState() => _SuggestionsScreenState();
}

class _SuggestionsScreenState extends State<SuggestionsScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  bool hasData = false;
  List<Questions> suggestionList = [];

  @override
  void initState() {
    super.initState();
    getSuggestions();
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
          backgroundColor: backgroundColor,
          centerTitle: true,
          elevation: 0,
          title: Text(
            AppLocalizations.of(context).translate('add_sug'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SuggestionDetails()));
                })
          ],
        ),
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
                      child: Text(
                          AppLocalizations.of(context).translate('no_sugg')),
                    ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() {
    Navigator.of(context).pop();
    return Future(() => false);
  }

  Widget suggestionListWidget(BuildContext context, List<Questions> _list) {
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

  void getSuggestions() {
    FirebaseFirestore.instance
        .collection("suggestions")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print(result.data());
        setState(() {
          suggestionList.add(Questions(
              question: result.data()["suggestion"],
              date: result.data()["date"]));
        });
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

  Widget _itemBuilder(BuildContext context, int index) {
    return InkWell(
        child: Card(
          child: Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            child: Text(suggestionList[index].question,
                style: TextStyle(color: Colors.black, fontSize: 16)),
          ),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UserSuggestions(
                        questions: suggestionList[index].question,
                      )));
        });
  }
}
