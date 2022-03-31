import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:tevo/screens/comments/comments_screen.dart';
import 'package:tevo/screens/create_post/add_task_screen.dart';

import '../profile/profile_screen.dart';
import 'bloc/create_post_bloc.dart';
import 'widgets/task_card.dart';

class CreatePostScreen extends StatefulWidget {
  static const String routeName = '/createPost';

  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreatePostBloc, CreatePostState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Create Post',
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: IconButton(
                  onPressed: () => context
                      .read<CreatePostBloc>()
                      .add(const DeletePostEvent()),
                  icon: const Icon(Icons.delete),
                ),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                state.dateTime != null
                    ? _buildRemainingTime(state)
                    : const Text('No Posts Yet'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('To Do Task'),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(AddTaskScreen.routeName);
                      },
                      child: const Text('Add Task'),
                    )
                  ],
                ),
                _buildToDoTask(state, context),
                const Text('Completed'),
                _buildCompletedTask(state),
                SizedBox(
                  height: 10,
                ),
                state.post != null
                    ? ElevatedButton(
                        onPressed: () => Navigator.of(context).pushNamed(
                            CommentsScreen.routeName,
                            arguments: CommentsScreenArgs(post: state.post!)),
                        child: Text("Comments"),
                      )
                    : SizedBox.shrink()
              ],
            ),
          ),
        );
      },
    );
  }
}

_buildCompletedTask(CreatePostState state) {
  final completedTask = state.completedTask;
  return Expanded(
    child: completedTask.isEmpty
        ? const Center(child: Text('Add Task Now'))
        : ListView.builder(
            itemBuilder: (_, index) => TaskCard(
              likes: completedTask[index].likes,
              task: completedTask[index],
              index: index + 1,
              isCompleted: true,
            ),
            itemCount: completedTask.length,
          ),
  );
}

_buildToDoTask(CreatePostState state, BuildContext context) {
  final todoTask = state.todoTask;
  return Expanded(
    child: todoTask.isEmpty
        ? const Center(
            child: Text('Add Task Now'),
          )
        : ListView.builder(
            itemBuilder: (_, index) {
              return Dismissible(
                key: Key(todoTask[index].timestamp.toString()),
                onDismissed: (_) {
                  context
                      .read<CreatePostBloc>()
                      .add(CompleteTaskEvent(task: todoTask[index]));
                },
                child: TaskCard(
                  isCompleted: false,
                  likes: todoTask[index].likes,
                  task: todoTask[index],
                  index: index + 1,
                  isDeleted: () => context.read<CreatePostBloc>().add(
                        DeleteTaskEvent(
                          task: todoTask[index],
                        ),
                      ),
                ),
              );
            },
            itemCount: todoTask.length,
          ),
  );
}

_buildRemainingTime(CreatePostState state) {
  int endTime = state.dateTime!.millisecondsSinceEpoch;
  return Center(
    child: CountdownTimer(
      endTime: endTime,
      widgetBuilder: (_, time) {
        if (time == null) {
          return const Text('Game over');
        }
        return Text(
          '${time.hours} hrs ${time.min} min ${time.sec} sec',
        );
      },
    ),
  );
}



  // void _selectPostImage(BuildContext context) async {
  //   final pickedFile = await ImageHelper.pickImageFromGallery(
  //     context: context,
  //     cropStyle: CropStyle.rectangle,
  //     title: 'Create Post',
  //   );
  //   if (pickedFile != null) {

  //   }
  // }

//   void _submitForm(BuildContext context, File? postImage, bool isSubmitting) {
//     if (_formKey.currentState!.validate() &&
//         postImage != null &&
//         !isSubmitting) {
//       context.read<CreatePostCubit>().submit();
//     }
//   }
// }
