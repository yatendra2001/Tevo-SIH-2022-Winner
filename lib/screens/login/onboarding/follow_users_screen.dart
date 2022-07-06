import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

import 'package:tevo/models/user_model.dart';
import 'package:tevo/repositories/user/user_repository.dart';
import 'package:tevo/screens/login/login_cubit/login_cubit.dart';
import 'package:tevo/screens/login/onboarding/dob_screen.dart';
import 'package:tevo/screens/login/widgets/standard_elevated_button.dart';
import 'package:tevo/screens/screens.dart';
import 'package:tevo/utils/session_helper.dart';
import 'package:tevo/utils/theme_constants.dart';
import 'package:tevo/widgets/user_profile_image.dart';

class FollowUsersScreen extends StatefulWidget {
  final PageController? pageController;

  const FollowUsersScreen({
    Key? key,
    this.pageController,
  }) : super(key: key);
  @override
  State<FollowUsersScreen> createState() => _FollowUsersScreenState();
}

class _FollowUsersScreenState extends State<FollowUsersScreen> {
  List<bool> isFollowingList = [];
  @override
  void initState() {
    BlocProvider.of<LoginCubit>(context).fetchTopFollowers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        int len = BlocProvider.of<LoginCubit>(context)
            .state
            .topFollowersAccount
            .length;
        for (int i = 0; i < len; i++) {
          isFollowingList.add(false);
        }
        log(BlocProvider.of<LoginCubit>(context)
            .state
            .topFollowersAccount
            .toString());
        log(isFollowingList.toString());
        if (state.topFollowersStatus == TopFollowersStatus.loading) {
          return Platform.isIOS
              ? const Center(child: CupertinoActivityIndicator())
              : const Center(child: CircularProgressIndicator());
        }
        return Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 7.h,
              right: 4.w,
              left: 4.w,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "Follow new friends to inspire from their daily progress",
                  style:
                      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            ListView.builder(
              itemCount: state.topFollowersAccount.length,
              padding: EdgeInsets.fromLTRB(4.w, 15.h, 4.w, 5.h),
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: ClipRRect(
                    child: UserProfileImage(
                      profileImageUrl:
                          state.topFollowersAccount[index].profileImageUrl,
                      radius: 18.sp,
                    ),
                  ),
                  title: Text(
                    state.topFollowersAccount[index].username,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: kPrimaryBlackColor,
                    ),
                  ),
                  trailing: GestureDetector(
                      onTap: () {
                        setState(() {
                          isFollowingList[index] =
                              isFollowingList[index] ? false : true;
                        });
                      },
                      child: isFollowingList[index]
                          ? const Icon(Icons.check, color: kPrimaryTealColor)
                          : const Icon(Icons.add, color: kPrimaryBlackColor)),
                ),
              ),
            ),
            // ...state.topFollowersAccount.map(
            //   (e) => Padding(
            //     padding: const EdgeInsets.symmetric(vertical: 8.0),
            //     child: ListTile(
            //       leading: ClipRRect(
            //         child: UserProfileImage(
            //           profileImageUrl: e.profileImageUrl,
            //           radius: 18.sp,
            //         ),
            //       ),
            //       title: Text(
            //         e.username,
            //         style: TextStyle(
            //           fontSize: 10.sp,
            //           fontWeight: FontWeight.w500,
            //           color: kPrimaryBlackColor,
            //         ),
            //       ),
            //       trailing: GestureDetector(
            //           onTap: () {
            //             setState(() {
            //               isFollowing = isFollowing ? false : true;
            //             });
            //           },
            //           child: isFollowing
            //               ? const Icon(Icons.check,
            //                   color: kPrimaryTealColor)
            //               : const Icon(Icons.add,
            //                   color: kPrimaryBlackColor)),
            //     ),
            //   ),
            // ),

            Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: Container(
                height: 12.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.1),
                        Theme.of(context).scaffoldBackgroundColor,
                      ]),
                ),
              ),
            ),
            Positioned(
              bottom: 5.h,
              child: StandardElevatedButton(
                labelText: "Follow →",
                onTap: () {
                  for (int i = 0; i < state.topFollowersAccount.length; i++) {
                    if (isFollowingList[i]) {
                      log("yeh kitni baar chlrha hai");
                      UserRepository().followUser(
                          userId: SessionHelper.uid!,
                          followUserId: state.topFollowersAccount[i].id,
                          requestId: null);
                    }
                  }
                  Navigator.of(context).pushNamed(NavScreen.routeName);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
