part of 'create_post_bloc.dart';

abstract class CreatePostEvent extends Equatable {
  const CreatePostEvent();

  @override
  List<Object> get props => [];
}

class AddTaskEvent extends CreatePostEvent {
  final Task task;
  final int index;
  const AddTaskEvent({
    this.index = 0,
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

class UpdateTask extends CreatePostEvent {
  final Task task;
  final int index;

  const UpdateTask({
    required this.task,
    required this.index,
  });

  @override
  List<Object> get props => [task, index];
}

class ClearPost extends CreatePostEvent {
  const ClearPost();
  @override
  List<Object> get props => [];
}

class SubmitPost extends CreatePostEvent {
  const SubmitPost();
  @override
  List<Object> get props => [];
}

class RepeatTask extends CreatePostEvent {
  final Task task;
  final int index;
  const RepeatTask({
    required this.task,
    required this.index,
  });
  @override
  List<Object> get props => [task, index];
}

class ReorderEvent extends CreatePostEvent {
  final int oldIndex;
  final int newIndex;

  ReorderEvent({
    required this.oldIndex,
    required this.newIndex,
  });
}
