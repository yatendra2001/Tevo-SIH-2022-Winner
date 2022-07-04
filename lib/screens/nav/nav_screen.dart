import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:sizer/sizer.dart';
import 'package:tevo/blocs/blocs.dart';
import 'package:tevo/cubits/cubits.dart';
import 'package:tevo/enums/enums.dart';
import 'package:tevo/repositories/repositories.dart';
import 'package:tevo/screens/create_post/create_post_screen.dart';
import 'package:tevo/screens/feed/feed_screen.dart';
import 'package:tevo/screens/nav/cubit/bottom_nav_bar_cubit.dart';
import 'package:tevo/screens/notifications/bloc/notifications_bloc.dart';
import 'package:tevo/screens/notifications/notifications_screen.dart';
import 'package:tevo/utils/theme_constants.dart';

import '../create_post/bloc/create_post_bloc.dart';
import '../feed/bloc/feed_bloc.dart';

class NavScreen extends StatelessWidget {
  static const String routeName = '/nav';

  NavScreen({Key? key}) : super(key: key);

  static Route route() {
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (_, __, ___) => BlocProvider<BottomNavBarCubit>(
        create: (_) => BottomNavBarCubit(),
        child: NavScreen(),
      ),
    );
  }

  final Map<BottomNavItem, dynamic> items = {
    BottomNavItem.feed: Container(
      height: 42,
      width: 42,
      decoration: BoxDecoration(
          border: Border.all(color: kPrimaryBlackColor),
          borderRadius: BorderRadius.circular(10)),
      child: const Icon(
        Icons.home_outlined,
        size: 23,
        color: kPrimaryBlackColor,
      ),
    ),
    BottomNavItem.create: Container(
      height: 42,
      width: 42,
      decoration: BoxDecoration(
          border: Border.all(color: kPrimaryBlackColor),
          borderRadius: BorderRadius.circular(10)),
      child: const Icon(
        Icons.add,
        color: kPrimaryBlackColor,
        size: 23,
      ),
    ),
    BottomNavItem.notifications: Container(
      height: 42,
      width: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          border: Border.all(color: kPrimaryBlackColor),
          borderRadius: BorderRadius.circular(10)),
      child: const Icon(
        Icons.notifications_none_outlined,
        size: 23,
        color: kPrimaryBlackColor,
      ),
    )
  };

  final Map<BottomNavItem, dynamic> screens = {
    BottomNavItem.feed: BlocProvider<FeedBloc>(
      create: (context) => FeedBloc(
        postRepository: context.read<PostRepository>(),
        authBloc: context.read<AuthBloc>(),
        likedPostsCubit: context.read<LikedPostsCubit>(),
        userRepository: context.read<UserRepository>(),
      )..add(FeedFetchPosts()),
      child: const FeedScreen(),
    ),
    BottomNavItem.create: BlocProvider<CreatePostBloc>(
      create: (context) => CreatePostBloc(
        userRepository: context.read<UserRepository>(),
        authBloc: context.read<AuthBloc>(),
        postRepository: context.read<PostRepository>(),
      )..add(const GetTaskEvent()),
      child: const CreatePostScreen(),
    ),
    BottomNavItem.notifications: BlocProvider<NotificationsBloc>(
      create: (context) => NotificationsBloc(
        notificationRepository: context.read<NotificationRepository>(),
        userRepository: context.read<UserRepository>(),
        authBloc: context.read<AuthBloc>(),
      ),
      child: const NotificationsScreen(),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xffE5E5E5),
            resizeToAvoidBottomInset: false,
            extendBody: true,
            body: screens[context.read<BottomNavBarCubit>().state.selectedItem],
            bottomNavigationBar: _customisedGoogleBottomNavBar(context, state),
          );
        },
      ),
    );
  }

  void _selectBottomNavItem(
    BuildContext context,
    BottomNavItem selectedItem,
  ) {
    context.read<BottomNavBarCubit>().updateSelectedItem(selectedItem);
  }

  _customisedGoogleBottomNavBar(context, state) {
    return Container(
      height: 9.4.h,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            spreadRadius: 0,
            blurRadius: 8,
          ),
        ],
        color: Color(0xffFFFFFF),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.zero,
          bottomRight: Radius.zero,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.3.w, vertical: 1.h),
        child: GNav(
          haptic: true, // haptic feedback
          tabBorderRadius: 10,
          tabActiveBorder: Border.all(
              color: kPrimaryBlackColor, width: 1), // tab button border
          tabBorder:
              Border.all(color: Colors.grey, width: 1), // tab button border
          curve: Curves.easeOutExpo, // tab animation curves
          duration: Duration(milliseconds: 300), // tab animation duration
          gap: 8, // the tab button gap between icon and text
          color: Colors.grey[800], // unselected icon color
          activeColor: kPrimaryWhiteColor, // selected icon and text color
          iconSize: 20.sp, // tab button icon size
          textSize: 30.sp,
          tabBackgroundColor:
              kPrimaryBlackColor, // selected tab background color
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          tabs: const [
            GButton(
              icon: Icons.home_outlined,
              text: 'Home',
            ),
            GButton(
              icon: Icons.add,
              text: 'Create',
            ),
            GButton(
              icon: Icons.notifications_none_outlined,
              text: 'Notification',
            ),
          ],
          onTabChange: (index) {
            if (index == 0) {
              BlocProvider.of<BottomNavBarCubit>(context)
                  .updateSelectedItem(BottomNavItem.feed);
            } else if (index == 1) {
              BlocProvider.of<BottomNavBarCubit>(context)
                  .updateSelectedItem(BottomNavItem.create);
            } else if (index == 2) {
              BlocProvider.of<BottomNavBarCubit>(context)
                  .updateSelectedItem(BottomNavItem.notifications);
            }
          },
        ),
      ),
    );
  }

  _customisedBottomNavBar(context, state) {
    return Container(
      height: 9.4.h,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            spreadRadius: 0,
            blurRadius: 8,
          ),
        ],
        color: Color(0xffFFFFFF),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.zero,
          bottomRight: Radius.zero,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: items
            .map((item, icon) => MapEntry(
                item,
                Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    highlightColor: kPrimaryBlackColor,
                    onTap: () {
                      _selectBottomNavItem(
                        context,
                        item,
                      );
                    },
                    child: icon,
                  ),
                )))
            .values
            .toList(),
      ),
    );
  }
}
