part of 'notifications_bloc.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

class NotificationsUpdateNotifications extends NotificationsEvent {
  final List<Notif?> notifications;

  const NotificationsUpdateNotifications({required this.notifications});

  @override
  List<Object?> get props => [notifications];
}

class NotificationsUpdateRequests extends NotificationsEvent {
  final List<Notif?> requests;

  const NotificationsUpdateRequests({required this.requests});

  @override
  List<Object?> get props => [requests];
}

class NotificationAcceptFollowRequest extends NotificationsEvent {
  final Notif request;
  NotificationAcceptFollowRequest({
    required this.request,
  });

  @override
  List<Object?> get props => [request];
}

class NotificationIgnoreFollowRequest extends NotificationsEvent {
  final Notif request;
  NotificationIgnoreFollowRequest({
    required this.request,
  });

  @override
  List<Object?> get props => [request];
}
