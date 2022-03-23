import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final DateTime dateTime;
  final String task;

  const Task({
    required this.dateTime,
    required this.task,
  });

  Task copyWith({
    DateTime? dateTime,
    String? task,
  }) {
    return Task(
      dateTime: dateTime ?? this.dateTime,
      task: task ?? this.task,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dateTime': dateTime,
      'task': task,
    };
  }

  // factory TaskModel.fromMap(Map<String, dynamic> map) {
  //   return TaskModel(
  //     timestamp: T
  //     task: map['task'] ?? '',
  //   );
  // }

  @override
  List<Object?> get props => [dateTime, task];
}
