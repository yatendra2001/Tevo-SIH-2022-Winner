import 'dart:async';

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
    List<Task> toDoTask = List<Task>.from(state.todoTask)
      ..insert(event.index, event.task);

    yield state.copyWith(todoTask: toDoTask);
    add(const SubmitPost());
  }

  Stream<CreatePostState> _mapToCompleteTaskEvent(
      CompleteTaskEvent event) async* {
    List<Task> completeTask = List<Task>.from(state.completedTask)
      ..add(event.task);
    List<Task> toDoTask = List<Task>.from(state.todoTask)..remove(event.task);
    yield state.copyWith(todoTask: toDoTask, completedTask: completeTask);
    add(const SubmitPost());
  }

  Stream<CreatePostState> _mapToDeleteTask(DeleteTaskEvent event) async* {
    List<Task> toDoTask = List<Task>.from(state.todoTask)..remove(event.task);
    List<Task> completeTask = List<Task>.from(state.completedTask)
      ..remove(event.task);
    yield state.copyWith(todoTask: toDoTask, completedTask: completeTask);
    add(const SubmitPost());
  }

  Stream<CreatePostState> _mapTodeletePost(DeletePostEvent event) async* {
    if (state.post != null) {
      _postRepository.deletePost(postId: state.post!.id!);
      add(ClearPost());
    }
  }

  Stream<CreatePostState> _mapToUpdateTask(UpdateTask event) async* {
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
      toDoTask: state.todoTask,
      completedTask: state.completedTask,
      enddate: state.dateTime ??
          Timestamp.fromDate(
            DateTime.now().add(
              const Duration(hours: Date),
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
}
