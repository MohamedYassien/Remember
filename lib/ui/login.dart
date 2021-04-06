import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:remember/app_constants.dart';
import 'package:remember/ui/basic_home.dart';
import 'package:remember/ui/reset_pass.dart';
import 'package:remember/ui/sign_up.dart';

import '../AppLocalizations.dart';
import '../app_utils.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _textEditingControllerPassword =
  TextEditingController();
  TextEditingController _textEditingControllerUser = TextEditingController();
  bool isNoVisiblePassword = true;
  bool isLoading = false;
  final focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: themeColor,
          centerTitle: true,
          elevation: 0,
          title: Text(
            AppLocalizations.of(context).translate('login'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontFamily: 'Tajawal-Regular',
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          )),
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              color: themeColor,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              decoration: new BoxDecoration(
                  color: Color(0xFFF3F3F5),
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(50.0),
                    topRight: const Radius.circular(50.0),
                  )),
              child: buildBody(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        SizedBox(
          height: 0,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Form(
              key: _loginFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                        validator: (value) => emailValidator(value, context),
                        controller: this._textEditingControllerUser,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                            fontFamily: 'Tajawal-Regular',
                            color: Color(0xFF0F2E48),
                            fontSize: 14),
                        autofocus: false,
                        decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                "assets/icon_user.png",
                                width: 15,
                                height: 15,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide:
                                BorderSide(color: Color(0xFFAAB5C3))),
                            filled: true,
                            fillColor: Color(0xFFF3F3F5),
                            focusColor: Color(0xFFF3F3F5),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide:
                                BorderSide(color: Color(0xFFAAB5C3))),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(color: backgroundColor)),
                            hintText: AppLocalizations.of(context)
                                .translate('email'))),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: TextFormField(
                        focusNode: focus,
                        validator: (value) => pwdValidator(value, context),
                        controller: this._textEditingControllerPassword,
                        obscureText: this.isNoVisiblePassword,
                        style: TextStyle(
                            fontFamily: 'Tajawal-Regular',
                            color: Color(0xFF0F2E48),
                            fontSize: 14),
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              "assets/icon_password.png",
                              width: 15,
                              height: 15,
                            ),
                          ),
                          suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (this.isNoVisiblePassword)
                                    this.isNoVisiblePassword = false;
                                  else
                                    this.isNoVisiblePassword = true;
                                });
                              },
                              child: (this.isNoVisiblePassword)
                                  ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  "assets/icon_eye_close.png",
                                  width: 15,
                                  height: 15,
                                ),
                              )
                                  : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  "assets/icon_eye_open.png",
                                  width: 15,
                                  height: 15,
                                ),
                              )),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: Color(0xFFAAB5C3))),
                          filled: true,
                          fillColor: Color(0xFFF3F3F5),
                          focusColor: Color(0xFFF3F3F5),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: Color(0xFFAAB5C3))),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: backgroundColor)),
                          hintText: AppLocalizations.of(context)
                              .translate('password'),
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_loginFormKey.currentState.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        FocusScope.of(context).requestFocus(FocusNode());
                        FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                            email: _textEditingControllerUser.text,
                            password: _textEditingControllerPassword.text)
                            .then((currentUser) =>
                            FirebaseFirestore.instance
                                .collection("users")
                                .doc(currentUser.user.uid)
                                .get()
                                .then((DocumentSnapshot result) =>
                            {
                              setState(() {
                                isLoading = false;
                              }),
                              saveUid(
                                  currentUser.user.uid,
                                  result["fname"] +
                                      '' +
                                      result["lname"]),
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          BasicHomePage()))
                            })
                                .catchError((err) {
                              setState(() {
                                isLoading = false;
                              });
                              _showToast(
                                  'Something wrong. Please try again.');
                              print("error1${err.toString()}");
                            }))
                            .catchError((err) {
                          setState(() {
                            isLoading = false;
                          });
                          _showToast(getMessageFromErrorCode(err));
                          print("error2${getMessageFromErrorCode(err)}");
                        });
                      }
                    },
                    child: SizedBox(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.07,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.7,
                        child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            color: themeColor,
                            child: Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 10),
                              child: Center(
                                  child: isLoading
                                      ? CircularProgressIndicator(
                                    backgroundColor: remWhite,
                                  )
                                      : Text(
                                    AppLocalizations.of(context)
                                        .translate('login'),
                                    style: TextStyle(
                                        fontFamily: 'Tajawal-Regular',
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ))),
                  ),
                  GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 10),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          TextSpan(
                              text: AppLocalizations.of(context)
                                  .translate('Change_Password'),
                              style: TextStyle(
                                  fontFamily: 'Tajawal-Regular',
                                  decoration: TextDecoration.underline,
                                  color: Color(0xFF0F2E48),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                        ]),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_buildContext) => ResetPassScreen()));
                    },
                  ),
                  GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 10),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          TextSpan(
                              text: AppLocalizations.of(context)
                                  .translate('first_time') +
                                  ' \n',
                              style: TextStyle(
                                  fontFamily: 'Tajawal-Regular',
                                  color: Color(0xFF0F2E48),
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15)),
                          TextSpan(
                              text: AppLocalizations.of(context)
                                  .translate('sign_up'),
                              style: TextStyle(
                                  fontFamily: 'Tajawal-Regular',
                                  decoration: TextDecoration.underline,
                                  color: Color(0xFF0F2E48),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                        ]),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_buildContext) => SignUpScreen()));
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5, horizontal: 10),
                    child: Image.asset('assets/ic_splash.png',
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * .2,),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showToast(String message) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(message,
            style: TextStyle(
              fontSize: chat_text_font_size,
              fontWeight: FontWeight.normal,
            ))));
  }
}
