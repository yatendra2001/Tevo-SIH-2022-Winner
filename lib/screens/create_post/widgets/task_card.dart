import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tevo/models/models.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final int index;
  final bool isCompleted;
  final Function()? isDeleted;

  const TaskCard(
      {Key? key,
      required this.task,
      required this.index,
      this.isCompleted = false,
      this.isDeleted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
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
                    Text(index.toString()),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(task.task),
                  ],
                ),
                Row(
                  children: [
                    Text(DateFormat('HH:mm').format(task.timestamp.toDate())),
                    SizedBox(
                      width: 10,
                    ),
                    !isCompleted
                        ? IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: isDeleted,
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            isCompleted
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Icon(Icons.favorite),
                      Text('24'),
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
