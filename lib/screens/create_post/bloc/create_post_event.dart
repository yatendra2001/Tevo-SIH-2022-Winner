part of 'create_post_bloc.dart';

abstract class CreatePostEvent extends Equatable {
  const CreatePostEvent();

  @override
  List<Object> get props => [];
}

class AddTaskEvent extends CreatePostEvent {
  final List<Task> task;
  const AddTaskEvent({
    required this.task,
  });
  @override
  List<Object> get props => [task];
}

class CompleteTaskEvent extends CreatePostEvent {
  final Task task;

  const CompleteTaskEvent({
    required this.task,
  });

  @override
  List<Object> get props => [task];
}

class GetTaskEvent extends CreatePostEvent {
  const GetTaskEvent();
  @override
  List<Object> get props => [];
}

class DeleteTaskEvent extends CreatePostEvent {
  final Task task;
  const DeleteTaskEvent({
    required this.task,
  });
  @override
  List<Object> get props => [task];
}

class DeletePostEvent extends CreatePostEvent {
  const DeletePostEvent();
  @override
  List<Object> get props => [];
}
