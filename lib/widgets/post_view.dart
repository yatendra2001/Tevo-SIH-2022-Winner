import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:fluttericon/linearicons_free_icons.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:tevo/extensions/extensions.dart';
import 'package:tevo/models/models.dart';
import 'package:tevo/repositories/post/post_repository.dart';
import 'package:tevo/repositories/user/user_repository.dart';
import 'package:tevo/screens/comments/bloc/comments_bloc.dart';
import 'package:tevo/screens/likes_screen.dart';
import 'package:tevo/screens/report/report_screen.dart';
import 'package:tevo/screens/screens.dart';
import 'package:tevo/utils/session_helper.dart';
import 'package:tevo/utils/theme_constants.dart';
import 'package:tevo/widgets/widgets.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

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
  late int _completionRate;
  late int _userCompletionRate;
  bool isButtonActive = false;

  _getCompletionRateColor(int completionRate) {
    return completionRate >= 90
        ? kPrimaryVioletColor
        : (completionRate >= 78
            ? kPrimaryTealColor
            : (completionRate < 20 ? kPrimaryRedColor : kSecondaryYellowColor));
  }

  User? likeUser;
  @override
  void initState() {
    tasks = List.from(widget.post.completedTask);
    tasks!.addAll(List.from(widget.post.toDoTask));
    _completionRate =
        (widget.post.toDoTask.length + widget.post.completedTask.length) != 0
            ? (((widget.post.completedTask.length) * 100) /
                    (widget.post.toDoTask.length +
                        widget.post.completedTask.length))
                .roundToDouble()
                .toInt()
            : 0;
    _userCompletionRate =
        (widget.post.author.completed + widget.post.author.todo) != 0
            ? (((widget.post.author.completed) * 100) /
                    (widget.post.author.completed + widget.post.author.todo))
                .roundToDouble()
                .toInt()
            : 0;

    _commentTextController.addListener(() {
      setState(() {
        isButtonActive = _commentTextController.text.isNotEmpty;
      });
    });
    funLike();
    super.initState();
  }

  funLike() async {
    likeUser =
        await context.read<UserRepository>().postOneLikeUser(widget.post.id!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: kPrimaryWhiteColor,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (widget.post.author.id != SessionHelper.uid)
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(ProfileScreen.routeName,
                          arguments:
                              ProfileScreenArgs(userId: widget.post.author.id));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 1,
                                        color: _getCompletionRateColor(
                                            _userCompletionRate))),
                                child: UserProfileImage(
                                  iconRadius: 42,
                                  radius: 14,
                                  profileImageUrl:
                                      widget.post.author.profileImageUrl,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.post.author.displayName,
                                  style:
                                      // GoogleFonts.roboto(
                                      //   fontWeight: FontWeight.w400,
                                      //   fontSize: 12.sp,
                                      // ),
                                      TextStyle(
                                          fontFamily: kFontFamily,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 1.5,
                                ),
                                _buildTime(widget.post.enddate.toDate())
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  // color: kPrimaryTealColor,
                                  border: Border.all(
                                      color: _getCompletionRateColor(
                                          _completionRate))),
                              child: Padding(
                                padding: EdgeInsets.all(9.sp),
                                child: Text(
                                  // (((widget.post.completedTask.length) * 100) /
                                  //             (widget.post.toDoTask.length +
                                  //                 widget.post.completedTask.length))
                                  _completionRate.toString() + "%",
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      fontFamily: kFontFamily,
                                      fontWeight: FontWeight.w600,
                                      color: _getCompletionRateColor(
                                          _completionRate)),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                                color: kPrimaryBlackColor),
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        content: Text(
                                          'Reporting will unfollow the user and the post will be sent to help.tevo@gmail.com.',
                                          style: TextStyle(
                                            fontFamily: kFontFamily,
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        title: Text(
                                          'Report or Unfollow',
                                          style: TextStyle(
                                            fontFamily: kFontFamily,
                                            fontSize: 12.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        actions: [
                                          OutlinedButton(
                                            onPressed: () async {
                                              const mailUrl =
                                                  'mailto:help.tevo@gmail.com';
                                              try {
                                                await launchUrl(
                                                    Uri.parse(mailUrl));
                                              } catch (e) {
                                                await Clipboard.setData(
                                                    const ClipboardData(
                                                        text:
                                                            'help.tevo@gmail.com'));
                                              }
                                            },
                                            child: Text(
                                              'Report',
                                              style: TextStyle(
                                                fontFamily: kFontFamily,
                                                fontSize: 10.sp,
                                                color: kPrimaryBlackColor
                                                    .withOpacity(0.6),
                                              ),
                                            ),
                                            style: ButtonStyle(
                                              overlayColor:
                                                  MaterialStateProperty.all(
                                                      Colors.black
                                                          .withOpacity(0.1)),
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
                                                fontFamily: kFontFamily,
                                                fontSize: 10.sp,
                                                color: kPrimaryBlackColor
                                                    .withOpacity(0.6),
                                              ),
                                            ),
                                            style: ButtonStyle(
                                              overlayColor:
                                                  MaterialStateProperty.all(
                                                      Colors.black
                                                          .withOpacity(0.1)),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                    useSafeArea: true);
                              },
                              icon:
                                  const Icon(FontAwesomeIcons.ellipsisVertical),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 8),
                ListView.builder(
                  padding: const EdgeInsets.all(0),
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
                const SizedBox(height: 2),
                _buildFavoriteCommentTitle(widget),
                const Divider(),
                const SizedBox(height: 2),
                _buildCommentTile(context, widget.post)
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildTime(DateTime endOn) {
    String dateTime;
    if (endOn.difference(DateTime.now()).inHours > 1) {
      dateTime = endOn.difference(DateTime.now()).inHours.toString() + " hours";
    } else {
      dateTime =
          endOn.difference(DateTime.now()).inMinutes.toString() + " minutes";
    }
    return Text(
      endOn.isAfter(DateTime.now())
          ? ("${dateTime} remaining")
          : ("Closed ${timeago.format(endOn)}"),
      style: TextStyle(
          fontFamily: kFontFamily,
          fontSize: 8.sp,
          fontWeight: FontWeight.w300,
          color: kPrimaryBlackColor.withOpacity(0.7)),
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
                onTap: () {
                  widget.onLike();
                  funLike();
                },
                child: widget.isLiked
                    ? const Icon(Elusive.heart, color: Colors.pink)
                    : const Icon(Linecons.heart),
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
                child: const FaIcon(Linecons.comment),
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
                    child: const Icon(Linecons.paper_plane)),
              )
          ],
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(LikesScreen.routeName,
                arguments: LikesScreenArgs(postId: widget.post.id));
          },
          child: Container(
            margin:
                const EdgeInsets.only(left: 16, top: 8, bottom: 8, right: 16),
            padding: EdgeInsets.only(bottom: 1),
            child: _buildLike(widget.recentlyLiked
                ? widget.post.likes + 1
                : widget.post.likes),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  _buildLike(int likes) {
    if (likeUser == null && likes > 0) {
      return Text(
        '$likes likes',
        style: TextStyle(
          fontSize: 8.sp,
          fontWeight: FontWeight.w400,
          fontFamily: kFontFamily,
          color: kPrimaryBlackColor.withOpacity(0.7),
        ),
      );
    }
    switch (likes) {
      case 0:
        return Text(
          'No likes',
          style: TextStyle(
            fontSize: 8.sp,
            fontWeight: FontWeight.w400,
            fontFamily: kFontFamily,
            color: kPrimaryBlackColor.withOpacity(0.7),
          ),
        );
      case 1:
        return Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Liked by ',
                style: TextStyle(
                  fontSize: 8.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: kFontFamily,
                  color: kPrimaryBlackColor.withOpacity(0.7),
                ),
              ),
              TextSpan(
                text: SessionHelper.uid == likeUser!.id
                    ? "You"
                    : likeUser!.displayName,
                style: TextStyle(
                  fontSize: 8.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: kFontFamily,
                ),
              ),
            ],
          ),
        );

      default:
        return Text.rich(
          TextSpan(children: [
            TextSpan(
              text: 'Liked by ',
              style: TextStyle(
                fontSize: 8.sp,
                fontWeight: FontWeight.w400,
                fontFamily: kFontFamily,
                color: kPrimaryBlackColor.withOpacity(0.7),
              ),
            ),
            TextSpan(
              text: SessionHelper.uid == likeUser!.id
                  ? "You"
                  : likeUser!.displayName,
              style: TextStyle(
                fontSize: 8.sp,
                fontWeight: FontWeight.w500,
                fontFamily: kFontFamily,
              ),
            ),
            TextSpan(
              text: ' and ',
              style: TextStyle(
                fontSize: 8.sp,
                fontWeight: FontWeight.w400,
                fontFamily: kFontFamily,
                color: kPrimaryBlackColor.withOpacity(0.7),
              ),
            ),
            TextSpan(
              text: '${likes - 1} others',
              style: TextStyle(
                fontSize: 8.sp,
                fontWeight: FontWeight.w500,
                fontFamily: kFontFamily,
              ),
            ),
          ]),
        );
    }
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
              style: TextStyle(
                  fontFamily: kFontFamily,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400),
              decoration: InputDecoration(
                enabledBorder: InputBorder.none,
                filled: true,
                hintText: "Add a comment...",
                hintStyle: TextStyle(
                    fontFamily: kFontFamily,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500),
                fillColor: Colors.white,
                focusedBorder: InputBorder.none,
                isDense: true, // Added this
              ),
            ),
          ),
          const Spacer(),
          IconButton(
            icon: Center(
              child: Icon(
                Icons.send_rounded,
                color: !isButtonActive ? Colors.grey : kPrimaryBlackColor,
              ),
            ),
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
