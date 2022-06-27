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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          displayName.toUpperCase(),
          style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
              letterSpacing: 2,
              wordSpacing: 4),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          "@" + username,
          style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
              color: kPrimaryBlackColor.withOpacity(0.7)),
        ),
        const SizedBox(height: 8.0),
        Text(
          bio,
          textAlign: TextAlign.justify,
          style: const TextStyle(fontSize: 18.0, color: kPrimaryBlackColor),
        ),
      ],
    );
  }
}
