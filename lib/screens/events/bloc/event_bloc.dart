import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tevo/models/event_model.dart';
import 'package:tevo/models/failure_model.dart';

import 'package:tevo/repositories/event/event_repository.dart';
import 'package:tevo/utils/session_helper.dart';

part 'event_event.dart';
part 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final EventRepository _eventRepository;

  EventBloc({required EventRepository eventRepository})
      : _eventRepository = eventRepository,
        super(EventState.initial());

  @override
  Future<void> close() {
    return super.close();
  }

  @override
  Stream<EventState> mapEventToState(event) async* {
    if (event is GetUserEvent) {
      yield* _mapToGetUserEvent(event);
    }
  }

  Stream<EventState> _mapToGetUserEvent(GetUserEvent event) async* {
    if (state.status != EventStatus.loading) {
      yield state.copyWith(status: EventStatus.loading);
      List<Event> events =
          await _eventRepository.getUserEvents(userId: SessionHelper.uid!);
      yield state.copyWith(events: events, status: EventStatus.loaded);
    }
  }
}
