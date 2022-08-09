import 'package:flutter/material.dart';
import 'package:fluttericon/linearicons_free_icons.dart';
import 'package:sizer/sizer.dart';
import 'package:tevo/utils/theme_constants.dart';

class StandardElevatedButton extends StatelessWidget {
  const StandardElevatedButton({
    Key? key,
    required this.labelText,
    required this.onTap,
    this.isButtonNull = false,
    this.isArrowButton = false,
  }) : super(key: key);

  final String labelText;
  final VoidCallback onTap;
  final bool isButtonNull;
  final bool isArrowButton;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          primary: kPrimaryBlackColor,
        ),
        onPressed: isButtonNull ? null : onTap,
        child: Padding(
          padding: EdgeInsets.only(
              left: 2.w, right: 1.5.w, top: 1.4.h, bottom: 1.4.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                labelText,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white,
                  fontFamily: kFontFamily,
                ),
                textAlign: TextAlign.center,
              ),
              if (isArrowButton) const SizedBox(width: 5),
              if (isArrowButton)
                Icon(
                  LineariconsFree.arrow_right,
                  color: kPrimaryWhiteColor,
                  size: 14.sp,
                )
            ],
          ),
        ),
      ),
    );
  }
}
