import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tevo/models/task_model.dart';
import 'package:tevo/screens/create_post/bloc/create_post_bloc.dart';
import 'package:tevo/utils/theme_constants.dart';

class AnimatedTaskTile extends StatefulWidget {
  final Task task;
  final bool isComplete;
  final Function()? isDeleted;

  const AnimatedTaskTile({
    Key? key,
    required this.task,
    required this.isComplete,
    this.isDeleted,
  }) : super(key: key);

  @override
  State<AnimatedTaskTile> createState() => _AnimatedTaskTileState();
}

class _AnimatedTaskTileState extends State<AnimatedTaskTile> {
  bool isCompleted = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        height: 53,
        width: 347.4,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.task.task,
              style: const TextStyle(fontSize: 16),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    context
                        .read<CreatePostBloc>()
                        .add(CompleteTaskEvent(task: widget.task));

                    setState(() {
                      isCompleted = true;
                    });
                  },
                  child: const Icon(
                    Icons.fork_right,
                    size: 18,
                    color: kPrimaryTealColor,
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                    onTap: () {
                      context.read<CreatePostBloc>().add(
                            DeleteTaskEvent(
                              task: widget.task,
                            ),
                          );
                    },
                    child: const Icon(
                      Icons.remove,
                      size: 18,
                      color: kPrimaryRedColor,
                    )),
              ],
            ),
          ],
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: isCompleted
                ? Border.all(color: kPrimaryTealColor.withOpacity(0.5))
                : Border.all(color: kPrimaryRedColor.withOpacity(0.5)),
            color: isCompleted ? kPrimaryTealColor.withOpacity(0.3) : null),
      ),
    );
  }
}
