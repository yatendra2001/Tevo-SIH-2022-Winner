import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tevo/screens/notifications/bloc/notifications_bloc.dart';
import 'package:tevo/screens/notifications/widgets/widgets.dart';
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
        title: const Text(
          "Notifications",
        ),
      ),
      body: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) {
          final requestlist = state.requests;
          final notificationList = state.notifications;
          switch (state.status) {
            case NotificationsStatus.error:
              return CenteredText(text: state.failure.message);
            case NotificationsStatus.loaded:
              return ListView.builder(
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
          child: Text('Ignore'),
        ),
        ElevatedButton(
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
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:tevo/screens/notifications/bloc/notifications_bloc.dart';
// import 'package:tevo/screens/notifications/widgets/widgets.dart';
// import 'package:tevo/widgets/widgets.dart';

// class NotificationsScreen extends StatelessWidget {
//   static const String routeName = '/notifications';

//   const NotificationsScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         title: const Text(
//           "Notifications",
//         ),
//       ),
//       body: BlocBuilder<NotificationsBloc, NotificationsState>(
//         builder: (context, state) {
//           switch (state.status) {
//             case NotificationsStatus.error:
//               return CenteredText(text: state.failure.message);
//             case NotificationsStatus.loaded:
//               return ListView.builder(
//                 itemCount: state.requests.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   final notification = state.requests[index];
//                   return NotificationTile(notification: notification!);
//                 },
//               );
//             default:
//               return const Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//     );
//   }
// }
