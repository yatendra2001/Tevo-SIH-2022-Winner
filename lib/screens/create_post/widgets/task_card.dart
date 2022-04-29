import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:tevo/models/models.dart';
import 'package:tevo/utils/theme_constants.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final int index;
  final bool isCompleted;
  final int likes;
  final Function()? isDeleted;
  const TaskCard({
    Key? key,
    required this.task,
    required this.index,
    required this.isCompleted,
    required this.likes,
    this.isDeleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 0,
      color: isCompleted
          ? kSecondaryBlueColor.withOpacity(0.2)
          : kPrimaryRedColor.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Text(task.task),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    !isCompleted
                        ? IconButton(
                            icon: Icon(Icons.delete_outline_rounded),
                            onPressed: isDeleted,
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ],
            ),
            isCompleted
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.favorite_outline),
                      Text(likes.toString()),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
