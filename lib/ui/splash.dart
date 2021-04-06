import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:remember/ui/basic_home.dart';
import 'package:remember/ui/login.dart';

import '../AppLanguage.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    countDownTime();
  }

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);
    appLanguage.changeLanguage(Locale("ar"));
    return Stack(children: <Widget>[
      Image.asset(
        'assets/ic_sp.png',
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.fill,
      ),
    ]);
  }

  final int splashDuration = 2;

  countDownTime() async {
    return Timer(Duration(seconds: splashDuration), () {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
//      Navigator.pushAndRemoveUntil(
//        context,
//        MaterialPageRoute(
//          builder: (BuildContext context) => LoginScreen(),
//        ),
//            (route) => false,
//      );
      getCurrentUser().then((value) {
        if (value == null) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => LoginScreen(),
            ),
                (route) => false,
          );
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => BasicHomePage(),
            ),
                (route) => false,
          );
        }
      });
    });
  }

  Widget textCard(var string) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Color(0xFFd1e29e).withOpacity(.5),
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFd1e29e).withOpacity(0.5),
            spreadRadius: 0.5,
            blurRadius: 0,
          )
        ],
      ),
      //color: obj.color,
      child: ClipPath(
        clipper: ShapeBorderClipper(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    string,
                    maxLines: 4,
//                    '${AppLocalizations.of(context).translate('node')} :${obj.node}',
                    style: TextStyle(
                        color: Colors.black, fontFamily: 'Tajawal-Regular',
                        fontSize: 16,decoration: TextDecoration.none)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<User> getCurrentUser() async {
    User user = _auth.currentUser;

    if (user != null) {
      return user;
    } else {
      return null;
    }
  }

}
