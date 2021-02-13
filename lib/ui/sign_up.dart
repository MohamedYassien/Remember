import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remember/ui/home_page.dart';
import '../AppLocalizations.dart';
import '../app_constants.dart';
import '../app_utils.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController firstNameInputController;
  TextEditingController lastNameInputController;
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  bool isNoVisiblePassword = true;
  bool isLoading = false;

  @override
  void initState() {
    firstNameInputController = new TextEditingController();
    lastNameInputController = new TextEditingController();
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: backgroundColor,
          centerTitle: true,
          elevation: 0,
          title: Text(
            AppLocalizations.of(context).translate('sign_up'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          )),
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              color: backgroundColor,
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 5, left: 20, right: 20, top: 20),
                    child: TextFormField(
                       controller: emailInputController,
                        validator:(value)=> emailValidator(value,context),
                        keyboardType: TextInputType.emailAddress,
                        style:
                            TextStyle(color: Color(0xFF0F2E48), fontSize: 14),
                        autofocus: false,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Color(0xFFAAB5C3))),
                          filled: true,
                          fillColor: Color(0xFFF3F3F5),
                          focusColor: Color(0xFFF3F3F5),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Color(0xFFAAB5C3))),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: backgroundColor)),
                          hintText:
                              AppLocalizations.of(context).translate('email'),
                        )),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: TextFormField(
                        controller: firstNameInputController,
                          validator: (value) {
                  if (value.length < 3) {
                  return AppLocalizations.of(context)
                      .translate('first_name_validate');
                  }else{
                    return null;
                  }
                  },
                        keyboardType: TextInputType.text,
                        style:
                            TextStyle(color: Color(0xFF0F2E48), fontSize: 14),
                        autofocus: false,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Color(0xFFAAB5C3))),
                          filled: true,
                          fillColor: Color(0xFFF3F3F5),
                          focusColor: Color(0xFFF3F3F5),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Color(0xFFAAB5C3))),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: backgroundColor)),
                          hintText: AppLocalizations.of(context)
                              .translate('first_name'),
                        )),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: TextFormField(

                        controller:lastNameInputController ,
                        validator: (value) {
                          if (value.length < 3) {
                            return AppLocalizations.of(context)
                                .translate('last_name_validate');
                          }else{
                            return null;
                          }
                        },
                        keyboardType: TextInputType.text,
                        style:
                            TextStyle(color: Color(0xFF0F2E48), fontSize: 14),
                        autofocus: false,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                    BorderSide(color: Color(0xFFAAB5C3))),
                            filled: true,
                            fillColor: Color(0xFFF3F3F5),
                            focusColor: Color(0xFFF3F3F5),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                    BorderSide(color: Color(0xFFAAB5C3))),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(color: backgroundColor)),
                            hintText: AppLocalizations.of(context)
                                .translate('last_name'))),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: TextFormField(
                        controller: pwdInputController,
                        validator:(value)=> pwdValidator(value,context),
                        obscureText: this.isNoVisiblePassword,
                        style:
                            TextStyle(color: Color(0xFF0F2E48), fontSize: 14),
                        decoration: InputDecoration(
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
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                    BorderSide(color: Color(0xFFAAB5C3))),
                            filled: true,
                            fillColor: Color(0xFFF3F3F5),
                            focusColor: Color(0xFFF3F3F5),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                    BorderSide(color: Color(0xFFAAB5C3))),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(color: backgroundColor)),
                            hintText: AppLocalizations.of(context)
                                .translate('password'))),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
    if (_registerFormKey.currentState.validate()) {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
    email: emailInputController.text,
    password: pwdInputController.text)
        .then((currentUser) => FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.user.uid)
        .set({
    "uid": currentUser.user.uid,
    "fname": firstNameInputController.text,
    "surname": lastNameInputController.text,
    "email": emailInputController.text,
    })
        .then((result) => {
    Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
    builder: (context) => HomePage(
//    title:
//    firstNameInputController
//        .text +
//    "'s Tasks",
//    uid: currentUser.uid,
    )),
    (_) => false),
    firstNameInputController.clear(),
    lastNameInputController.clear(),
    emailInputController.clear(),
    pwdInputController.clear(),
    })
        .catchError((err) => print(err)))
        .catchError((err) => print(err));
    }
    },
            child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 0.7,
                child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    color: backgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Center(
                          child: isLoading?CircularProgressIndicator():Text(
                        AppLocalizations.of(context).translate('sign_up'),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      )),
                    ))),
          ),
        ]);
  }
}
