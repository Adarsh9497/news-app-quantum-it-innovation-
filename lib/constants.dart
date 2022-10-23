import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

var kBackgroundColor = Colors.white;

void gotoScreen(BuildContext context, dynamic route) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => route));
}

void clearAndGoto(BuildContext context, dynamic route) {
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => route),
      (Route<dynamic> route) => false);
}

void showToast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey.shade700,
      textColor: Colors.white,
      fontSize: 15.0);
}
