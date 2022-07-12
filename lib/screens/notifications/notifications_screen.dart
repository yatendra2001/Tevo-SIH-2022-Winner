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

class NotificationsScreen extends StatelessWidget {
  static const String routeName = '/notifications';

  const NotificationsScreen({Key? key}) : super(key: key);

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
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
        ),
      ),
      body: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) {
          final requestlist = state.requests;
          final notificationList = state.notifications;
          switch (state.status) {
            case NotificationsStatus.error:
              return CenteredText(text: state.failure.message);
            case NotificationsStatus.loading:
              return const Center(child: CircularProgressIndicator());
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
                                  color: kPrimaryBlackColor, fontSize: 12.sp),
                            ),
                          ),
                          Spacer(
                            flex: 4,
                          )
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: requestlist.length + notificationList.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (index < requestlist.length) {
                          final request = requestlist[index];
                          return _buildRequestTile(context, state, request!);
                        } else {
                          final notification = notificationList[index];
                          return NotificationTile(
                            notification: notification!,
                          );
                        }
                      },
                    );
            default:
              return const Center(child: CircularProgressIndicator());
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
      iconRadius: 12,
      profileImageUrl: request.fromUser.profileImageUrl,
    ),
    title: Text('${request.fromUser.username} requested to follow you'),
    trailing: Wrap(
      children: [
        OutlinedButton(
          onPressed: () {
            context
                .read<NotificationsBloc>()
                .add(NotificationIgnoreFollowRequest(request: request));
          },
          child: const Text(
            'Ignore',
            style: TextStyle(color: kPrimaryBlackColor),
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
          child: Text('Accept'),
        ),
      ],
    ),
    onTap: () => Navigator.of(context).pushNamed(
      ProfileScreen.routeName,
      arguments: ProfileScreenArgs(userId: request.fromUser.id),
    ),
  );
}
