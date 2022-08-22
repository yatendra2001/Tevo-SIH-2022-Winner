part of 'event_bloc.dart';

enum EventStatus { intial, loading, loaded }

class EventState extends Equatable {
  final List<Event>? events;
  final Failure failure;
  final EventStatus status;

  EventState({
    this.events,
    required this.failure,
    required this.status,
  });

  factory EventState.initial() {
    return EventState(
        failure: Failure(), status: EventStatus.intial, events: null);
  }

  EventState copyWith({
    List<Event>? events,
    Failure? failure,
    EventStatus? status,
  }) {
    return EventState(
      events: events ?? this.events,
      failure: failure ?? this.failure,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [events, failure, status];
}
