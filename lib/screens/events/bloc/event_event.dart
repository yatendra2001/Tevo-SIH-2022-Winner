part of 'event_bloc.dart';

abstract class EventEvent extends Equatable {
  const EventEvent();

  @override
  List<Object> get props => [];
}

class GetUserEvent extends EventEvent {
  const GetUserEvent();
  @override
  List<Object> get props => [];
}

class AddEvent extends EventEvent {
  final List<Event> events;
  AddEvent({
    required this.events,
  });

  @override
  List<Object> get props => [events];
}
