import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

flutterToast({required String msg, position = ToastGravity.BOTTOM}) {
  return Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: position,
    backgroundColor: Colors.black54,
  );
}
