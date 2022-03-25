import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final Timestamp timestamp;
  final String task;

  const Task({
    required this.timestamp,
    required this.task,
  });

  Task copyWith({
    Timestamp? timestamp,
    String? task,
  }) {
    return Task(
      timestamp: timestamp ?? this.timestamp,
      task: task ?? this.task,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp,
      'task': task,
    };
  }

  @override
  List<Object?> get props => [timestamp, task];
}
