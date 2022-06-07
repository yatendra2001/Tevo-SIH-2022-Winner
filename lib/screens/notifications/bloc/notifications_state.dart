part of 'notifications_bloc.dart';

enum NotificationsStatus { initial, loading, loaded, error }

class NotificationsState extends Equatable {
  final List<Notif?> notifications;
  final List<Notif?> requests;
  final NotificationsStatus status;
  final Failure failure;

  const NotificationsState({
    required this.notifications,
    required this.requests,
    required this.status,
    required this.failure,
  });

  factory NotificationsState.initial() {
    return const NotificationsState(
      notifications: [],
      requests: [],
      status: NotificationsStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object?> get props => [notifications, status, failure, requests];

  NotificationsState copyWith({
    List<Notif?>? notifications,
    List<Notif?>? requests,
    NotificationsStatus? status,
    Failure? failure,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      requests: requests ?? this.requests,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
