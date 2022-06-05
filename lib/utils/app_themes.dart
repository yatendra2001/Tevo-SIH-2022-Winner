import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tevo/utils/font_family.dart';
import 'theme_constants.dart';

class AppThemes {
  AppThemes._();
  static final ThemeData lightTheme = ThemeData(
    fontFamily: FontFamily.workSans,
    brightness: Brightness.light,
  ).copyWith(
    primaryColor: kPrimaryTealColor,
    scaffoldBackgroundColor: Colors.grey[50],
    textTheme: TextTheme(
      displayLarge: ThemeData.light()
          .textTheme
          .displayLarge!
          .copyWith(fontSize: 32, fontWeight: FontWeight.bold),
      titleMedium: ThemeData.light().textTheme.titleLarge!.copyWith(
          fontSize: 16, color: Colors.black, fontWeight: FontWeight.w700),
      bodyMedium: ThemeData.light()
          .textTheme
          .bodyLarge!
          .copyWith(fontSize: 12, color: Colors.black),
    ).apply(
      //default  text color
      bodyColor: Colors.black,
      displayColor: Colors.black,
    ),
    appBarTheme: AppBarTheme(
      color: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      toolbarTextStyle: const TextTheme(
        headline6: TextStyle(
          fontSize: 26.0,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ).bodyText2,
      titleTextStyle: const TextTheme(
        headline6: TextStyle(
          fontSize: 26.0,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ).headline6,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
