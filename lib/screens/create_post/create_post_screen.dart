import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:tevo/screens/create_post/add_task_screen.dart';

import 'bloc/create_post_bloc.dart';
import 'widgets/task_card.dart';

class CreatePostScreen extends StatelessWidget {
  static const String routeName = '/createPost';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  CreatePostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Post',
          style: TextStyle(color: Colors.black),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Icon(Icons.refresh),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: BlocConsumer<CreatePostBloc, CreatePostState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRemainingTime(),
                const Text('Completed'),
                _buildCompletedTask(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('To Do Task'),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(AddTaskScreen.routeName);
                        },
                        child: const Text('Add Task'))
                  ],
                ),
                _buildToDoTask(state),
              ],
            );
          },
        ),
      ),
    );
  }

  _buildCompletedTask() {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Card(
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
                        children: const [
                          Text('1'),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Task 1'),
                        ],
                      ),
                      const Text('12:30 A.M'),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Icon(Icons.favorite),
                      SizedBox(
                        width: 10,
                      ),
                      Text('24'),
                    ],
                  )
                ],
              ),
            ),
          ),
          Card(
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
                        children: const [
                          Text('1'),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Task 1'),
                        ],
                      ),
                      const Text('12:30 A.M'),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Icon(Icons.favorite),
                      SizedBox(
                        width: 10,
                      ),
                      Text('24'),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _buildToDoTask(CreatePostState state) {
    return Expanded(
      child: state.todoTask.isEmpty
          ? const Center(child: Text('Add Task Now'))
          : ListView.builder(
              itemBuilder: (_, index) =>
                  TaskCard(task: state.todoTask[index], index: index + 1),
              itemCount: state.todoTask.length,
            ),
    );
  }

  _buildRemainingTime() {
    int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 9000;
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
