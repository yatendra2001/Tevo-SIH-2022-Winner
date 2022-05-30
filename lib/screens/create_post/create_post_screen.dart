import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:tevo/screens/comments/comments_screen.dart';
import 'package:tevo/screens/feed/feed_screen.dart';
import 'package:tevo/screens/profile/profile_screen.dart';
import 'package:tevo/utils/assets_constants.dart';
import 'package:tevo/utils/theme_constants.dart';
import 'package:tevo/widgets/widgets.dart';

import '../../blocs/blocs.dart';
import '../../repositories/repositories.dart';
import '../../models/models.dart';
import 'add_task_screen.dart';
import 'bloc/create_post_bloc.dart';

class CreatePostScreen extends StatefulWidget {
  static const String routeName = '/createPost';

  CreatePostScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CreatePostBloc, CreatePostState>(
        builder: (context, state) {
          final todoTask = state.todoTask;
          return DefaultTabController(
            length: 2,
            child: NestedScrollView(
              clipBehavior: Clip.none,
              headerSliverBuilder: (_, __) {
                return [
                  SliverAppBar(
                    floating: true,
                    snap: true,
                    automaticallyImplyLeading: false,
                    centerTitle: false,
                    pinned: true,
                    elevation: 1,
                    toolbarHeight: 70,
                    title: const Text(
                      "Today",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 38,
                      ),
                    ),
                    bottom:
                        const TabBar(indicatorColor: kPrimaryBlackColor, tabs: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Remaining",
                          style: TextStyle(
                            color: kPrimaryRedColor,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Completed",
                          style: TextStyle(
                            color: kPrimaryTealColor,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ]),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset(
                            kBaseProfileImagePath,
                            scale: 0.8,
                          ),
                        ),
                      )
                    ],
                  ),
                ];
              },
              body: TabBarView(
                children: [
                  AnimatedPadding(
                    duration: const Duration(seconds: 2),
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
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w500),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: kPrimaryTealColor),
                              onPressed: () {
                                // Navigator.of(context).pushNamed(
                                //   AddTaskScreen.routeName,
                                //   arguments: AddTaskScreenArgs(
                                //     onSubmit: (tasks) {
                                //       context
                                //           .read<CreatePostBloc>()
                                //           .add(AddTaskEvent(task: tasks!));
                                //       setState(() {});
                                //     },
                                //     tasks: todoTask,
                                //   ),
                                // );

                                _taskBottomSheet(state);
                              },
                              child: const Text('Add Task'),
                            )
                          ],
                        ),
                        SizedBox(height: 15),
                        todoTask.isEmpty
                            ? const Center(child: Text('Add Task Now'))
                            : state.todoTask.isEmpty
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(height: 10.h),
                                      Center(
                                        child: Image.asset(
                                          kEmptyTaskImagePath,
                                          scale: 3,
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        'Drop your 1st task 🎯',
                                        style: TextStyle(fontSize: 15.sp),
                                      ),
                                    ],
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (_, index) {
                                      return Dismissible(
                                        key: Key(todoTask[index]
                                            .timestamp
                                            .toString()),
                                        onDismissed: (_) {
                                          context.read<CreatePostBloc>().add(
                                              CompleteTaskEvent(
                                                  task: todoTask[index]));
                                        },
                                        child: TaskTile(
                                          isComplete: false,
                                          task: todoTask[index],
                                          isDeleted: () => context
                                              .read<CreatePostBloc>()
                                              .add(
                                                DeleteTaskEvent(
                                                  task: todoTask[index],
                                                ),
                                              ),
                                        ),
                                      );
                                    },
                                    itemCount: todoTask.length,
                                  ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          state.dateTime != null
                              ? _buildRemainingTime(state)
                              : const Text('No Tasks Yet'),
                          const SizedBox(height: 15),
                          const Text(
                            "Completed",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 15),
                          state.completedTask.isEmpty
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 10.h),
                                    Center(
                                      child: Image.asset(
                                        kEmptyCompleteImagePath,
                                        scale: 3,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      'Complete your 1st task 🚀',
                                      style: TextStyle(fontSize: 15.sp),
                                    ),
                                  ],
                                )
                              : ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (_, index) => TaskTile(
                                    task: state.completedTask[index],
                                    isComplete: true,
                                  ),
                                  itemCount: state.completedTask.length,
                                ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _taskBottomSheet(CreatePostState state) {
    final todoTask = state.todoTask;
    final _taskTextEditingController = TextEditingController();
    final _descriptionTextEditingController = TextEditingController();
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      context: context,
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Wrap(
          children: [
            Padding(
              padding: EdgeInsets.all(2.w),
              child: Center(
                  child: Text(
                "Add Task",
                style: TextStyle(fontSize: 18.sp),
              )),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: TextField(
                autofocus: true,
                controller: _taskTextEditingController,
                decoration: InputDecoration(
                    hintText: 'e.g., Read chapter 2 of Zero to One',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 16.5.sp),
                    border: InputBorder.none,
                    focusColor: Colors.grey),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: TextField(
                controller: _descriptionTextEditingController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Description\n\n\n',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 15.sp,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                  onPressed: () {
                    context.read<CreatePostBloc>().add(
                          AddTaskEvent(
                            task: todoTask
                              ..add(
                                Task(
                                    timestamp: Timestamp.now(),
                                    task: _taskTextEditingController.text,
                                    likes: 0),
                              ),
                          ),
                        );
                    _taskTextEditingController.clear();
                    Navigator.pop(context);
                  },
                  icon: CircleAvatar(
                    backgroundColor: kPrimaryTealColor,
                    child: Center(
                      child: Icon(
                        FontAwesomeIcons.arrowUp,
                        color: Colors.white,
                        size: 1.8.h,
                      ),
                    ),
                  )),
            )
          ],
        ),
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
            'Resets in ${time.hours} hrs ${time.min} min ${time.sec} sec',
          );
        },
      ),
    );
  }
}
