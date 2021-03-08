import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:remember/AppLocalizations.dart';

String emailValidator(String value, BuildContext context) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return AppLocalizations.of(context).translate('email_validate');
  } else {
    return null;
  }
}

String pwdValidator(String value, BuildContext context) {
  if (value.length < 8) {
    return AppLocalizations.of(context).translate('pass_validate');
  } else {
    return null;
  }
}

String getMessageFromErrorCode(FirebaseAuthException err) {
  switch (err.code) {
    case "ERROR_EMAIL_ALREADY_IN_USE":
    case "account-exists-with-different-credential":
    case "email-already-in-use":
      return "Email already used. Go to login page.";
      break;
    case "ERROR_WRONG_PASSWORD":
    case "wrong-password":
      return "Wrong email/password combination.";
      break;
    case "ERROR_USER_NOT_FOUND":
    case "user-not-found":
      return "No user found with this email.";
      break;
    case "ERROR_USER_DISABLED":
    case "user-disabled":
      return "User disabled.";
      break;
    case "ERROR_TOO_MANY_REQUESTS":
    case "operation-not-allowed":
      return "Too many requests to log into this account.";
      break;
    case "ERROR_OPERATION_NOT_ALLOWED":
    case "operation-not-allowed":
      return "Server error, please try again later.";
      break;
    case "ERROR_INVALID_EMAIL":
    case "invalid-email":
      return "Email address is invalid.";
      break;
    default:
      return "Login failed. Please try again.";
      break;
  }
}

void saveUid(String uid, String username) async {
  final storage = FlutterSecureStorage();
  await storage.write(key: 'uid', value: uid);
  await storage.write(key: 'user', value: username);
}

Future<String> getUserName() async {
  final storage = FlutterSecureStorage();
  if (storage != null && storage.read(key: 'user') != null) {
    String headerToken = await storage.read(key: "user");
    return headerToken;
  } else {
    return "";
  }
}

Widget customCard(var obj, BuildContext context, {onTapYes}) {
  return GestureDetector(
    onTap: () => onTapYes,
    child: Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0.5,
            blurRadius: 9,
            offset: Offset(0, 3), // changes position of shadow
          )
        ],
      ),
      child: ClipPath(
        clipper: ShapeBorderClipper(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(obj.action,
                    style: TextStyle(color: Colors.black, fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget customCardQuestion(var obj, BuildContext context, {onTapYes}) {
  return GestureDetector(
    onTap: () => onTapYes,
    child: Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0.5,
            blurRadius: 9,
            offset: Offset(0, 3), // changes position of shadow
          )
        ],
      ),
      child: ClipPath(
        clipper: ShapeBorderClipper(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(obj.question,
                    style: TextStyle(color: Colors.black, fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget customCardSuggestion(var obj, BuildContext context, {onTapYes}) {
  return GestureDetector(
    onTap: () => onTapYes,
    child: Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0.5,
            blurRadius: 9,
            offset: Offset(0, 3), // changes position of shadow
          )
        ],
      ),
      child: ClipPath(
        clipper: ShapeBorderClipper(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${AppLocalizations.of(context).translate(
                    'username')} :${obj.username}',
                    style: TextStyle(color: Colors.black, fontSize: 16)),
                Text('${AppLocalizations.of(context).translate('sugg')} :${obj
                    .answer}',
                    style: TextStyle(color: Colors.black, fontSize: 16)),
                Text('${AppLocalizations.of(context).translate('date')} :${obj
                    .date}',
                    style: TextStyle(color: Colors.black, fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget customCardSumResult(var obj, BuildContext context, {onTapYes}) {
  return GestureDetector(
    onTap: () => onTapYes,
    child: Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0.5,
            blurRadius: 9,
            offset: Offset(0, 3), // changes position of shadow
          )
        ],
      ),
      child: ClipPath(
        clipper: ShapeBorderClipper(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    '${AppLocalizations.of(context).translate('result_sum')}'
                        '$obj',
                    style: TextStyle(color: Colors.black, fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget customCardPoint(var obj, BuildContext context, {onTapYes}) {
  return GestureDetector(
    onTap: () => onTapYes,
    child: Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0.5,
            blurRadius: 9,
            offset: Offset(0, 3), // changes position of shadow
          )
        ],
      ),
      child: ClipPath(
        clipper: ShapeBorderClipper(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    '${AppLocalizations.of(context).translate(
                        'username')} :${obj.username}',
                    style: TextStyle(color: Colors.black, fontSize: 16)),
                Text(
                    '${AppLocalizations.of(context).translate(
                        'competiation')} :${obj.competiation}',
                    style: TextStyle(color: Colors.black, fontSize: 16)),
                Text(
                    '${AppLocalizations.of(context).translate('date')} :${obj
                        .date}',
                    style: TextStyle(color: Colors.black, fontSize: 16)),
                Text(
                    '${AppLocalizations.of(context).translate('result')} :${obj
                        .sum}',
                    style: TextStyle(color: Colors.black, fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget customCardMyResult(var obj, BuildContext context, {onTapYes}) {
  return GestureDetector(
    onTap: () => onTapYes,
    child: Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0.5,
            blurRadius: 9,
            offset: Offset(0, 3), // changes position of shadow
          )
        ],
      ),
      child: ClipPath(
        clipper: ShapeBorderClipper(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                Text(obj, style: TextStyle(color: Colors.black, fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
