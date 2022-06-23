import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:tevo/screens/profile/profile_screen.dart';
import 'package:tevo/utils/assets_constants.dart';
import 'package:tevo/utils/session_helper.dart';
import 'package:tevo/utils/theme_constants.dart';
import 'package:tevo/widgets/widgets.dart';
import '../../models/models.dart';
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
  final _taskTextEditingController = TextEditingController();
  final _descriptionTextEditingController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    bottomModalSheetController = BottomSheet.createAnimationController(this);
    bottomModalSheetController!.duration = const Duration(milliseconds: 300);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePostBloc, CreatePostState>(
      builder: (context, state) {
        return Scaffold(
          body: DefaultTabController(
            length: 2,
            child: NestedScrollView(
              controller: _controller,
              clipBehavior: Clip.none,
              headerSliverBuilder: (_, __) {
                return [_buildAppBar()];
              },
              body: TabBarView(
                children: [
                  _buildRemaining(state),
                  _buildCompleted(state),
                ],
              ),
            ),
          ),
          floatingActionButton: state.post != null
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 70.0),
                  child: FloatingActionButton(
                      backgroundColor: Colors.black,
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text(
                                  'Delete Post',
                                  style: TextStyle(color: Colors.black),
                                ),
                                actions: [
                                  OutlinedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancel')),
                                  OutlinedButton(
                                      onPressed: () {
                                        _buildDeletePost();
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Yes'))
                                ],
                              );
                            });
                      },
                      child: Icon(Icons.delete_outline_sharp)),
                )
              : null,
        );
      },
    );
  }

  _buildDeletePost() {
    context.read<CreatePostBloc>().add(const DeletePostEvent());
  }

  _buildRemaining(CreatePostState state) {
    final todoTask = state.todoTask;
    return state.status == CreatePostStateStatus.loading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : AnimatedPadding(
            duration: const Duration(seconds: 2),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                state.dateTime != null
                    ? _buildRemainingTime(state)
                    : const Text('No Posts Yet'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // NeumorphicText(
                    //   "Tasks",
                    //   textStyle: NeumorphicTextStyle(fontSize: 18.sp),
                    // ),
                    const Text(
                      "Tasks",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                    // NeumorphicButton(
                    //   onPressed: () {
                    //     _taskBottomSheet(onSubmit: (task) {
                    //       context
                    //           .read<CreatePostBloc>()
                    //           .add(AddTaskEvent(task: task));
                    //     });
                    //     _scrollDown();
                    //   },
                    //   style: NeumorphicStyle(
                    //     border: NeumorphicBorder(
                    //       color: kPrimaryBlackColor,
                    //       width: 0.8,
                    //     ),
                    //     depth: 8,
                    //     lightSource: LightSource.top,
                    //     color: Colors.white,
                    //     shape: NeumorphicShape.flat,
                    //     boxShape: NeumorphicBoxShape.roundRect(
                    //         BorderRadius.circular(5)),
                    //   ),
                    //   padding: EdgeInsets.symmetric(
                    //       vertical: 1.5.h, horizontal: 4.w),
                    //   child: const Text('Add Task'
                    //       // style: TextStyle(color: Colors.white),
                    //       ),
                    // ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: kPrimaryWhiteColor,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(color: kPrimaryBlackColor),
                              borderRadius: BorderRadius.circular(5))),
                      onPressed: () {
                        _taskBottomSheet(onSubmit: (task) {
                          context
                              .read<CreatePostBloc>()
                              .add(AddTaskEvent(task: task));
                        });
                        _scrollDown();
                      },
                      child: const Text(
                        'Add Task',
                        style: TextStyle(color: kPrimaryBlackColor),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16),
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
                            state.dateTime == null
                                ? 'Drop your 1st task 🎯'
                                : 'Winning 🎉',
                            style: TextStyle(fontSize: 15.sp),
                          ),
                        ],
                      )
                    : Expanded(
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (_, index) {
                            return Dismissible(
                              key: Key(todoTask[index].dateTime.toString()),
                              onDismissed: (_) {
                                context.read<CreatePostBloc>().add(
                                    CompleteTaskEvent(task: todoTask[index]));
                              },
                              child: TaskTile(
                                isComplete: false,
                                view: TaskTileView.createScreenView,
                                isEditing: () {
                                  _taskBottomSheet(
                                    onSubmit: (task) {
                                      context.read<CreatePostBloc>().add(
                                          UpdateTask(task: task, index: index));
                                    },
                                    task: todoTask[index],
                                  );
                                },
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
          );
  }

  _buildCompleted(CreatePostState state) {
    return state.status == CreatePostStateStatus.loading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                state.post != null
                    ? _buildRemainingTime(state)
                    : const Text('No Tasks Yet'),
                const Text(
                  "Completed",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
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
                          view: TaskTileView.createScreenView,
                          isEditing: () {},
                          task: state.completedTask[index],
                          isComplete: true,
                          isDeleted: () => context.read<CreatePostBloc>().add(
                              DeleteTaskEvent(
                                  task: state.completedTask[index])),
                        ),
                        itemCount: state.completedTask.length,
                      ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
  }

  _buildAppBar() {
    return SliverAppBar(
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
      bottom: const TabBar(indicatorColor: kPrimaryBlackColor, tabs: [
        Tab(
          child: Text(
            "Remaining",
            style: TextStyle(
              color: kPrimaryBlackColor,
              fontSize: 18,
            ),
          ),
        ),
        Tab(
          child: Text(
            "Completed",
            style: TextStyle(
              color: kPrimaryBlackColor,
              fontSize: 18,
            ),
          ),
        ),
      ]),
      actions: [
        GestureDetector(
          onTap: (() {
            Navigator.pushNamed(context, ProfileScreen.routeName,
                arguments: ProfileScreenArgs(userId: SessionHelper.uid!));
          }),
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: UserProfileImage(
                radius: 30,
                profileImageUrl: SessionHelper.profileImageUrl!,
              )),
        )
      ],
    );
  }

  void _scrollDown() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  void _taskBottomSheet({required Function(Task) onSubmit, Task? task}) {
    if (task != null) {
      _taskTextEditingController.text = task.title;
      _descriptionTextEditingController.text = task.description ?? "";
    }
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
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: Wrap(
          children: [
            Padding(
              padding: EdgeInsets.all(2.w),
              child: const Center(
                  child: Text(
                "Add Task",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              )),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: TextField(
                autofocus: true,
                controller: _taskTextEditingController,
                decoration: const InputDecoration(
                  hintText: 'Read Chapter of "Zero to One"',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                  border: InputBorder.none,
                  focusColor: Colors.grey,
                ),
                textInputAction: TextInputAction.next,
                onSubmitted: (_) {
                  _focusNode.requestFocus();
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: TextField(
                controller: _descriptionTextEditingController,
                keyboardType: TextInputType.multiline,
                focusNode: _focusNode,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Description\n\n\n',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) {
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
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildRemainingTime(CreatePostState state) {
    final endTime = state.dateTime?.millisecondsSinceEpoch;
    return Center(
      child: CountdownTimer(
        endTime: endTime,
        onEnd: () {
          _buildDialog();
        },
        widgetBuilder: (_, time) {
          if (time == null) {
            return const Text('Time Up');
          }
          return TimerCountdown(
              format: CountDownTimerFormat.hoursMinutesSeconds,
              timeTextStyle: const TextStyle(
                color: Colors.teal,
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
              colonsTextStyle: const TextStyle(
                color: Colors.teal,
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
              descriptionTextStyle: const TextStyle(
                color: Colors.red,
                fontSize: 10,
              ),
              spacerWidth: 20,
              endTime: DateTime.now().add(
                Duration(
                  hours: time.hours ?? 0,
                  minutes: time.min ?? 0,
                  seconds: time.sec ?? 0,
                ),
              ));
        },
      ),
    );
  }

  _buildDialog() {
    context.read<CreatePostBloc>().add(const ClearPost());
    return showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
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
