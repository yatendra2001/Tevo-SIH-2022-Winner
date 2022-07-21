import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:tevo/repositories/user/user_repository.dart';
import 'package:tevo/screens/login/login_cubit/login_cubit.dart';
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
        pageBuilder: (context, _, __) => const FollowUsersScreen());
  }

  const FollowUsersScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<FollowUsersScreen> createState() => _FollowUsersScreenState();
}

class _FollowUsersScreenState extends State<FollowUsersScreen> {
  List<bool> isFollowingList = [];
  bool loading = false;

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
          body: loading
              ? _builLoadScreen()
              : state.topFollowersStatus == TopFollowersStatus.loading
                  ? Platform.isIOS
                      ? const Center(
                          child: CupertinoActivityIndicator(
                              color: kPrimaryBlackColor))
                      : const Center(
                          child: CircularProgressIndicator(
                              color: kPrimaryBlackColor))
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 52, bottom: 16, right: 16, left: 16),
                            child: Text(
                              "Follow new friends to inspire from their daily progress",
                              style: TextStyle(
                                  fontFamily: kFontFamily,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.topFollowersAccount.length,
                            padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 5.h),
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: ListTile(
                                onTap: () {
                                  setState(() {
                                    isFollowingList[index] =
                                        isFollowingList[index] ? false : true;
                                  });
                                },
                                selectedTileColor: null,
                                leading: UserProfileImage(
                                  iconRadius: 48,
                                  profileImageUrl: state
                                      .topFollowersAccount[index]
                                      .profileImageUrl,
                                  radius: 15,
                                ),
                                minLeadingWidth: 4,
                                title: Text(
                                  state.topFollowersAccount[index].displayName,
                                  style: TextStyle(
                                    fontFamily: kFontFamily,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w500,
                                    color: kPrimaryBlackColor,
                                  ),
                                ),
                                subtitle: state.topFollowersAccount[index].bio
                                        .isNotEmpty
                                    ? Text(
                                        state.topFollowersAccount[index].bio,
                                        style: TextStyle(
                                          fontFamily: kFontFamily,
                                          fontSize: 7.sp,
                                          fontWeight: FontWeight.w400,
                                          color: kPrimaryBlackColor
                                              .withOpacity(0.7),
                                        ),
                                      )
                                    : null,
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
          floatingActionButton:
              state.topFollowersStatus == TopFollowersStatus.loading
                  ? const SizedBox()
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
                          if (loading == false) {
                            followUser(state);
                          }
                        },
                        child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: loading ? Colors.black38 : Colors.black,
                            ),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 140, vertical: 35),
                            child: Text(
                              "Follow →",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontFamily: kFontFamily,
                              ),
                            )),
                      ),
                    ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }

  void followUser(LoginState state) async {
    setState(() {
      loading = true;
    });
    for (int i = 0; i < state.topFollowersAccount.length; i++) {
      if (isFollowingList[i]) {
        await UserRepository().followUser(
            userId: SessionHelper.uid!,
            followUserId: state.topFollowersAccount[i].id,
            requestId: null);
      }
    }
    setState(() {
      loading = false;
    });
    Navigator.of(context).pushReplacementNamed(NavScreen.routeName);
  }

  _builLoadScreen() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          const LinearProgressIndicator(color: kPrimaryBlackColor),
          const SizedBox(
            height: 16,
          ),
          Text(
            'Please wait while we are setting up your profile',
            style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500),
          ),
          const Spacer()
        ],
      ),
    );
  }
}
