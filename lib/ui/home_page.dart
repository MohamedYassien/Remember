import 'package:flutter/material.dart';

import '../AppLocalizations.dart';
import '../app_constants.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: backgroundColor,
          centerTitle: true,
          elevation: 0,
          title: Text(
            AppLocalizations.of(context).translate('Home'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          )),
      drawer: Drawer(child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(AppLocalizations.of(context)
                .translate('side_menu')),
            decoration: BoxDecoration(
              color: backgroundColor,
            ),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)
                .translate('eb')),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          Divider(height: 2,),
          ListTile(
            title: Text(AppLocalizations.of(context)
                .translate('lovers')),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          Divider(height: 2,),
          ListTile(
            title: Text(AppLocalizations.of(context)
                .translate('setting')),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          Divider(height: 2,),
        ],
      ),),
    );
  }
}
