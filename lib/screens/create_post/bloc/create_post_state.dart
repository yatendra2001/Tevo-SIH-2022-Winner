part of 'create_post_bloc.dart';

class CreatePostState extends Equatable {
  final List<Task> todoTask;
  final List<Task> completedTask;
  final Failure failure;

  const CreatePostState({
    required this.todoTask,
    required this.completedTask,
    required this.failure,
  });

  factory CreatePostState.initial() {
    return const CreatePostState(
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
