import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tevo/blocs/blocs.dart';
import 'package:tevo/models/models.dart';
import 'package:tevo/repositories/repositories.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationRepository _notificationRepository;
  final AuthBloc _authBloc;
  final UserRepository _userRepository;

  StreamSubscription<List<Future<Notif?>>>? _notificationsSubscription;
  StreamSubscription<List<Future<Notif?>>>? _requestsSubscription;

  NotificationsBloc({
    required NotificationRepository notificationRepository,
    required AuthBloc authBloc,
    required UserRepository userRepository,
  })  : _notificationRepository = notificationRepository,
        _authBloc = authBloc,
        _userRepository = userRepository,
        super(NotificationsState.initial()) {
    _notificationsSubscription?.cancel();
    _requestsSubscription?.cancel();
    _notificationsSubscription = _notificationRepository
        .getUserNotifications(userId: _authBloc.state.user!.uid)
        .listen((notifications) async {
      final allNotifications = await Future.wait(notifications);
      add(NotificationsUpdateNotifications(notifications: allNotifications));
    });
    _requestsSubscription = _notificationRepository
        .getUserRequests(userId: _authBloc.state.user!.uid)
        .listen((requests) async {
      final allrequests = await Future.wait(requests);
      add(NotificationsUpdateRequests(requests: allrequests));
    });
  }

  @override
  Future<void> close() {
    _notificationsSubscription?.cancel();
    _requestsSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<NotificationsState> mapEventToState(NotificationsEvent event) async* {
    if (event is NotificationsUpdateNotifications) {
      yield* _mapNotificationsUpdateNotificationsToState(event);
    } else if (event is NotificationsUpdateRequests) {
      yield* _mapNotificationsUpdateRequestsToState(event);
    } else if (event is NotificationAcceptFollowRequest) {
      yield* _mapToAcceptFollowRequestToState(event);
    } else if (event is NotificationIgnoreFollowRequest) {
      yield* _mapToIgnoreFollowRequest(event);
    }
  }

  Stream<NotificationsState> _mapNotificationsUpdateNotificationsToState(
    NotificationsUpdateNotifications event,
  ) async* {
    yield state.copyWith(
      notifications: event.notifications,
      status: NotificationsStatus.loaded,
    );
  }

  Stream<NotificationsState> _mapNotificationsUpdateRequestsToState(
    NotificationsUpdateRequests event,
  ) async* {
    yield state.copyWith(
      requests: event.requests,
      status: NotificationsStatus.loaded,
    );
  }

  Stream<NotificationsState> _mapToAcceptFollowRequestToState(
      NotificationAcceptFollowRequest event) async* {
    final followUserId =
        _authBloc.state.user!.uid; //The id that is being followed
    final userId = event.request.fromUser.id; //The id that want to follow
    _userRepository.followUser(
      userId: userId,
      followUserId: followUserId,
      requestId: event.request.id!,
    );
  }

  Stream<NotificationsState> _mapToIgnoreFollowRequest(
      NotificationIgnoreFollowRequest event) async* {
    final followUserId =
        _authBloc.state.user!.uid; //The id that is being followed (currentId)
    _userRepository.deleteRequest(
        requestId: event.request.id!, followUserId: followUserId);
  }
}
