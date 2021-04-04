import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remember/model/suggestions.dart';
import 'package:remember/model/user.dart';
import 'package:remember/ui/basic_home.dart';

import '../AppLocalizations.dart';
import '../app_constants.dart';
import '../app_utils.dart';

class Lovers extends StatefulWidget {
  @override
  _LoversState createState() => _LoversState();
}

class _LoversState extends State<Lovers> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  List<Users> usersList = [];

  @override
  void initState() {
    super.initState();
    getUsers();
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BasicHomePage()));
            },
          ),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: themeColor,
          centerTitle: true,
          elevation: 0,
          title: Text(
            AppLocalizations.of(context).translate('lovers'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontFamily: 'Tajawal-Regular',
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          )),
      body: SafeArea(
          child: !isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    UsersListWidget(context, usersList),
                  ],
                )),
    );
  }

  Widget UsersListWidget(BuildContext context, List<Users> _list) {
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
              child: customCardUser(
                _list.elementAt(index),
                context,
              ),
            );
          },
        ),
      ),
    );
  }

  void getUsers() {
    FirebaseFirestore.instance.collection("users").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print(result.data());
        setState(() {
          usersList.add(Users(
              name: '${result.data()["fname"]} ${result.data()["lname"]} ',
              email: result.data()["email"],
              phone: result.data()["phone"]));
        });
      });
      if (usersList.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        print(">>>>>>>>>>>>");
      } else {
        setState(() {
          isLoading = true;
        });
        print("<<<<<<<<<<<<<<");
      }
    });
  }
}
