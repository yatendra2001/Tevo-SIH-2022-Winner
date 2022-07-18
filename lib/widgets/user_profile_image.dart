import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tevo/utils/theme_constants.dart';

class UserProfileImage extends StatelessWidget {
  final double radius;
  final String profileImageUrl;
  final File? profileImage;
  final double iconRadius;

  const UserProfileImage({
    Key? key,
    required this.radius,
    required this.profileImageUrl,
    this.profileImage,
    required this.iconRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (profileImage == null && profileImageUrl.isEmpty)
        ? _noProfileIcon()
        : fn();
  }

  fn() {
    return Container(
      width: radius * 3,
      height: radius * 3,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        shape: BoxShape.circle,
        image: DecorationImage(
            image: profileImage != null
                ? FileImage(profileImage!)
                : profileImageUrl.isNotEmpty
                    ? CachedNetworkImageProvider(profileImageUrl)
                    : null as ImageProvider,
            fit: BoxFit.contain),
      ),
    );
  }

  Icon? _noProfileIcon() {
    if (profileImage == null && profileImageUrl.isEmpty) {
      return Icon(
        Icons.account_circle,
        color: Colors.black54,
        size: iconRadius,
      );
    }
    return null;
  }
}
