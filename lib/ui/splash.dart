import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_constants.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
      countDownTime();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Image.asset(
        'assets/ic_splash.png',
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.fill,
      ),
      Positioned(
        width: MediaQuery.of(context).size.width,
        top: MediaQuery.of(context).size.height*.8,
        child: textCard('تلاقينا بدرب الله, تعارفنا لأجل الله,تواصينا بتقوى الله, تحصنا بذكر الله.لعلهم يتذكرون💜صحبة تأخذك للجنة.تغدوا رفاتا ويبقى الأثر'),
      )
    ]);
  }

  final int splashDuration = 10;

  countDownTime() async {
    return Timer(Duration(seconds: splashDuration), () {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      Navigator.of(context).pushNamed('/Home');
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
                    style: TextStyle(color: Colors.black,
                        fontSize: 16,decoration: TextDecoration.none)),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
