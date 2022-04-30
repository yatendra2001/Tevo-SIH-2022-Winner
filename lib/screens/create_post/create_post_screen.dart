import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:tevo/screens/comments/comments_screen.dart';
import 'package:tevo/screens/create_post/add_task_screen.dart';
import 'package:tevo/utils/assets_constants.dart';
import 'package:tevo/utils/theme_constants.dart';

import 'bloc/create_post_bloc.dart';
import 'widgets/task_card.dart';

class CreatePostScreen extends StatefulWidget {
  static const String routeName = '/createPost';

  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       automaticallyImplyLeading: false,
  //       centerTitle: false,
  //       elevation: 1,
  //       toolbarHeight: 70,
  //       title: const Text(
  //         "Journal",
  //         style: TextStyle(
  //             color: Colors.black, fontWeight: FontWeight.w900, fontSize: 32),
  //       ),
  //       actions: [
  //         Padding(
  //           padding: const EdgeInsets.all(16.0),
  //           child: ClipRRect(
  //             borderRadius: BorderRadius.circular(30),
  //             child: Image.asset(kBaseProfileImagePath),
  //           ),
  //         )
  //       ],
  //     ),
  //     body: SafeArea(
  //       child: SingleChildScrollView(
  //         child: Padding(
  //           padding: const EdgeInsets.all(16.0),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               const Text(
  //                 "Habits",
  //                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
  //               ),
  //               const SizedBox(height: 24),
  //               SizedBox(
  //                 height: 39,
  //                 width: double.infinity,
  //                 child: ListView(
  //                   scrollDirection: Axis.horizontal,
  //                   shrinkWrap: true,
  //                   children: const [
  //                     CategoryContainerWidget(text: "Health", isSelected: true),
  //                     SizedBox(width: 10),
  //                     CategoryContainerWidget(
  //                         text: "Productivity", isSelected: false),
  //                     SizedBox(width: 10),
  //                     CategoryContainerWidget(
  //                         text: "Computers", isSelected: false),
  //                     SizedBox(width: 10),
  //                     CategoryContainerWidget(
  //                         text: "Social", isSelected: false),
  //                     SizedBox(width: 10),
  //                     CategoryContainerWidget(text: "Study", isSelected: false),
  //                   ],
  //                 ),
  //               ),
  //               const SizedBox(height: 24),
  //               Column(
  //                 children: const [
  //                   TaskTileWidget(
  //                       text: "Wake Up Early", color: kPrimaryRedColor),
  //                   SizedBox(height: 10),
  //                   TaskTileWidget(
  //                       text: "Make Time for Movement",
  //                       color: kPrimaryRedColor),
  //                   SizedBox(height: 10),
  //                   TaskTileWidget(
  //                       text: "Eat Sitting Down", color: kPrimaryRedColor),
  //                   SizedBox(height: 10),
  //                   TaskTileWidget(
  //                       text: "Take Time to Cook",
  //                       color: kSecondaryYellowColor),
  //                   SizedBox(height: 10),
  //                   TaskTileWidget(
  //                       text: "Go to Bed Early", color: kSecondaryBlueColor),
  //                 ],
  //               ),
  //               const SizedBox(height: 24),
  //               const Text(
  //                 "Tasks",
  //                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
  //               ),
  //               const SizedBox(height: 24),
  //               Column(
  //                 children: const [
  //                   TaskTileWidget(
  //                       text: "5 Questions on Binary Search",
  //                       color: kPrimaryRedColor),
  //                   SizedBox(height: 10),
  //                   TaskTileWidget(
  //                       text: "Deploy web app on firebase",
  //                       color: kPrimaryRedColor),
  //                   SizedBox(height: 10),
  //                   TaskTileWidget(
  //                       text: "Complete Java Report",
  //                       color: kSecondaryBlueColor),
  //                   SizedBox(height: 10),
  //                   TaskTileWidget(
  //                       text: "Complete Spanish Assignment",
  //                       color: kSecondaryYellowColor),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePostBloc, CreatePostState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: false,
            elevation: 1,
            toolbarHeight: 70,
            title: const Text(
              "Journal",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 32),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(kBaseProfileImagePath),
                ),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                state.dateTime != null
                    ? _buildRemainingTime(state)
                    : const Text('No Posts Yet'),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Tasks",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                    ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: kPrimaryTealColor),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(AddTaskScreen.routeName);
                      },
                      child: const Text('Add Task'),
                    )
                  ],
                ),
                SizedBox(height: 15),
                Expanded(
                  child: state.todoTask.isEmpty
                      ? const Center(
                          child: Text('Add Task Now'),
                        )
                      : ListView.builder(
                          itemBuilder: (_, index) {
                            return Dismissible(
                              key: Key(
                                  state.todoTask[index].timestamp.toString()),
                              onDismissed: (_) {
                                context.read<CreatePostBloc>().add(
                                    CompleteTaskEvent(
                                        task: state.todoTask[index]));
                              },
                              child: TaskCard(
                                isCompleted: false,
                                likes: state.todoTask[index].likes,
                                task: state.todoTask[index],
                                index: index + 1,
                                isDeleted: () =>
                                    context.read<CreatePostBloc>().add(
                                          DeleteTaskEvent(
                                            task: state.todoTask[index],
                                          ),
                                        ),
                              ),
                            );
                          },
                          itemCount: state.todoTask.length,
                        ),
                ),
                const Text(
                  "Completed",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 15),
                Expanded(
                  child: state.completedTask.isEmpty
                      ? const Center(child: Text('Completed Tasks'))
                      : ListView.builder(
                          itemBuilder: (_, index) => TaskCard(
                            likes: state.completedTask[index].likes,
                            task: state.completedTask[index],
                            index: index + 1,
                            isCompleted: true,
                          ),
                          itemCount: state.completedTask.length,
                        ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // state.post != null
                //     ? ElevatedButton(
                //         onPressed: () => Navigator.of(context).pushNamed(
                //             CommentsScreen.routeName,
                //             arguments: CommentsScreenArgs(post: state.post!)),
                //         child: Text("Comments"),
                //       )
                //     : SizedBox.shrink()
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
        ? const Center(child: Text('Completed Tasks'))
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

// class TaskTileWidget extends StatelessWidget {
//   final String? text;
//   final Color? color;
//   const TaskTileWidget({
//     required this.text,
//     required this.color,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 53,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color: color!.withOpacity(0.2),
//       ),
//       child: Align(
//         alignment: Alignment.centerLeft,
//         child: Padding(
//           padding: const EdgeInsets.only(left: 18.0),
//           child: Text(text!),
//         ),
//       ),
//     );
//   }
// }

// class CategoryContainerWidget extends StatelessWidget {
//   final String? text;
//   final bool? isSelected;
//   const CategoryContainerWidget({
//     required this.text,
//     required this.isSelected,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 39,
//       decoration: BoxDecoration(
//           border: isSelected!
//               ? const Border()
//               : const Border(
//                   top: BorderSide(color: Color(0xffE6E6E6)),
//                   bottom: BorderSide(color: Color(0xffE6E6E6)),
//                   left: BorderSide(color: Color(0xffE6E6E6)),
//                   right: BorderSide(color: Color(0xffE6E6E6))),
//           borderRadius: BorderRadius.circular(12),
//           color: isSelected! ? kPrimaryTealColor : Colors.white),
//       child: Center(
//           child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 18.0),
//         child: Text(
//           text!,
//           style: TextStyle(color: isSelected! ? Colors.white : Colors.black),
//         ),
//       )),
//     );
//   }
// }

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
          'Resets in ${time.hours} hrs ${time.min} min ${time.sec} sec',
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
