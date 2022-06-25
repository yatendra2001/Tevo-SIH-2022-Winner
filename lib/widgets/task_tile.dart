import 'package:flutter/material.dart';

import 'package:tevo/models/task_model.dart';
import 'package:tevo/utils/theme_constants.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.task.title,
                  style: const TextStyle(fontSize: 16),
                ),
                (widget.view == TaskTileView.createScreenView &&
                        !widget.isComplete)
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
                    : widget.isComplete
                        ? Icon(Icons.check_circle, color: kPrimaryBlackColor)
                        : Icon(Icons.punch_clock, color: kPrimaryBlackColor),
              ],
            ),
            if (showDesc) SizedBox(height: 8),
            showDesc
                ? Text(
                    widget.task.description!,
                    style: TextStyle(color: Colors.black),
                  )
                : SizedBox.shrink(),
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: kPrimaryBlackColor),
          color: kPrimaryWhiteColor,
          // ? Color(0xff009688).withOpacity(0.3)
          // : Color(0xffE01A4F).withOpacity(0.3),
        ),
      ),
    );
  }
}
