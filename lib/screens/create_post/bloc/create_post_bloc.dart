import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tevo/blocs/auth/auth_bloc.dart';
import 'package:tevo/models/failure_model.dart';
import 'package:tevo/models/models.dart';
import 'package:tevo/repositories/post/post_repository.dart';
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
    }
  }

  Stream<CreatePostState> _mapToAddTaskEvent(AddTaskEvent event) async* {
    final toDoTask = List<Task>.from(state.todoTask)..add(event.task);
    yield state.copyWith(todoTask: toDoTask);
  }

  Stream<CreatePostState> _mapToCompleteTaskEvent(
      CompleteTaskEvent event) async* {
    List<Task> completeTask = state.completedTask;
    List<Task> toDoTask = state.todoTask;
    toDoTask.remove(event.task);
    completeTask.add(event.task);
    yield state.copyWith(todoTask: toDoTask, completedTask: completeTask);
  }

  void submit() async {
    final userId = _authBloc.state.user!.uid;
    final user = await _userRepository.getUserWithId(userId: userId);
    final post = Post(
      author: user,
      toDoTask: state.todoTask,
      completedTask: state.completedTask,
      likes: 0,
      date: DateTime.now(),
    );
    await _postRepository.createPost(post: post);
  }
}
