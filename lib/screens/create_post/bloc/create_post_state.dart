part of 'create_post_bloc.dart';

enum CreatePostStateStatus { initial, loading, loaded }

class CreatePostState extends Equatable {
  final Post? post;
  final List<Task> todoTask;
  final CreatePostStateStatus status;
  final List<Task> completedTask;
  final Timestamp? dateTime;
  final Failure failure;

  const CreatePostState({
    this.post,
    required this.todoTask,
    required this.completedTask,
    required this.status,
    this.dateTime,
    required this.failure,
  });

  factory CreatePostState.initial() {
    return const CreatePostState(
      post: null,
      todoTask: [],
      status: CreatePostStateStatus.initial,
      completedTask: [],
      dateTime: null,
      failure: Failure(),
    );
  }

  CreatePostState empty() {
    return const CreatePostState(
      post: null,
      todoTask: [],
      completedTask: [],
      status: CreatePostStateStatus.initial,
      dateTime: null,
      failure: Failure(),
    );
  }

  CreatePostState copyWith({
    Post? post,
    List<Task>? todoTask,
    List<Task>? completedTask,
    CreatePostStateStatus? status,
    Timestamp? dateTime,
    Failure? failure,
  }) {
    return CreatePostState(
      post: post ?? this.post,
      todoTask: todoTask ?? this.todoTask,
      completedTask: completedTask ?? this.completedTask,
      status: status ?? this.status,
      dateTime: dateTime ?? this.dateTime,
      failure: failure ?? this.failure,
    );
  }

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props =>
      [post, dateTime, todoTask, completedTask, failure, status];
}
