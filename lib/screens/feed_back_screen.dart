import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';
import 'package:tevo/repositories/post/post_repository.dart';
import 'package:tevo/utils/session_helper.dart';

import 'package:tevo/utils/theme_constants.dart';
import 'package:tevo/widgets/flutter_toast.dart';

class FeedBackArgs {
  final String postId;
  final bool currentUser;
  FeedBackArgs({
    required this.postId,
    required this.currentUser,
  });
}

class FeedBackScreen extends StatefulWidget {
  final String postId;
  final bool currentUser;

  const FeedBackScreen({
    Key? key,
    required this.postId,
    required this.currentUser,
  }) : super(key: key);
  static const routeName = 'feedbackScreen';

  static Route route({required FeedBackArgs args}) {
    return PageTransition(
      settings: const RouteSettings(name: routeName),
      type: PageTransitionType.bottomToTop,
      child: FeedBackScreen(
        postId: args.postId,
        currentUser: args.currentUser,
      ),
    );
  }

  @override
  State<FeedBackScreen> createState() => _FeedBackScreenState();
}

class _FeedBackScreenState extends State<FeedBackScreen> {
  final TextEditingController feedBackController = TextEditingController();

  @override
  void initState() {
    getfeedback();
    super.initState();
  }

  getfeedback() async {
    feedBackController.text = await context
        .read<PostRepository>()
        .getPostFeedback(postId: widget.postId, userId: SessionHelper.uid!);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: CircleAvatar(
                        radius: 16,
                        child: Icon(
                          Icons.close_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                        backgroundColor: kPrimaryBlackColor.withOpacity(0.6),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Text(
                      "Feedback",
                      style: TextStyle(fontSize: 20.sp),
                    ),
                    Spacer(),
                    widget.currentUser
                        ? GestureDetector(
                            child: Icon(Icons.send),
                            onTap: () async {
                              if (feedBackController.text.isEmpty) {
                                flutterToast(msg: "Feedback cannot be empty");
                              } else {
                                context
                                    .read<PostRepository>()
                                    .createPostFeedback(
                                      postId: widget.postId,
                                      text: feedBackController.text,
                                      userId: SessionHelper.uid!,
                                    );
                                Navigator.of(context).pop();
                              }
                            },
                          )
                        : SizedBox.shrink()
                  ],
                ),
                Divider(thickness: 2),
                TextField(
                  controller: feedBackController,
                  minLines: 3,
                  maxLines: 20,
                  readOnly: widget.currentUser == false,
                  decoration: InputDecoration(
                      border: widget.currentUser == false
                          ? InputBorder.none
                          : UnderlineInputBorder(
                              borderSide: BorderSide(color: kPrimaryBlackColor),
                            ),
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: kPrimaryBlackColor.withOpacity(0.2),
                      ),
                      enabledBorder: widget.currentUser == false
                          ? InputBorder.none
                          : UnderlineInputBorder(
                              borderSide: BorderSide(color: kPrimaryBlackColor),
                            ),
                      focusedBorder: widget.currentUser == false
                          ? InputBorder.none
                          : UnderlineInputBorder(
                              borderSide: BorderSide(color: kPrimaryBlackColor),
                            ),
                      hintText: widget.currentUser == false
                          ? "No Feedback Yet !"
                          : "What do you feel about the task today"),
                ),
                Spacer(),
                widget.currentUser
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildCard("It went well"),
                            _buildCard("Productive"),
                            _buildCard("Feel lazy to work..."),
                            _buildCard("Tired"),
                            _buildCard("Was engaged with some work"),
                            _buildCard("Will complete it tomorrow"),
                          ],
                        ),
                      )
                    : SizedBox.shrink()
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildCard(String text) {
    return GestureDetector(
      onTap: () {
        feedBackController.text = text;
      },
      child: Container(
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: kPrimaryBlackColor),
          color: Colors.grey[200],
        ),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Text(
          text,
          style: TextStyle(fontSize: 10.sp),
        ),
      ),
    );
  }
}
