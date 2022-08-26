import 'dart:convert';

import 'package:equatable/equatable.dart';

class Event extends Equatable {
  final String? id;
  final String eventName;
  final String description;
  final DateTime startDate;
  final String creatorId;
  final DateTime endDate;
  final String roomCode;
  final int joiningAmount;
  final String type; //peer to peer or Admin to user
  final List<String> memberIds;
  final bool paid;

  Event({
    this.id,
    required this.eventName,
    required this.description,
    required this.startDate,
    required this.creatorId,
    required this.endDate,
    required this.roomCode,
    required this.joiningAmount,
    required this.type,
    required this.memberIds,
    required this.paid,
  });

  Event copyWith({
    String? id,
    String? eventName,
    String? description,
    DateTime? startDate,
    String? creatorId,
    DateTime? endDate,
    String? roomCode,
    int? joiningAmount,
    String? type,
    List<String>? memberIds,
    bool? paid,
  }) {
    return Event(
      id: id ?? this.id,
      eventName: eventName ?? this.eventName,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      creatorId: creatorId ?? this.creatorId,
      endDate: endDate ?? this.endDate,
      roomCode: roomCode ?? this.roomCode,
      joiningAmount: joiningAmount ?? this.joiningAmount,
      type: type ?? this.type,
      memberIds: memberIds ?? this.memberIds,
      paid: paid ?? this.paid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'eventName': eventName,
      'description': description,
      'startDate': startDate.millisecondsSinceEpoch,
      'creatorId': creatorId,
      'endDate': endDate.millisecondsSinceEpoch,
      'roomCode': roomCode,
      'joiningAmount': joiningAmount,
      'type': type,
      'memberIds': memberIds,
      'paid': paid,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map, String id) {
    return Event(
      id: id,
      eventName: map['eventName'] ?? '',
      description: map['description'] ?? '',
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate']),
      creatorId: map['creatorId'] ?? '',
      endDate: DateTime.fromMillisecondsSinceEpoch(map['endDate']),
      roomCode: map['roomCode'] ?? '',
      joiningAmount: map['joiningAmount']?.toInt() ?? 0,
      type: map['type'] ?? '',
      memberIds: List<String>.from(map['memberIds']),
      paid: map['paid'] ?? false,
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      eventName,
      description,
      startDate,
      creatorId,
      endDate,
      roomCode,
      joiningAmount,
      type,
      memberIds,
      paid,
    ];
  }
}
