import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';

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
                Expanded(
                  child: Text(
                    widget.task.title,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontFamily: kFontFamily,
                    ),
                  ),
                ),
                (widget.view == TaskTileView.createScreenView)
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.isComplete == false)
                            IconButton(
                              padding: EdgeInsets.all(0),
                              icon: Icon(Icons.repeat),
                              onPressed: () {},
                            ),
                          if (widget.isComplete == false)
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
                        ? Icon(FontAwesome5.check_circle,
                            color: kPrimaryBlackColor)
                        : Icon(FontAwesomeIcons.clock,
                            color: kPrimaryBlackColor),
              ],
            ),
            if (showDesc) SizedBox(height: 8),
            showDesc
                ? Text(
                    widget.task.description!,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: kFontFamily,
                    ),
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
