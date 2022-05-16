import 'package:flutter/material.dart';
import 'package:tevo/models/task_model.dart';

class TaskTile extends StatefulWidget {
  final Task task;
  final bool isComplete;

  const TaskTile({
    Key? key,
    required this.task,
    required this.isComplete,
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
                ? Color(0xffFFE74C).withOpacity(0.3)
                : Color(0xffE01A4F).withOpacity(0.3)),
      ),
    );
  }
}
