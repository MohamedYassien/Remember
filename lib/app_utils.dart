import 'package:flutter/cupertino.dart';
import 'package:remember/AppLocalizations.dart';

String emailValidator(String value,BuildContext context) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return AppLocalizations.of(context)
        .translate('email_validate');
  } else {
    return null;
  }
}

String pwdValidator(String value,BuildContext context) {
  if (value.length < 8) {
    return AppLocalizations.of(context)
        .translate('pass_validate');
  } else {
    return null;
  }
}