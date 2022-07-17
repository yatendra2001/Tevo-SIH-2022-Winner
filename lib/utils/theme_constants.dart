import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';

const kPrimaryTealColor = Color(0xff009688);
const kPrimaryWhiteColor = Color.fromARGB(255, 255, 255, 255);
const kPrimaryRedColor = Color.fromARGB(255, 219, 19, 19);
const kPrimaryBlackColor = Color(0xff0c0c0d);
const kPrimaryBlackFadedColor = Color(0xff3e3e42);
const kSecondaryBlueColor = Color(0xffCAE9FF);
const kSecondaryYellowColor = Color.fromARGB(255, 236, 186, 34);

class Palette {
  static const Color lightBlue = kPrimaryTealColor;
  static const Color orange = kSecondaryYellowColor;
  static const Color darkBlue = kPrimaryBlackColor;
  static const Color darkOrange = kPrimaryTealColor;
}

String kFontFamily = GoogleFonts.openSans().fontFamily!;
