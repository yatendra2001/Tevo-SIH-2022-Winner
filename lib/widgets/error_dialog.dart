import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:tevo/utils/theme_constants.dart';

class ErrorDialog extends StatefulWidget {
  final String title;
  final String content;

  const ErrorDialog({
    Key? key,
    this.title = 'Error',
    required this.content,
  }) : super(key: key);

  @override
  State<ErrorDialog> createState() => _ErrorDialogState();
}

class _ErrorDialogState extends State<ErrorDialog> {
  late bool isConnected;
  _initialiseConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {
      isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  @override
  void initState() {
    _initialiseConnection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? _showIOSDialog(context)
        : _showAndroidDialog(context);
  }

  CupertinoAlertDialog _showIOSDialog(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(widget.title),
      content: Text(widget.content),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Ok'),
        ),
      ],
    );
  }

  AlertDialog _showAndroidDialog(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        // side: BorderSide(color: kPrimaryBlackColor, width: 2.0),
      ),
      title: Center(
        child: Text(
          widget.title,
          style: TextStyle(
            fontFamily: kFontFamily,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: kPrimaryBlackColor,
          ),
        ),
      ),
      content: Text(
        isConnected
            ? widget.content
            : "The Internet connection appears to be offline",
        style: TextStyle(
          fontFamily: kFontFamily,
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          color: kPrimaryBlackColor,
        ),
      ),
      actions: [
        OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Okay",
              style: TextStyle(
                  fontFamily: kFontFamily,
                  color: kPrimaryBlackColor,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400),
            )),
      ],
    );
  }
}
