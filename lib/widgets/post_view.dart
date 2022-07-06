import 'package:flutter/material.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:tevo/models/models.dart';
import 'package:tevo/repositories/user/user_repository.dart';
import 'package:tevo/screens/screens.dart';
import 'package:tevo/utils/session_helper.dart';
import 'package:tevo/utils/theme_constants.dart';
import 'package:tevo/widgets/widgets.dart';

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

  @override
  void initState() {
    tasks = List.from(widget.post.completedTask);
    tasks!.addAll(List.from(widget.post.toDoTask));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                                radius: 20,
                                profileImageUrl:
                                    widget.post.author.profileImageUrl,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.post.author.username,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                const Text(
                                  "",
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                )
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
                                      'Are you sure to unfollow ?',
                                      style: TextStyle(fontSize: 9.5.sp),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          // widget.onPressed!();
                                          // Navigator.of(context).popAndPushNamed(
                                          //     ReportScreen.routeName);
                                        },
                                        child: Text(
                                          'Report',
                                          style: TextStyle(
                                              fontSize: 9.5.sp,
                                              color: kPrimaryBlackColor),
                                        ),
                                      ),
                                      TextButton(
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildFavoriteCommentTitle(widget) {
    int likes =
        widget.recentlyLiked ? widget.post.likes + 1 : widget.post.likes;
    String likeText = (likes == 1) ? '$likes Person' : '$likes People';
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: widget.onLike,
                icon: widget.isLiked
                    ? const Icon(Icons.favorite, color: Colors.pink)
                    : const Icon(Icons.favorite_outline),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    CommentsScreen.routeName,
                    arguments: CommentsScreenArgs(post: widget.post),
                  );
                },
                icon: FaIcon(FontAwesomeIcons.comment),
              ),
              //TODO plane
              if (widget.post.author.id != SessionHelper.uid)
                IconButton(
                    onPressed: () async {
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
                    icon: Icon(Linecons.paper_plane))
            ],
          ),
          (widget.post.likes != 0 || widget.recentlyLiked)
              ? RichText(
                  text: TextSpan(
                      text: "Liked by ",
                      style: TextStyle(color: Colors.black),
                      children: [
                      TextSpan(
                          text: likeText,
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ]))
              : SizedBox.shrink(),
          SizedBox(
            height: 2,
          ),
        ],
      ),
    );
  }

  _buildCommentTile(BuildContext context, Post post) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 300,
            child: TextField(
              onTap: () => Navigator.of(context).pushNamed(
                CommentsScreen.routeName,
                arguments: CommentsScreenArgs(post: post),
              ),
              readOnly: true,
              decoration: InputDecoration(
                disabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                filled: true,
                hintText: "Add Comment",
                hintStyle: TextStyle(fontSize: 12),
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                isDense: true, // Added this
                contentPadding: EdgeInsets.all(12),
              ),
            ),
          ),
          Icon(Icons.send)
        ],
      ),
    );
  }
}
