import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final Timestamp timestamp;
  final String task;
  final int likes;

  const Task({
    required this.timestamp,
    required this.task,
    required this.likes,
  });

  Map<String, dynamic> toMap() {
    return {'timestamp': timestamp, 'task': task, 'likes': likes};
  }

  @override
  List<Object?> get props => [timestamp, task, likes];

  Task copyWith({
    Timestamp? timestamp,
    String? task,
    int? likes,
  }) {
    return Task(
      timestamp: timestamp ?? this.timestamp,
      task: task ?? this.task,
      likes: likes ?? this.likes,
    );
  }
}
