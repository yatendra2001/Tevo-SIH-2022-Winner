part of 'create_post_bloc.dart';

class CreatePostState extends Equatable {
  final Post? post;
  final List<Task> todoTask;
  final List<Task> completedTask;
  final DateTime? dateTime;
  final Failure failure;

  const CreatePostState({
    this.post,
    required this.todoTask,
    required this.completedTask,
    this.dateTime,
    required this.failure,
  });

  factory CreatePostState.initial() {
    return const CreatePostState(
      post: null,
      todoTask: [],
      completedTask: [],
      dateTime: null,
      failure: Failure(),
    );
  }

  CreatePostState copyWith({
    Post? post,
    List<Task>? todoTask,
    List<Task>? completedTask,
    DateTime? dateTime,
    Failure? failure,
  }) {
    return CreatePostState(
      post: post ?? this.post,
      todoTask: todoTask ?? this.todoTask,
      completedTask: completedTask ?? this.completedTask,
      dateTime: dateTime ?? this.dateTime,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [post, dateTime, todoTask, completedTask, failure];
}
