import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/linearicons_free_icons.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';

import 'package:tevo/models/task_model.dart';
import 'package:tevo/utils/theme_constants.dart';
import 'package:tevo/widgets/widgets.dart';

enum TaskTileView { profileView, feedScreen, createScreenView }

class TaskTile extends StatefulWidget {
  final Task task;
  final int index;
  final bool isComplete;
  final Function(bool) onRepeat;
  final TaskTileView view;
  final Function() isDeleted;
  final Function() isEditing;

  const TaskTile({
    Key? key,
    required this.task,
    required this.index,
    required this.isComplete,
    required this.view,
    required this.onRepeat,
    required this.isDeleted,
    required this.isEditing,
  }) : super(key: key);

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  bool showDesc = false;
  late bool taskRepeat;

  @override
  void initState() {
    taskRepeat = widget.task.repeat;
    super.initState();
  }

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
                Expanded(
                  child: Text(
                    widget.task.title,
                    style: TextStyle(
                        fontSize: 10.sp,
                        fontFamily: kFontFamily,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                (widget.view == TaskTileView.createScreenView)
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            padding: const EdgeInsets.all(0),
                            icon: taskRepeat
                                ? Icon(Icons.repeat_on_rounded)
                                : Icon(Icons.repeat_rounded),
                            onPressed: () {
                              setState(() {
                                taskRepeat = !taskRepeat;
                              });
                              widget.onRepeat(taskRepeat);
                              flutterToast(
                                  msg: taskRepeat
                                      ? "Task updated to recurring"
                                      : "Task updated to non-recurring");
                            },
                          ),
                          if (widget.isComplete == false)
                            IconButton(
                              padding: const EdgeInsets.all(0),
                              icon: const Icon(Icons.edit),
                              onPressed: widget.isEditing,
                            ),
                          IconButton(
                            padding: const EdgeInsets.all(0),
                            icon: const Icon(Icons.delete),
                            onPressed: widget.isDeleted,
                          ),
                        ],
                      )
                    : widget.isComplete
                        ? const Icon(LineariconsFree.checkmark_cicle,
                            color: kPrimaryBlackColor)
                        : const Icon(Entypo.hourglass,
                            color: kPrimaryBlackColor),
              ],
            ),
            if (showDesc) const SizedBox(height: 8),
            showDesc
                ? Text(
                    widget.task.description!,
                    style: TextStyle(
                        color: kPrimaryBlackColor.withOpacity(0.8),
                        fontFamily: kFontFamily,
                        fontWeight: FontWeight.w300),
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
