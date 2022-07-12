import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:tevo/utils/theme_constants.dart';

class StandardElevatedButton extends StatelessWidget {
  const StandardElevatedButton({
    Key? key,
    required this.labelText,
    required this.onTap,
    this.isButtonNull = false,
  }) : super(key: key);

  final String labelText;
  final VoidCallback onTap;
  final bool isButtonNull;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        primary: kPrimaryBlackColor,
      ),
      onPressed: isButtonNull ? null : onTap,
      child: Padding(
        padding:
            EdgeInsets.only(left: 2.w, right: 1.5.w, top: 1.h, bottom: 1.4.h),
        child: Text(
          labelText,

          style: TextStyle(fontSize: 12.sp, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
