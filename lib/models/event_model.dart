import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Event extends Equatable {
  final String? id;
  final String description;
  final DateTime startDate;
  final String creatorId;
  final DateTime endDate;
  final String roomCode;
  final int joiningAmount;
  final List<String> memberIds;

  Event({
    this.id,
    required this.description,
    required this.startDate,
    required this.creatorId,
    required this.endDate,
    required this.roomCode,
    required this.joiningAmount,
    required this.memberIds,
  });

  Event copyWith({
    String? id,
    String? description,
    DateTime? startDate,
    String? creatorId,
    DateTime? endDate,
    String? roomCode,
    int? joiningAmount,
    List<String>? memberIds,
  }) {
    return Event(
      id: id ?? this.id,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      creatorId: creatorId ?? this.creatorId,
      endDate: endDate ?? this.endDate,
      roomCode: roomCode ?? this.roomCode,
      joiningAmount: joiningAmount ?? this.joiningAmount,
      memberIds: memberIds ?? this.memberIds,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'startDate': startDate.millisecondsSinceEpoch,
      'creatorId': creatorId,
      'endDate': endDate.millisecondsSinceEpoch,
      'roomCode': roomCode,
      'joiningAmount': joiningAmount,
      'memberIds': memberIds,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      description: map['description'] ?? '',
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate']),
      creatorId: map['creatorId'] ?? '',
      endDate: DateTime.fromMillisecondsSinceEpoch(map['endDate']),
      roomCode: map['roomCode'] ?? '',
      joiningAmount: map['joiningAmount']?.toInt() ?? 0,
      memberIds: List<String>.from(map['memberIds']),
    );
  }

  @override
  List<Object> get props {
    return [
      id!,
      description,
      startDate,
      creatorId,
      endDate,
      roomCode,
      joiningAmount,
      memberIds,
    ];
  }
}
