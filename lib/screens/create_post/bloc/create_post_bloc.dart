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
        postId: post.id,
        dateTime: post.enddate,
      );
    }
  }

  Stream<CreatePostState> _mapToCompleteTaskEvent(
      CompleteTaskEvent event) async* {
    List<Task> completeTask = List<Task>.from(state.completedTask)
      ..add(event.task);
    List<Task> toDoTask = List<Task>.from(state.todoTask)..remove(event.task);
    yield state.copyWith(todoTask: toDoTask, completedTask: completeTask);
    submit();
  }

  void submit() async {
    final userId = _authBloc.state.user!.uid;
    final user = await _userRepository.getUserWithId(userId: userId);
    final post = Post(
      id: state.postId,
      author: user,
      toDoTask: state.todoTask,
      completedTask: state.completedTask,
      likes: 0,
      enddate: state.dateTime ?? DateTime.now().add(const Duration(hours: 24)),
    );
    if (state.postId == null) {
      await _postRepository.createPost(post: post);
    } else {
      _postRepository.updatePost(post: post);
    }
  }
}
