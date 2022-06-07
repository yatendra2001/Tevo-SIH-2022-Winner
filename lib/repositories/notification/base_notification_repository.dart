import 'package:tevo/models/models.dart';

abstract class BaseNotificationRepository {
  Stream<List<Future<Notif?>>> getUserNotifications({required String userId});
  Stream<List<Future<Notif?>>> getUserRequests({required String userId});
}
