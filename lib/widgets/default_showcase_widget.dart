import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sizer/sizer.dart';
import 'package:tevo/utils/theme_constants.dart';

class DefaultShowcase extends StatelessWidget {
  final GlobalKey myKey;
  final String description;
  final String title;
  final Widget child;
  final VoidCallback? onTap;
  final bool? disposeOnTap;
  const DefaultShowcase(
      {required this.myKey,
      required this.description,
      required this.title,
      required this.child,
      this.onTap,
      this.disposeOnTap});

  @override
  Widget build(BuildContext context) {
    return Showcase(
      onTargetClick: onTap,
      disposeOnTap: disposeOnTap,
      key: myKey,
      child: child,
      description: description,
      title: title,
      titleTextStyle: TextStyle(
          color: kPrimaryBlackColor,
          fontFamily: kFontFamily,
          fontWeight: FontWeight.w600,
          fontSize: 11.sp),
      descTextStyle: TextStyle(
          color: kPrimaryBlackColor.withOpacity(0.8),
          fontFamily: kFontFamily,
          fontWeight: FontWeight.w400,
          fontSize: 8.sp),
    );
  }
}
