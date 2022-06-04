import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tevo/blocs/auth/auth_bloc.dart';
import 'package:tevo/models/models.dart';
import 'package:tevo/repositories/repositories.dart';
import 'package:tevo/screens/create_post/bloc/create_post_bloc.dart';
import 'package:tevo/widgets/task_tile.dart';

class AddTaskScreenArgs {
  final List<Task>? tasks;
  final Function(List<Task>?) onSubmit;
  AddTaskScreenArgs({
    this.tasks,
    required this.onSubmit,
  });
}

class AddTaskScreen extends StatefulWidget {
  static const routeName = 'add_task_screen';
  final List<Task>? tasks;
  final Function(List<Task>?) onSubmit;

  const AddTaskScreen({
    Key? key,
    this.tasks,
    required this.onSubmit,
  }) : super(key: key);

  static Route route({required AddTaskScreenArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => AddTaskScreen(
        tasks: args.tasks,
        onSubmit: args.onSubmit,
      ),
    );
  }

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  late TextEditingController _textEditingController;
  List<Task>? tasks;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    tasks = widget.tasks;
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Task',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {
              widget.onSubmit(tasks);
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
                tasks!.add(Task(
                  title: _textEditingController.text,
                  priority: 0,
                  dateTime: DateTime.now(),
                ));
                setState(() {});
                _textEditingController.clear();
              },
            ),
            _buildToDoTaskList(tasks, context),
          ],
        ),
      ),
    );
  }
}

_buildToDoTaskList(List<Task>? todoTask, BuildContext context) {
  return Expanded(
    child: todoTask!.isEmpty
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
