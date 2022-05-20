import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tevo/models/task_model.dart';
import 'package:tevo/utils/theme_constants.dart';

class TaskTile extends StatefulWidget {
  final Task task;
  final bool isComplete;
  final Function()? isDeleted;

  const TaskTile({
    Key? key,
    required this.task,
    required this.isComplete,
    this.isDeleted,
  }) : super(key: key);

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 53,
        width: 347.4,
        child: Text(
          widget.task.task,
          style: const TextStyle(fontSize: 16),
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: widget.isComplete
                ? Color(0xff009688).withOpacity(0.3)
                : Color(0xffE01A4F).withOpacity(0.3)),
      ),
    );
  }
}
