import 'package:bloc/bloc.dart';
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
    }
  }

  Stream<CreatePostState> _mapToAddTaskEvent(AddTaskEvent event) async* {
    final toDoTask = List<Task>.from(state.todoTask)..add(event.task);
    yield state.copyWith(todoTask: toDoTask);
  }

  Stream<CreatePostState> _mapToGetTaskEvent(GetTaskEvent event) async* {
    final userId = _authBloc.state.user!.uid;
    final post = await _postRepository.getUserLastPost(userId: userId);
    if (post != null) {
      yield state.copyWith(
        todoTask: post.toDoTask,
        completedTask: post.completedTask,
        post: post,
        dateTime: post.enddate,
      );
    }
  }

  Stream<CreatePostState> _mapToCompleteTaskEvent(
      CompleteTaskEvent event) async* {
    final completeTask = List<Task>.from(state.completedTask)..add(event.task);
    final toDoTask = List<Task>.from(state.todoTask)..remove(event.task);
    yield state.copyWith(todoTask: toDoTask, completedTask: completeTask);
    submit();
  }

  Stream<CreatePostState> _mapToDeleteTask(DeleteTaskEvent event) async* {
    final toDoTask = List<Task>.from(state.todoTask)..remove(event.task);
    yield state.copyWith(todoTask: toDoTask);
    submit();
  }

  Stream<CreatePostState> _mapTodeletePost(DeletePostEvent event) async* {
    if (state.post != null) {
      _postRepository.deletePost(postId: state.post!.id!);
    }
    state.copyWith(
      completedTask: [],
      dateTime: null,
      post: null,
      todoTask: [],
    );
  }

  void submit() async {
    final userId = _authBloc.state.user!.uid;
    final user = await _userRepository.getUserWithId(userId: userId);
    final post = Post(
      id: state.post!.id,
      author: user,
      toDoTask: state.todoTask,
      completedTask: state.completedTask,
      enddate: state.dateTime ?? DateTime.now().add(const Duration(hours: 24)),
    );
    if (state.post == null) {
      await _postRepository.createPost(post: post);
    } else {
      _postRepository.updatePost(post: post);
    }
  }

  // Future<Post?> findPost(String postId) async {
  //   return await _postRepository.getPost(postId);
  // }
}
