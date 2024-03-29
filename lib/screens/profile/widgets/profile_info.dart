import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:tevo/utils/theme_constants.dart';

class ProfileInfo extends StatelessWidget {
  final String username;
  final String bio;
  final String displayName;

  const ProfileInfo({
    Key? key,
    required this.username,
    required this.bio,
    required this.displayName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          displayName.toUpperCase(),
          style: TextStyle(
              fontSize: 18.sp,
              fontFamily: kFontFamily,
              fontWeight: FontWeight.w500,
              letterSpacing: 2,
              wordSpacing: 2),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          "@" + username,
          style: TextStyle(
              fontSize: 8.5.sp,
              fontFamily: kFontFamily,
              fontWeight: FontWeight.w400,
              color: kPrimaryBlackColor.withOpacity(0.7)),
        ),
        if (bio.isNotEmpty) const SizedBox(height: 16.0),
        if (bio.isNotEmpty)
          Text(
            bio,
            textAlign: TextAlign.justify,
            style: TextStyle(
                fontSize: 9.5.sp,
                fontFamily: kFontFamily,
                color: kPrimaryBlackColor),
          ),
      ],
    );
  }
}
