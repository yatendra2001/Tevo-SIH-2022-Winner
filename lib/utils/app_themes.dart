import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:tevo/utils/font_family.dart';
import 'theme_constants.dart';

class AppThemes {
  AppThemes._();
  static final ThemeData lightTheme = ThemeData(
    fontFamily: GoogleFonts.roboto().fontFamily,
    brightness: Brightness.light,
  ).copyWith(
    primaryColor: kPrimaryBlackColor,
    scaffoldBackgroundColor: Colors.grey[50],
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: kPrimaryBlackColor,
      selectionColor: kPrimaryBlackColor,
      selectionHandleColor: kPrimaryBlackColor,
    ),
    textTheme: TextTheme(
      displayLarge: ThemeData.light()
          .textTheme
          .displayLarge!
          .copyWith(fontSize: 20.sp, fontWeight: FontWeight.bold),
      titleMedium: ThemeData.light().textTheme.titleLarge!.copyWith(
          fontSize: 11.5.sp,
          color: kPrimaryBlackColor,
          fontWeight: FontWeight.w700),
      bodyMedium: ThemeData.light()
          .textTheme
          .bodyLarge!
          .copyWith(fontSize: 8.5.sp, color: kPrimaryBlackColor),
    ).apply(
      //default  text color
      bodyColor: kPrimaryBlackColor,
      displayColor: kPrimaryBlackColor,
    ),
    appBarTheme: AppBarTheme(
      color: Colors.white,
      iconTheme: const IconThemeData(color: kPrimaryBlackColor),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      toolbarTextStyle: const TextTheme(
        headline6: TextStyle(
          fontSize: 26.0,
          color: kPrimaryBlackColor,
          fontWeight: FontWeight.w600,
        ),
      ).bodyText2,
      titleTextStyle: const TextTheme(
        headline6: TextStyle(
          fontSize: 26.0,
          color: kPrimaryBlackColor,
          fontWeight: FontWeight.w600,
        ),
      ).headline6,
    ),
    accentColor: Colors.black,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
