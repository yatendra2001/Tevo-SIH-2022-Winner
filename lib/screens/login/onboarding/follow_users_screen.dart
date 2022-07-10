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
  static const routeName = "followUsersScreen";

  static Route route() {
    return PageRouteBuilder(
        settings: const RouteSettings(name: routeName),
        transitionDuration: const Duration(seconds: 0),
        pageBuilder: (context, _, __) => FollowUsersScreen());
  }

  const FollowUsersScreen({
    Key? key,
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

        return Scaffold(
          body: state.topFollowersStatus == TopFollowersStatus.loading
              ? Platform.isIOS
                  ? const Center(child: CupertinoActivityIndicator())
                  : const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 52, bottom: 16, right: 16, left: 16),
                        child: Text(
                          "Follow new friends to inspire from their daily progress",
                          style: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: state.topFollowersAccount.length,
                        padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 5.h),
                        itemBuilder: (context, index) => Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 8.0,
                          ),
                          child: ListTile(
                            leading: UserProfileImage(
                              iconRadius: 48,
                              profileImageUrl: state
                                  .topFollowersAccount[index].profileImageUrl,
                              radius: 15,
                            ),
                            minLeadingWidth: 4,
                            title: Text(
                              state.topFollowersAccount[index].displayName,
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                                color: kPrimaryBlackColor,
                              ),
                            ),
                            subtitle: Text(
                              "@" + state.topFollowersAccount[index].username,
                              style: TextStyle(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w400,
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
                                  ? const Icon(Icons.check,
                                      color: kPrimaryTealColor)
                                  : const Icon(Icons.add,
                                      color: kPrimaryBlackColor),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          floatingActionButton: state.topFollowersStatus ==
                  TopFollowersStatus.loading
              ? SizedBox()
              : Container(
                  height: 13.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.2),
                        Theme.of(context).scaffoldBackgroundColor,
                      ],
                    ),
                  ),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      for (int i = 0;
                          i < state.topFollowersAccount.length;
                          i++) {
                        if (isFollowingList[i]) {
                          UserRepository().followUser(
                              userId: SessionHelper.uid!,
                              followUserId: state.topFollowersAccount[i].id,
                              requestId: null);
                        }
                      }
                      Navigator.of(context).pushNamed(NavScreen.routeName);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.black,
                      ),
                      margin:
                          EdgeInsets.symmetric(horizontal: 140, vertical: 35),
                      child: Text(
                        "Follow ->",
                        style: TextStyle(color: Colors.white, fontSize: 12.sp),
                      ),
                    ),
                  ),
                ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }
}
