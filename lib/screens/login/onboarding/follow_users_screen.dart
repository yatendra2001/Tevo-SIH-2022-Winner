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
  const FollowUsersScreen({Key? key}) : super(key: key);
  static const String routeName = '/follow-users-screen';
  static Route route() {
    return PageTransition(
        settings: const RouteSettings(name: routeName),
        type: PageTransitionType.rightToLeft,
        child: const FollowUsersScreen());
  }

  @override
  State<FollowUsersScreen> createState() => _FollowUsersScreenState();
}

class _FollowUsersScreenState extends State<FollowUsersScreen> {
  List<User> topFollowingUsersList = [];
  List<bool> isFollowingList = [];

  _getTopFollowingUser() async {
    return await UserRepository().getUsersByFollowers().then((value) {
      topFollowingUsersList = value;
      for (var i = 0; i < topFollowingUsersList.length; i++) {
        isFollowingList.add(false);
      }
    });
  }

  @override
  void initState() {
    _getTopFollowingUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _getTopFollowingUser();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 7.h,
                right: 4.w,
                left: 4.w,
                child: Text(
                  "Follow new friends to inspire from their daily progress",
                  style:
                      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
              ListView(
                padding: EdgeInsets.fromLTRB(4.w, 15.h, 4.w, 5.h),
                children: [
                  ListView.builder(
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: ClipRRect(
                          child: UserProfileImage(
                            profileImageUrl:
                                topFollowingUsersList[index].profileImageUrl,
                            radius: 18.sp,
                          ),
                        ),
                        title: Text(
                          topFollowingUsersList[index].username,
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
                                ? const Icon(Icons.check,
                                    color: kPrimaryTealColor)
                                : const Icon(Icons.add,
                                    color: kPrimaryBlackColor)),
                      ),
                    ),
                  ),
                  // ...topFollowingUsersList.map(
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
                ],
              ),
              Positioned(
                left: 0.0,
                right: 0.0,
                bottom: 0.0,
                child: Container(
                  height: 7.h,
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
                bottom: 6.h,
                child: StandardElevatedButton(
                  labelText: "Follow →",
                  onTap: () {
                    for (int i = 0; i < isFollowingList.length; i++) {
                      UserRepository().requestUser(
                          userId: SessionHelper.uid!,
                          followUserId: topFollowingUsersList[i].id);
                    }
                    Navigator.of(context).pushNamed(NavScreen.routeName);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
