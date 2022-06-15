import 'package:flutter/material.dart';

import 'package:tevo/models/task_model.dart';

enum TaskTileView { profileView, feedScreen, createScreenView }

class TaskTile extends StatefulWidget {
  final Task task;
  final bool isComplete;
  final TaskTileView view;
  final Function() isDeleted;
  final Function() isEditing;

  const TaskTile({
    Key? key,
    required this.task,
    required this.isComplete,
    required this.view,
    required this.isDeleted,
    required this.isEditing,
  }) : super(key: key);

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  bool showDesc = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          if (widget.task.description != "") {
            showDesc = !showDesc;
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.task.title,
                  style: const TextStyle(fontSize: 16),
                ),
                (widget.view == TaskTileView.createScreenView)
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            padding: EdgeInsets.all(0),
                            icon: Icon(Icons.repeat),
                            onPressed: () {},
                          ),
                          IconButton(
                            padding: EdgeInsets.all(0),
                            icon: Icon(Icons.edit),
                            onPressed: widget.isEditing,
                          ),
                          IconButton(
                            padding: EdgeInsets.all(0),
                            icon: Icon(Icons.delete),
                            onPressed: widget.isDeleted,
                          ),
                        ],
                      )
                    : SizedBox.shrink()
              ],
            ),
            showDesc
                ? Text(
                    widget.task.description!,
                    style: TextStyle(color: Colors.black),
                  )
                : SizedBox.shrink(),
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: widget.isComplete
              ? Color(0xff009688).withOpacity(0.3)
              : Color(0xffE01A4F).withOpacity(0.3),
        ),
      ),
    );
  }
}
