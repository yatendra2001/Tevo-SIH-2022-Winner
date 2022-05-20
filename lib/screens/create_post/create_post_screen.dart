import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:tevo/screens/comments/comments_screen.dart';
import 'package:tevo/screens/create_post/add_task_screen.dart';
import 'package:tevo/utils/assets_constants.dart';
import 'package:tevo/utils/theme_constants.dart';
import 'package:tevo/widgets/widgets.dart';

import 'bloc/create_post_bloc.dart';

class CreatePostScreen extends StatefulWidget {
  static const String routeName = '/createPost';

  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePostBloc, CreatePostState>(
      builder: (context, state) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              bottom: const TabBar(indicatorColor: kPrimaryBlackColor, tabs: [
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
            body: TabBarView(
              children: [
                SingleChildScrollView(
                  child: AnimatedPadding(
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
                                Navigator.of(context)
                                    .pushNamed(AddTaskScreen.routeName);
                              },
                              child: const Text('Add Task'),
                            )
                          ],
                        ),
                        SizedBox(height: 15),
                        state.todoTask.isEmpty
                            ? const Center(
                                child: Text('Add Task Now'),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (_, index) {
                                  return Dismissible(
                                    key: Key(state.todoTask[index].timestamp
                                        .toString()),
                                    onDismissed: (_) {
                                      context.read<CreatePostBloc>().add(
                                          CompleteTaskEvent(
                                              task: state.todoTask[index]));
                                    },
                                    child: TaskTile(
                                      isComplete: false,
                                      task: state.todoTask[index],
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
                      ],
                    ),
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
                            ? const Center(child: Text('Completed Tasks'))
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
    );
  }
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
