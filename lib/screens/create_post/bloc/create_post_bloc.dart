import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:tevo/blocs/auth/auth_bloc.dart';
import 'package:tevo/models/models.dart';
import 'package:tevo/repositories/repositories.dart';

part 'create_post_event.dart';
part 'create_post_state.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  final PostRepository _postRepository;
  final AuthBloc _authBloc;
  final UserRepository _userRepository;

  CreatePostBloc({
    required PostRepository postRepository,
    required AuthBloc authBloc,
    required UserRepository userRepository,
  })  : _postRepository = postRepository,
        _userRepository = userRepository,
        _authBloc = authBloc,
        super(CreatePostState.initial());

  @override
  Future<void> close() {
    return super.close();
  }

  @override
  Stream<CreatePostState> mapEventToState(CreatePostEvent event) async* {
    if (event is AddTaskEvent) {
      yield* _mapToAddTaskEvent(event);
    } else if (event is CompleteTaskEvent) {
      yield* _mapToCompleteTaskEvent(event);
    } else if (event is GetTaskEvent) {
      yield* _mapToGetTaskEvent(event);
    } else if (event is DeleteTaskEvent) {
      yield* _mapToDeleteTask(event);
    } else if (event is DeletePostEvent) {
      yield* _mapTodeletePost(event);
    } else if (event is UpdateTask) {
      yield* _mapToUpdateTask(event);
    } else if (event is ClearPost) {
      yield* _mapToClearPost(event);
    } else if (event is SubmitPost) {
      yield* _mapToSubmitPost(event);
    } else if (event is RepeatTask) {
      yield* _mapToRepeatTask(event);
    }
  }

  Stream<CreatePostState> _mapToClearPost(ClearPost event) async* {
    yield state.empty();
  }

  Stream<CreatePostState> _mapToGetTaskEvent(GetTaskEvent event) async* {
    yield state.copyWith(status: CreatePostStateStatus.loading);
    final userId = _authBloc.state.user!.uid;
    final post = await _postRepository.getUserLastPost(userId: userId);
    if (post != null) {
      yield state.copyWith(
        todoTask: post.toDoTask,
        completedTask: post.completedTask,
        post: post,
        status: CreatePostStateStatus.loaded,
        dateTime: post.enddate,
      );
    } else {
      yield state.copyWith(status: CreatePostStateStatus.initial);
    }
  }

  Stream<CreatePostState> _mapToAddTaskEvent(AddTaskEvent event) async* {
    List<Task> toDoTask = [];
    List<Task> repeatTask = state.todoTask;
    toDoTask = List<Task>.from(state.todoTask)..insert(event.index, event.task);
    _userRepository.setToDo(1, _authBloc.state.user!.uid);
    if (state.post == null) {
      repeatTask =
          await _userRepository.getRepeatTask(_authBloc.state.user!.uid);
      toDoTask.addAll(repeatTask);
    }

    yield state.copyWith(todoTask: toDoTask, repeatTask: repeatTask);
    add(const SubmitPost());
  }

  Stream<CreatePostState> _mapToCompleteTaskEvent(
      CompleteTaskEvent event) async* {
    List<Task> completeTask = List<Task>.from(state.completedTask)
      ..add(event.task);
    List<Task> toDoTask = List<Task>.from(state.todoTask)..remove(event.task);
    _userRepository.setComplete(1, _authBloc.state.user!.uid);
    yield state.copyWith(todoTask: toDoTask, completedTask: completeTask);
    add(const SubmitPost());
  }

  Stream<CreatePostState> _mapToDeleteTask(DeleteTaskEvent event) async* {
    _userRepository.setToDo(-1, _authBloc.state.user!.uid);
    if (state.completedTask.contains(event.task)) {
      _userRepository.setComplete(-1, _authBloc.state.user!.uid);
    }
    List<Task> toDoTask = List<Task>.from(state.todoTask)..remove(event.task);
    List<Task> completeTask = List<Task>.from(state.completedTask)
      ..remove(event.task);
    yield state.copyWith(todoTask: toDoTask, completedTask: completeTask);
    add(const SubmitPost());
  }

  Stream<CreatePostState> _mapTodeletePost(DeletePostEvent event) async* {
    if (state.post != null) {
      _postRepository.deletePost(postId: state.post!.id!);
      _userRepository.setToDo(
          -state.todoTask.length - state.completedTask.length,
          _authBloc.state.user!.uid);
      _userRepository.setComplete(
          -state.completedTask.length, _authBloc.state.user!.uid);
      add(const ClearPost());
    }
  }

  Stream<CreatePostState> _mapToUpdateTask(UpdateTask event) async* {
    log(event.task.toString());
    List<Task> toDoTask = List<Task>.from(state.todoTask);
    toDoTask[event.index] = event.task;
    yield state.copyWith(todoTask: toDoTask);
    add(const SubmitPost());
  }

  Stream<CreatePostState> _mapToSubmitPost(SubmitPost event) async* {
    final userId = _authBloc.state.user!.uid;
    final user = await _userRepository.getUserWithId(userId: userId);

    Post post = Post(
      id: state.post != null ? state.post!.id : null,
      author: user,
      likes: state.post != null ? state.post!.likes : 0,
      toDoTask: state.todoTask,
      completedTask: state.completedTask,
      enddate: state.dateTime ??
          Timestamp.fromDate(
            DateTime.now().add(
              const Duration(hours: 24),
            ),
          ),
    );

    if (state.post == null) {
      final id = await _postRepository.createPost(post: post);
      Post newPost = post.copyWith(id: id);
      yield state.copyWith(
        post: newPost,
        dateTime: post.enddate,
      );
    } else {
      _postRepository.updatePost(post: post);
    }
  }

  Stream<CreatePostState> _mapToRepeatTask(RepeatTask event) async* {
    List<Task> repeatTask;
    Task task = event.task.copyWith(repeat: !event.task.repeat);
    if (task.repeat == false) {
      repeatTask = List<Task>.from(state.repeatTask)..remove(event.task);
    } else {
      log(state.repeatTask.toString());
      repeatTask = List<Task>.from(state.repeatTask)
        ..add(
          task,
        );
    }
    List<Task> toDoTask = List<Task>.from(state.todoTask);
    toDoTask[event.index] = task;
    yield state.copyWith(repeatTask: repeatTask, todoTask: toDoTask);
    log(repeatTask.toString());
    _userRepository.repeatTaskUpdate(_authBloc.state.user!.uid, repeatTask);
    add(const SubmitPost());
  }
}
