import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tevo/config/paths.dart';
import 'package:tevo/models/notif_model.dart';
import 'package:tevo/repositories/repositories.dart';

class NotificationRepository extends BaseNotificationRepository {
  final FirebaseFirestore _firebaseFirestore;

  NotificationRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Future<Notif?>>> getUserNotifications({required String userId}) {
    return _firebaseFirestore
        .collection(Paths.notifications)
        .doc(userId)
        .collection(Paths.userNotifications)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs.map((doc) => Notif.fromDocument(doc)).toList(),
        );
  }

  @override
  Stream<List<Future<Notif?>>> getUserRequests({required String userId}) {
    return _firebaseFirestore
        .collection(Paths.requests)
        .doc(userId)
        .collection(Paths.userRequests)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs.map((doc) => Notif.fromDocument(doc)).toList(),
        );
  }
}
