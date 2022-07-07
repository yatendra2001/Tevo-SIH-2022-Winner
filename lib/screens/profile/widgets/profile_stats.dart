import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:tevo/repositories/post/post_repository.dart';
import 'package:tevo/screens/profile/bloc/profile_bloc.dart';

import 'package:tevo/screens/profile/followers_screen.dart';
import 'package:tevo/screens/profile/following_screen.dart';
import 'package:tevo/screens/profile/widgets/widgets.dart';
import 'package:tevo/utils/theme_constants.dart';

class ProfileStats extends StatefulWidget {
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
  State<ProfileStats> createState() => _ProfileStatsState();
}

class _ProfileStatsState extends State<ProfileStats> {
  double? completionRate;

  _getCompletionRate() {
    PostRepository()
        .getCompletionRate(userId: context.read<ProfileBloc>().state.user.id)
        .then((value) {
      setState(() {
        completionRate = value;
      });
      log("Total Completed Tasks" + completionRate.toString());
    });
  }

  @override
  void initState() {
    _getCompletionRate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _Stats(count: widget.posts, label: 'Posts'),
            InkWell(
              child: _Stats(count: widget.followers, label: 'Followers'),
              onTap: () {
                Navigator.of(context).pushNamed(FollowerScreen.routeName,
                    arguments: FollowerScreenArgs(userId: widget.userId));
              },
            ),
            InkWell(
              child: _Stats(count: widget.following, label: 'Following'),
              onTap: () {
                Navigator.of(context).pushNamed(FollowingScreen.routeName,
                    arguments: FollowingScreenArgs(userId: widget.userId));
              },
            ),
            _Stats(
                count: completionRate?.toInt() ?? 0, label: 'Completion Rate'),
          ],
        ),
        const SizedBox(height: 16.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ProfileButton(
            isRequesting: widget.isRequesting,
            isCurrentUser: widget.isCurrentUser,
            isFollowing: widget.isFollowing,
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
              style: TextStyle(
                  fontSize: 8.5.sp,
                  fontWeight: FontWeight.w400,
                  color: kPrimaryBlackColor),
            ),
          ],
        ),
      ),
    );
  }
}
