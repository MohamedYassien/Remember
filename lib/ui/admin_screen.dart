import 'package:flutter/material.dart';
import 'package:remember/ui/action_screen.dart';
import 'package:remember/ui/suggestions_screen.dart';

import '../AppLocalizations.dart';
import '../app_constants.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  List<String> panelList = ['الاقتراحات', 'المبادرات'];

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
              Navigator.of(context).pop();
            },
          ),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: backgroundColor,
          centerTitle: true,
          elevation: 0,
          title: Text(
            AppLocalizations.of(context).translate('control'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
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
                              builder: (context) => SuggestionsScreen()));
                      break;
                    case 1:
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddActionScreen()));
                      break;
                    case 2:
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
                        style: TextStyle(fontSize: 22),
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
    Navigator.of(context).pop();
    return Future(() => false);
  }
}
