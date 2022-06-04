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
  StreamSubscription<Future<Post?>>? _postSubscription;

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
    _postSubscription?.cancel();
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
    } else if (event is UpdatePost) {
      yield* _mapToUpdatePost(event);
    } else if (event is ClearPost) {
      yield* _mapToClearPost(event);
    }
  }

  Stream<CreatePostState> _mapToClearPost(ClearPost event) async* {
    await _postSubscription?.cancel();
    yield state.copyWith(
      completedTask: [],
      dateTime: null,
      post: null,
      todoTask: [],
    );
  }

  Stream<CreatePostState> _mapToGetTaskEvent(GetTaskEvent event) async* {
    final userId = _authBloc.state.user!.uid;
    _postSubscription = _postRepository
        .getUserLastPost(userId: userId)
        ?.listen((newpost) async {
      final post = await newpost;
      if (post != null) {
        add(UpdatePost(post: post));
        print("++++++++++++++++++${post.enddate.toDate()}");
      }
    });
  }

  Stream<CreatePostState> _mapToUpdatePost(UpdatePost event) async* {
    yield state.copyWith(
      todoTask: event.post.toDoTask,
      completedTask: event.post.completedTask,
      post: event.post,
      dateTime: event.post.enddate,
    );
  }

  Stream<CreatePostState> _mapToAddTaskEvent(AddTaskEvent event) async* {
    List<Task> toDoTask = List<Task>.from(state.todoTask)
      ..insert(0, event.task);
    yield state.copyWith(todoTask: toDoTask);
    submit();
  }

  Stream<CreatePostState> _mapToCompleteTaskEvent(
      CompleteTaskEvent event) async* {
    List<Task> completeTask = List<Task>.from(state.completedTask)
      ..add(event.task);
    List<Task> toDoTask = List<Task>.from(state.todoTask)..remove(event.task);
    yield state.copyWith(todoTask: toDoTask, completedTask: completeTask);
    submit();
  }

  Stream<CreatePostState> _mapToDeleteTask(DeleteTaskEvent event) async* {
    List<Task> toDoTask = List<Task>.from(state.todoTask)..remove(event.task);
    yield state.copyWith(todoTask: toDoTask);
    submit();
  }

  Stream<CreatePostState> _mapTodeletePost(DeletePostEvent event) async* {
    if (state.post != null) {
      _postRepository.deletePost(postId: state.post!.id!);
      add(ClearPost());
    }
  }

  void submit() async {
    final userId = _authBloc.state.user!.uid;
    final user = await _userRepository.getUserWithId(userId: userId);
    final post = Post(
      id: state.post != null ? state.post!.id : null,
      author: user,
      toDoTask: state.todoTask,
      completedTask: state.completedTask,
      enddate: state.dateTime ??
          Timestamp(Timestamp.now().seconds + 10, Timestamp.now().nanoseconds),
    );
    if (state.post == null) {
      await _postRepository.createPost(post: post);
    } else {
      _postRepository.updatePost(post: post);
    }
  }
}
