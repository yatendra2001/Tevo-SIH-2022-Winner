import 'package:flutter/material.dart';

import 'package:tevo/models/task_model.dart';

class TaskTile extends StatefulWidget {
  final int index;
  final Task task;
  final bool isComplete;
  const TaskTile({
    Key? key,
    required this.index,
    required this.task,
    required this.isComplete,
  }) : super(key: key);

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  int likes = 0;
  bool isLikesd = false;

  @override
  void initState() {
    likes = widget.task.likes;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 290,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: widget.isComplete ? Colors.green[300] : Colors.red[300]),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Text(widget.index.toString()),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.task.task),
                      // Text(DateFormat().add_jm().format(task.timestamp.toDate())),
                    ],
                  ),
                ],
              ),
            ),
          ),
          widget.isComplete
              ? Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isLikesd ? likes-- : likes++;
                          isLikesd = !isLikesd;
                        });
                      },
                      child: Icon(
                        isLikesd ? Icons.favorite : Icons.favorite_outline,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      likes.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                )
              : const Icon(
                  Icons.favorite_border_outlined,
                  color: Colors.grey,
                )
        ],
      ),
    );
  }
}
