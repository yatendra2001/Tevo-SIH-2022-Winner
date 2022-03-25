part of 'create_post_bloc.dart';

class CreatePostState extends Equatable {
  final String? postId;
  final List<Task> todoTask;
  final List<Task> completedTask;
  final DateTime? dateTime;
  final Failure failure;

  const CreatePostState({
    required this.postId,
    required this.todoTask,
    required this.completedTask,
    required this.dateTime,
    required this.failure,
  });

  factory CreatePostState.initial() {
    return const CreatePostState(
      postId: null,
      todoTask: [],
      completedTask: [],
      dateTime: null,
      failure: Failure(),
    );
  }

  CreatePostState copyWith({
    String? postId,
    List<Task>? todoTask,
    List<Task>? completedTask,
    DateTime? dateTime,
    Failure? failure,
  }) {
    return CreatePostState(
      postId: postId ?? this.postId,
      todoTask: todoTask ?? this.todoTask,
      completedTask: completedTask ?? this.completedTask,
      dateTime: dateTime ?? this.dateTime,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props =>
      [postId, dateTime, todoTask, completedTask, failure];
}
