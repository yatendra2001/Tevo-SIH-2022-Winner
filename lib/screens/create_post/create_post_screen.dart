import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:tevo/screens/comments/comments_screen.dart';
import 'package:tevo/screens/feed/feed_screen.dart';
import 'package:tevo/screens/profile/profile_screen.dart';
import 'package:tevo/utils/assets_constants.dart';
import 'package:tevo/utils/session_helper.dart';
import 'package:tevo/utils/theme_constants.dart';
import 'package:tevo/widgets/widgets.dart';

import '../../models/models.dart';
import 'add_task_screen.dart';
import 'bloc/create_post_bloc.dart';

class CreatePostScreen extends StatefulWidget {
  static const String routeName = '/createPost';

  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _controller = ScrollController();
  AnimationController? bottomModalSheetController;

  @override
  void initState() {
    super.initState();
    bottomModalSheetController = BottomSheet.createAnimationController(this);
    bottomModalSheetController!.duration = const Duration(milliseconds: 300);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CreatePostBloc, CreatePostState>(
        builder: (context, state) {
          final todoTask = state.todoTask;
          return DefaultTabController(
            length: 2,
            child: NestedScrollView(
              controller: _controller,
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
                    toolbarHeight: 80,
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
                      Tab(
                        child: Text(
                          "Remaining",
                          style: TextStyle(
                            color: kPrimaryRedColor,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "Completed",
                          style: TextStyle(
                            color: kPrimaryRedColor,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ]),
                    actions: [
                      GestureDetector(
                        onTap: (() {
                          Navigator.pushNamed(context, ProfileScreen.routeName,
                              arguments: ProfileScreenArgs(
                                  userId: SessionHelper.uid!));
                        }),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.asset(
                              kBaseProfileImagePath,
                              scale: 0.8,
                            ),
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
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        state.dateTime != null
                            ? _buildRemainingTime(state)
                            : const Text('No Posts Yet'),
                        SizedBox(height: 16),
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
                                _taskBottomSheet((task) {
                                  context
                                      .read<CreatePostBloc>()
                                      .add(AddTaskEvent(task: task));
                                  setState(() {});
                                });
                                _scrollDown();
                              },
                              child: const Text('Add Task'),
                            )
                          ],
                        ),
                        SizedBox(height: 16),
                        state.todoTask.isEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                            : Expanded(
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (_, index) {
                                    return Dismissible(
                                      key: Key(
                                          todoTask[index].dateTime.toString()),
                                      onDismissed: (_) {
                                        context.read<CreatePostBloc>().add(
                                            CompleteTaskEvent(
                                                task: todoTask[index]));
                                      },
                                      child: TaskTile(
                                        isComplete: false,
                                        task: todoTask[index],
                                        isDeleted: () =>
                                            context.read<CreatePostBloc>().add(
                                                  DeleteTaskEvent(
                                                    task: state.todoTask[index],
                                                  ),
                                                ),
                                      ),
                                    );
                                  },
                                  itemCount: todoTask.length,
                                ),
                              ),
                      ],
                    ),
                  ),
                  Padding(
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _scrollDown() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  void _taskBottomSheet(Function(Task) onSubmit) {
    final _taskTextEditingController = TextEditingController();
    final _descriptionTextEditingController = TextEditingController();

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      transitionAnimationController: bottomModalSheetController,
      context: context,
      builder: (context) => Container(
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 10,
            right: 10),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
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
                    onSubmit(
                      Task(
                        title: _taskTextEditingController.text,
                        priority: 0,
                        dateTime: DateTime.now(),
                        description: _descriptionTextEditingController.text,
                      ),
                    );
                    _taskTextEditingController.clear();
                    _descriptionTextEditingController.clear();
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
    return Center(
      child: CountdownTimer(
        endTime: state.dateTime!.millisecondsSinceEpoch,
        onEnd: () {
          context.read<CreatePostBloc>().add(ClearPost());
          _buildDialog();
        },
        widgetBuilder: (_, time) {
          if (time == null) {
            return const Text('Time Up');
          }
          return Text(
            'Resets in ${time.hours} hrs ${time.min} min ${time.sec} sec',
          );
        },
      ),
    );
  }

  _buildDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Your Time is Up',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        );
      },
    );
  }
}
