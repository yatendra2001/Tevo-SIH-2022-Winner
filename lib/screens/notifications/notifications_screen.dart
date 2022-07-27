import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:tevo/screens/login/onboarding/follow_users_screen.dart';
import 'package:tevo/screens/notifications/bloc/notifications_bloc.dart';
import 'package:tevo/screens/notifications/widgets/widgets.dart';
import 'package:tevo/utils/theme_constants.dart';
import 'package:tevo/widgets/widgets.dart';

import '../../models/models.dart';
import '../screens.dart';

class NotificationsScreen extends StatefulWidget {
  static const String routeName = '/notifications';

  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Notif?> requestlist = [];
  List<Notif?> notificationList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 9.h,
        leading: SizedBox.shrink(),
        leadingWidth: 0,
        title: Text(
          "Notifications",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            fontFamily: kFontFamily,
          ),
        ),
      ),
      body: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) {
          requestlist = state.requests;
          notificationList = state.notifications;
          switch (state.status) {
            case NotificationsStatus.error:
              return CenteredText(text: state.failure.message);
            case NotificationsStatus.loading:
              return const Center(
                  child: CircularProgressIndicator(color: kPrimaryBlackColor));
            case NotificationsStatus.loaded:
              return requestlist.isEmpty && notificationList.isEmpty
                  ? Center(
                      child: Column(
                        children: [
                          Spacer(
                            flex: 3,
                          ),
                          Text(
                            "No new notifications\nTap To Follow",
                            style: TextStyle(
                                color: kPrimaryBlackColor.withOpacity(0.7),
                                fontWeight: FontWeight.w500,
                                fontFamily: kFontFamily,
                                height: 1.5,
                                fontSize: 15.sp),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: kPrimaryWhiteColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        color: kPrimaryBlackColor),
                                    borderRadius: BorderRadius.circular(5))),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const FollowUsersScreen()),
                              );
                            },
                            child: Text(
                              'Follow users',
                              style: TextStyle(
                                color: kPrimaryBlackColor,
                                fontSize: 12.sp,
                                fontFamily: kFontFamily,
                              ),
                            ),
                          ),
                          Spacer(
                            flex: 4,
                          )
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: (requestlist.length + notificationList.length),
                      itemBuilder: (BuildContext context, int index) {
                        if (index < requestlist.length) {
                          final request = requestlist[index];
                          if (request != null) {
                            return _buildRequestTile(context, state, request);
                          } else {
                            return SizedBox.shrink();
                          }
                        } else if (index >= requestlist.length &&
                            index < notificationList.length) {
                          final notification = notificationList[index];
                          if (notification != null) {
                            return NotificationTile(
                              notification: notification,
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        }
                        return SizedBox.shrink();
                      },
                    );
            default:
              return const Center(
                  child: CircularProgressIndicator(color: kPrimaryBlackColor));
          }
        },
      ),
    );
  }
}

_buildRequestTile(
    BuildContext context, NotificationsState state, Notif request) {
  return ListTile(
    leading: UserProfileImage(
      radius: 18.0,
      iconRadius: 24.sp,
      profileImageUrl: request.fromUser.profileImageUrl,
    ),
    title: Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: request.fromUser.username,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: kFontFamily,
                color: kPrimaryBlackColor,
                fontSize: 11.5.sp),
          ),
          const TextSpan(text: '  '),
          TextSpan(
            text: "requested to follow you",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontFamily: kFontFamily,
                color: kPrimaryBlackColor,
                fontSize: 11.5.sp),
          ),
        ],
      ),
    ),
    trailing: Wrap(
      children: [
        OutlinedButton(
          onPressed: () {
            context
                .read<NotificationsBloc>()
                .add(NotificationIgnoreFollowRequest(request: request));
          },
          child: Text(
            'Ignore',
            style: TextStyle(
              color: kPrimaryBlackColor,
              fontFamily: kFontFamily,
            ),
          ),
        ),
        SizedBox(width: 4),
        ElevatedButton(
          style: ElevatedButton.styleFrom(primary: kPrimaryBlackColor),
          onPressed: () {
            context
                .read<NotificationsBloc>()
                .add(NotificationAcceptFollowRequest(request: request));
          },
          child: Text(
            'Accept',
            style: TextStyle(
              color: kPrimaryWhiteColor,
              fontFamily: kFontFamily,
            ),
          ),
        ),
      ],
    ),
    onTap: () => Navigator.of(context).pushNamed(
      ProfileScreen.routeName,
      arguments: ProfileScreenArgs(userId: request.fromUser.id),
    ),
  );
}
