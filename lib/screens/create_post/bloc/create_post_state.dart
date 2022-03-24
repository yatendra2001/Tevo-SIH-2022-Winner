part of 'create_post_bloc.dart';

class CreatePostState extends Equatable {
  List<Task> todoTask;
  List<Task> completedTask;
  Failure failure;

  CreatePostState({
    required this.todoTask,
    required this.completedTask,
    required this.failure,
  });

  factory CreatePostState.initial() {
    return CreatePostState(
      todoTask: [],
      completedTask: [],
      failure: Failure(),
    );
  }

  CreatePostState copyWith({
    List<Task>? todoTask,
    List<Task>? completedTask,
    Failure? failure,
  }) {
    return CreatePostState(
      todoTask: todoTask ?? this.todoTask,
      completedTask: completedTask ?? this.completedTask,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [todoTask, completedTask, failure];
}
