import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:remember/app_constants.dart';

import '../AppLocalizations.dart';
import '../app_utils.dart';

class ResetPassScreen extends StatefulWidget {
  @override
  _ResetPassScreenState createState() => _ResetPassScreenState();
}

class _ResetPassScreenState extends State<ResetPassScreen> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
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
            AppLocalizations.of(context).translate('reset_password'),
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
                  Container(
                    margin: EdgeInsets.only(top: 30.0),
                    child: GestureDetector(
                      onTap: () {
                        if (_loginFormKey.currentState.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          FocusScope.of(context).requestFocus(focus);
                          FirebaseAuth.instance
                              .sendPasswordResetEmail(
                                email: _textEditingControllerUser.text,
                              )
                              .then((currentUser) => {
                                    setState(() {
                                      isLoading = false;
                                    }),
                                    _showToast(
                                        'تم ارسال لينك تغيير كلمة المرور على الميل الخاص بك'),
                                    _textEditingControllerUser.clear(),
                                  })
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
                          height: MediaQuery.of(context).size.height * 0.07,
                          width: MediaQuery.of(context).size.width * 0.7,
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
                                                .translate('reset'),
                                            style: TextStyle(
                                                fontFamily: 'Tajawal-Regular',
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          )),
                              ))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
                    child: Image.asset(
                      'assets/ic_splash.png',
                      height: MediaQuery.of(context).size.height * .2,
                    ),
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
