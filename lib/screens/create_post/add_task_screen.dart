import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tevo/blocs/auth/auth_bloc.dart';
import 'package:tevo/models/models.dart';
import 'package:tevo/repositories/post/post_repository.dart';
import 'package:tevo/repositories/repositories.dart';
import 'package:tevo/screens/create_post/bloc/create_post_bloc.dart';
import 'package:tevo/screens/create_post/widgets/task_card.dart';

class AddTaskScreen extends StatefulWidget {
  static const routeName = 'add_task_screen';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider(
        create: (context) => CreatePostBloc(
          authBloc: context.read<AuthBloc>(),
          userRepository: context.read<UserRepository>(),
          postRepository: context.read<PostRepository>(),
        ),
        child: AddTaskScreen(),
      ),
    );
  }

  AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreatePostBloc, CreatePostState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Add Task',
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  context.read<CreatePostBloc>().submit();
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
                              dateTime: DateTime.now(),
                              task: _textEditingController.text,
                            ),
                          ),
                        );
                    _textEditingController.clear();
                    setState(() {});
                  },
                ),
                _buildToDoTaskList(state),
              ],
            ),
          ),
        );
      },
    );
  }
}

_buildToDoTaskList(CreatePostState state) {
  return Expanded(
    child: state.todoTask.isEmpty
        ? const Center(child: Text('Add Task Now'))
        : ListView.builder(
            itemBuilder: (_, index) =>
                TaskCard(task: state.todoTask[index], index: index + 1),
            itemCount: state.todoTask.length,
          ),
  );
}
