import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:tevo/screens/profile/followers_screen.dart';
import 'package:tevo/screens/profile/following_screen.dart';
import 'package:tevo/screens/profile/widgets/widgets.dart';
import 'package:tevo/utils/theme_constants.dart';

class ProfileStats extends StatelessWidget {
  final bool isCurrentUser;
  final bool isFollowing;
  final bool isRequesting;
  final int posts;
  final int followers;
  final int following;
  final String userId;

  const ProfileStats({
    Key? key,
    required this.isCurrentUser,
    required this.isFollowing,
    required this.isRequesting,
    required this.posts,
    required this.followers,
    required this.following,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _Stats(count: posts, label: 'Streak'),
            InkWell(
              child: _Stats(count: followers, label: 'Followers'),
              onTap: () {
                Navigator.of(context).pushNamed(FollowerScreen.routeName,
                    arguments: FollowerScreenArgs(userId: userId));
              },
            ),
            InkWell(
              child: _Stats(count: following, label: 'Following'),
              onTap: () {
                Navigator.of(context).pushNamed(FollowingScreen.routeName,
                    arguments: FollowerScreenArgs(userId: userId));
              },
            ),
            _Stats(count: posts, label: 'Completion Rate'),
          ],
        ),
        const SizedBox(height: 16.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ProfileButton(
            isRequesting: isRequesting,
            isCurrentUser: isCurrentUser,
            isFollowing: isFollowing,
          ),
        ),
      ],
    );
  }
}

class _Stats extends StatelessWidget {
  final int count;
  final String label;

  const _Stats({
    Key? key,
    required this.count,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: kPrimaryBlackColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              count.toString(),
              style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: kPrimaryBlackColor),
            ),
            SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400,
                  color: kPrimaryBlackColor),
            ),
          ],
        ),
      ),
    );
  }
}
