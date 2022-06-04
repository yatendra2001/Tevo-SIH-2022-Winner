import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String title;
  final String? description;
  final int priority;
  final bool repeat;
  final DateTime dateTime;

  const Task({
    required this.title,
    this.description,
    required this.priority,
    this.repeat = false,
    required this.dateTime,
  });

  Task copyWith({
    String? title,
    String? description,
    int? priority,
    bool? repeat,
    DateTime? dateTime,
  }) {
    return Task(
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      repeat: repeat ?? this.repeat,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'priority': priority,
      'repeat': repeat,
      'dateTime': Timestamp.fromDate(dateTime),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'] ?? '',
      description: map['description'],
      priority: map['priority']?.toInt() ?? 0,
      repeat: map['repeat'] ?? false,
      dateTime: (map['dateTime'] as Timestamp).toDate(),
    );
  }

  @override
  List<Object> get props {
    return [
      title,
      description!,
      priority,
      repeat,
      dateTime,
    ];
  }
}
