import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tevo/blocs/auth/auth_bloc.dart';
import 'package:tevo/models/models.dart';
import 'package:tevo/repositories/repositories.dart';
import 'package:tevo/screens/create_post/bloc/create_post_bloc.dart';
import 'package:tevo/widgets/task_tile.dart';

class AddTaskScreen extends StatefulWidget {
  static const routeName = 'add_task_screen';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<CreatePostBloc>(
        create: (context) => CreatePostBloc(
          authBloc: context.read<AuthBloc>(),
          userRepository: context.read<UserRepository>(),
          postRepository: context.read<PostRepository>(),
        )..add(const GetTaskEvent()),
        child: const AddTaskScreen(),
      ),
    );
  }

  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePostBloc, CreatePostState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Add Task',
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  context.read<CreatePostBloc>().submit();
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.save,
                ),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                TextField(
                  autofocus: true,
                  controller: _textEditingController,
                  decoration: const InputDecoration(label: Text('Enter Task')),
                  onSubmitted: (_) {
                    context.read<CreatePostBloc>().add(
                          AddTaskEvent(
                            task: Task(
                                timestamp: Timestamp.now(),
                                task: _textEditingController.text,
                                likes: 0),
                          ),
                        );
                    _textEditingController.clear();
                  },
                ),
                _buildToDoTaskList(state, context),
              ],
            ),
          ),
        );
      },
    );
  }
}

_buildToDoTaskList(CreatePostState state, BuildContext context) {
  final todoTask = state.todoTask;
  return Expanded(
    child: todoTask.isEmpty
        ? const Center(
            child: Text('Add Task Now'),
          )
        : ListView.builder(
            itemBuilder: (_, index) => TaskTile(
              task: todoTask[index],
              isDeleted: () => context.read<CreatePostBloc>().add(
                    DeleteTaskEvent(
                      task: todoTask[index],
                    ),
                  ),
              isComplete: false,
            ),
            itemCount: todoTask.length,
          ),
  );
}
