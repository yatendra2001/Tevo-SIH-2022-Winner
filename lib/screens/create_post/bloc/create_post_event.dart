part of 'create_post_bloc.dart';

abstract class CreatePostEvent extends Equatable {
  const CreatePostEvent();

  @override
  List<Object> get props => [];
}

class AddTaskEvent extends CreatePostEvent {
  final Task task;
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
