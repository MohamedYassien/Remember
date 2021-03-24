import 'package:flutter/material.dart';
import 'package:remember/ui/action_screen.dart';
import 'package:remember/ui/home_page.dart';
import 'package:remember/ui/questionair_screen.dart';
import 'package:remember/ui/suggestions_screen.dart';

import '../AppLocalizations.dart';
import '../app_constants.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  List<String> panelList = ['الاستفتاءات', 'الاقتراحات', 'المبادرات'];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: backgroundColor2,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomePage(
                          )));
            },
          ),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: themeColor,
          centerTitle: true,
          elevation: 0,
          title: Text(
            AppLocalizations.of(context).translate('control'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontFamily: 'Tajawal-Regular',
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        body: new GridView.count(
          crossAxisCount: 2,
          children: new List<Widget>.generate(panelList.length, (index) {
            return new GridTile(
              child: GestureDetector(
                onTap: () {
                  switch (index) {
                    case 0:
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QuestionnaireScreen()));
                      break;
                    case 1:
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SuggestionsScreen()));
                      break;
                    case 2:
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddActionScreen()));
                      break;
                    default:
                      {}
                  }
                },
                child: new Card(
                    color: remWhite,
                    child: new Center(
                      child: new Text(
                        '${panelList[index]}',
                        style: TextStyle(fontFamily: 'Tajawal-Regular',
                            fontSize: 22),
                      ),
                    )),
              ),
            );
          }),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                HomePage(
                )));
    return Future(() => false);
  }
}
