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
        padding: EdgeInsets.symmetric(vertical: 1.2.h, horizontal: 4.w),
        child: Text(
          labelText,
          style: TextStyle(fontSize: 9.5.sp, color: Colors.white),
        ),
      ),
    );
  }
}
