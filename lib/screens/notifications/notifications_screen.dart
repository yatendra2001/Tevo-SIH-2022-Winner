import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tevo/screens/notifications/bloc/notifications_bloc.dart';
import 'package:tevo/screens/notifications/widgets/widgets.dart';
import 'package:tevo/widgets/widgets.dart';

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
          switch (state.status) {
            case NotificationsStatus.error:
              return CenteredText(text: state.failure.message);
            case NotificationsStatus.loaded:
              return ListView.builder(
                itemCount: state.notifications.length,
                itemBuilder: (BuildContext context, int index) {
                  final notification = state.notifications[index];
                  return NotificationTile(notification: notification!);
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
