import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tevo/config/paths.dart';
import 'package:tevo/models/event_model.dart';
import 'package:tevo/repositories/event/base_event_repository.dart';

class EventRepository extends BaseEventRepository {
  final FirebaseFirestore _firebaseFirestore;

  EventRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<Event> getEvent({required String eventId}) async {
    final event =
        await _firebaseFirestore.collection(Paths.events).doc(eventId).get();
    return Event.fromMap(event.data()!);
  }

  Future<void> createEvent({required Event event}) async {
    final refId =
        await _firebaseFirestore.collection(Paths.events).add(event.toMap());
    await _firebaseFirestore
        .collection(Paths.usersEvents)
        .doc(event.creatorId)
        .collection(Paths.userEvent)
        .doc(refId.id)
        .set({});
  }

  Future<List<Event>> getUserEvents({required String userId}) async {
    List<String> eventIds = [];
    List<Event> events = [];
    final snap = await _firebaseFirestore
        .collection(Paths.usersEvents)
        .doc(userId)
        .collection(Paths.userEvent)
        .get();
    for (var element in snap.docs) {
      eventIds.add(element.id);
    }
    eventIds.forEach((element) async {
      final event = await getEvent(eventId: element);
      events.add(event);
    });
    return events;
  }
}
