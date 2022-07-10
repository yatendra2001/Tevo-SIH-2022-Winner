import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:tevo/extensions/extensions.dart';
import 'package:tevo/models/models.dart';
import 'package:tevo/repositories/post/post_repository.dart';
import 'package:tevo/repositories/user/user_repository.dart';
import 'package:tevo/screens/comments/bloc/comments_bloc.dart';
import 'package:tevo/screens/report/report_screen.dart';
import 'package:tevo/screens/screens.dart';
import 'package:tevo/utils/session_helper.dart';
import 'package:tevo/utils/theme_constants.dart';
import 'package:tevo/widgets/widgets.dart';
import 'package:timeago/timeago.dart';

import '../screens/stream_chat/models/chat_type.dart';

class PostView extends StatefulWidget {
  final Post post;
  final Function()? onPressed;
  final bool isLiked;
  final VoidCallback onLike;
  final bool recentlyLiked;

  const PostView({
    Key? key,
    required this.post,
    this.onPressed,
    required this.isLiked,
    required this.onLike,
    this.recentlyLiked = false,
  }) : super(key: key);

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  List<Task>? tasks;
  final _commentTextController = TextEditingController();

  @override
  void initState() {
    tasks = List.from(widget.post.completedTask);
    tasks!.addAll(List.from(widget.post.toDoTask));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      color: kPrimaryWhiteColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: kPrimaryBlackColor)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(ProfileScreen.routeName,
                    arguments:
                        ProfileScreenArgs(userId: widget.post.author.id));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (widget.post.author.id != SessionHelper.uid)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: UserProfileImage(
                                iconRadius: 42,
                                radius: 14,
                                profileImageUrl:
                                    widget.post.author.profileImageUrl,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.post.author.displayName,
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500)),
                                SizedBox(
                                  height: 1.5,
                                ),
                                _buildTime(widget.post.enddate.toDate())
                              ],
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                            color: kPrimaryBlackColor),
                                        borderRadius: BorderRadius.circular(8)),
                                    content: Text(
                                      'Reporting will unfollow the user and the post will be sent to help@tevo.com.',
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    title: Text(
                                      'Report or Unfollow',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    actions: [
                                      OutlinedButton(
                                        onPressed: () {
                                          widget.onPressed!();
                                          Navigator.of(context).popAndPushNamed(
                                              ReportScreen.routeName);
                                        },
                                        child: Text(
                                          'Report',
                                          style: TextStyle(
                                              fontSize: 9.5.sp,
                                              color: kPrimaryBlackColor),
                                        ),
                                      ),
                                      OutlinedButton(
                                        onPressed: () {
                                          widget.onPressed!();
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          'Unfollow',
                                          style: TextStyle(
                                              fontSize: 9.5.sp,
                                              color: kPrimaryBlackColor),
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: Text(
                            'Following',
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 9.5.sp),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: kPrimaryBlackColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                          ),
                        ),
                      ],
                    ),
                  ListView.builder(
                    padding: EdgeInsets.all(0),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (index < widget.post.completedTask.length) {
                        return TaskTile(
                          task: tasks![index],
                          view: TaskTileView.feedScreen,
                          isComplete: true,
                          isDeleted: () {},
                          isEditing: () {},
                        );
                      } else {
                        return TaskTile(
                          task: tasks![index],
                          view: TaskTileView.feedScreen,
                          isComplete: false,
                          isDeleted: () {},
                          isEditing: () {},
                        );
                      }
                    },
                    itemCount: tasks!.length,
                  ),
                  _buildFavoriteCommentTitle(widget),
                  _buildCommentTile(context, widget.post)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildTime(DateTime endOn) {
    return Text.rich(
      TextSpan(
          text:
              endOn.isAfter(DateTime.now()) ? "Will end on : " : "Ended on : ",
          style: TextStyle(
            fontSize: 7.sp,
            fontWeight: FontWeight.w500,
          ),
          children: [
            TextSpan(
                text: DateFormat("hh:mm a MMMM dd").format(endOn),
                style: TextStyle(
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal))
          ]),
    );
  }

  _buildFavoriteCommentTitle(widget) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
              child: InkWell(
                onTap: widget.onLike,
                child: widget.isLiked
                    ? const Icon(Icons.favorite, color: Colors.pink)
                    : const Icon(Icons.favorite_outline),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    CommentsScreen.routeName,
                    arguments: CommentsScreenArgs(post: widget.post),
                  );
                },
                child: FaIcon(FontAwesomeIcons.comment),
              ),
            ),
            //TODO plane
            if (widget.post.author.id != SessionHelper.uid)
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                child: InkWell(
                    onTap: () async {
                      final user = widget.post.author;
                      Navigator.of(context).pushNamed(
                        ChannelScreen.routeName,
                        arguments: ChannelScreenArgs(
                          user: user,
                          profileImage: user.profileImageUrl,
                          chatType: ChatType.oneOnOne,
                        ),
                      );
                    },
                    child: Icon(Linecons.paper_plane)),
              )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 0, bottom: 4),
          child: Text(
            '${widget.recentlyLiked ? widget.post.likes + 1 : widget.post.likes} likes',
            style: const TextStyle(fontWeight: FontWeight.w400),
          ),
        )
      ],
    );
  }

  _buildCommentTile(BuildContext context, Post post) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          UserProfileImage(
              radius: 10,
              profileImageUrl: SessionHelper.profileImageUrl!,
              iconRadius: 30),
          SizedBox(
            width: 60.w,
            child: TextField(
              controller: _commentTextController,
              style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w400),
              decoration: InputDecoration(
                enabledBorder: InputBorder.none,
                filled: true,
                hintText: "Add a comment...",
                hintStyle:
                    TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500),
                fillColor: Colors.white,
                focusedBorder: InputBorder.none,
                isDense: true, // Added this
              ),
            ),
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () async {
              if (_commentTextController.text.trim().isNotEmpty) {
                PostRepository().createComment(
                    post: post,
                    comment: Comment(
                        postId: post.id!,
                        author: await context
                            .read<UserRepository>()
                            .getUserWithId(userId: SessionHelper.uid!),
                        content: _commentTextController.text,
                        date: DateTime.now()));
                _commentTextController.clear();
                FocusScope.of(context).unfocus();
                flutterToast(msg: "Commented");
              }
            },
          )
        ],
      ),
    );
  }
}
