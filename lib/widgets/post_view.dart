import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tevo/extensions/extensions.dart';
import 'package:tevo/models/models.dart';
import 'package:tevo/screens/report/report_screen.dart';
import 'package:tevo/screens/screens.dart';
import 'package:tevo/widgets/task_tile.dart';
import 'package:tevo/widgets/widgets.dart';

class PostView extends StatefulWidget {
  final Post post;
  final Function()? onPressed;
  // final bool isLiked;
  // final VoidCallback onLike;
  // final bool recentlyLiked;

  PostView({
    Key? key,
    required this.post,
    this.onPressed,
    // required this.isLiked,
    // required this.onLike,
    // this.recentlyLiked = false,
  }) : super(key: key);

  @override
  State<PostView> createState() => _PostViewState();
}

// class _PostViewState extends State<PostView> {
//   List<Task>? tasks;

//   @override
//   void initState() {
//     tasks = List.from(widget.post.completedTask);
//     tasks!.addAll(List.from(widget.post.toDoTask));
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Card(
//         elevation: 5,
//         shape: RoundedRectangleBorder(
//           side: const BorderSide(color: Colors.white70, width: 1),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       widget.post.author.profileImageUrl == ''
//                           ? const Icon(
//                               Icons.person,
//                               size: 50,
//                             )
//                           : CachedNetworkImage(
//                               imageUrl: widget.post.author.profileImageUrl,
//                             ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(widget.post.author.username,
//                               style: const TextStyle(
//                                   fontSize: 18, fontWeight: FontWeight.bold)),
//                           Text(DateFormat().format(widget.post.enddate))
//                         ],
//                       ),
//                     ],
//                   ),
//                   DropdownButton<String>(
//                     underline: const SizedBox.shrink(),
//                     icon: const Icon(Icons.more_vert_outlined),
//                     items: <String>["Unfollow", "Report"].map((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                       );
//                     }).toList(),
//                     onChanged: (_) {},
//                   )
//                 ],
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 itemBuilder: (context, index) {
//                   if (index < widget.post.completedTask.length) {
//                     return TaskTile(
//                       index: index + 1,
//                       task: tasks![index],
//                       isComplete: true,
//                     );
//                   } else {
//                     return TaskTile(
//                       index: index + 1,
//                       task: tasks![index],
//                       isComplete: false,
//                     );
//                   }
//                 },
//                 itemCount: tasks!.length,
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               _buildCommentTile(context, widget.post),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   _buildCommentTile(BuildContext context, Post post) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         SizedBox(
//           width: 300,
//           child: TextField(
//             onTap: () => Navigator.of(context).pushNamed(
//                 CommentsScreen.routeName,
//                 arguments: CommentsScreenArgs(post: post)),
//             readOnly: true,
//             decoration: InputDecoration(
//               disabledBorder: OutlineInputBorder(
//                 borderSide: const BorderSide(color: Colors.grey),
//                 borderRadius: BorderRadius.circular(25.0),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderSide: const BorderSide(color: Colors.grey),
//                 borderRadius: BorderRadius.circular(25.0),
//               ),
//               filled: true,
//               hintText: "Add Comment",
//               hintStyle: TextStyle(fontSize: 12),
//               fillColor: Colors.white,
//               focusedBorder: OutlineInputBorder(
//                 borderSide: const BorderSide(color: Colors.grey),
//                 borderRadius: BorderRadius.circular(25.0),
//               ),
//               isDense: true, // Added this
//               contentPadding: EdgeInsets.all(12),
//             ),
//           ),
//         ),
//         Icon(Icons.send)
//       ],
//     );
//   }
// }

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
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Color(0xffFFFFFF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 8),
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
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
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
                                    content: Text('Are you sure to unfollow ?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          // widget.onPressed!();
                                          // Navigator.of(context).popAndPushNamed(
                                          //     ReportScreen.routeName);
                                        },
                                        child: const Text('Report'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          widget.onPressed!();
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Unfollow'),
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: const Text(
                            'Following',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xff009688),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ))
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      // if (index < widget.post.completedTask.length) {
                      //   return TaskTile(
                      //     task: tasks![index],
                      //     isComplete: true,
                      //     isDeleted: () => context.read<CreatePostBloc>().add(
                      //         DeleteTaskEvent(
                      //             task: state.completedTask[index])),
                      //   );
                      // } else {
                      //   return TaskTile(
                      //     task: tasks![index],
                      //     isComplete: false,
                      //     isDeleted: () => context.read<CreatePostBloc>().add(
                      //         DeleteTaskEvent(
                      //             task: state.completedTask[index])),
                      //   );
                      return SizedBox.shrink();
                    },
                    itemCount: tasks!.length,
                  ),
                  _buildFavoriteCommentTitle(widget.post),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildFavoriteCommentTitle(Post post) {
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
                onPressed: () {},
                icon: Icon(
                  Icons.favorite_border_outlined,
                  size: 30,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    CommentsScreen.routeName,
                    arguments: CommentsScreenArgs(post: post),
                  );
                },
                icon: FaIcon(FontAwesomeIcons.comment),
              ),
              IconButton(
                  onPressed: () {}, icon: Icon(FontAwesomeIcons.paperPlane))
            ],
          ),
          RichText(
              text: TextSpan(
                  text: "Liked by",
                  style: TextStyle(color: Colors.black),
                  children: [
                TextSpan(
                    text: " Tanmay",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: " and"),
                TextSpan(
                    text: " 19", style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: " others"),
              ])),
          SizedBox(
            height: 2,
          ),
          Text(
            '10 comments',
            style: TextStyle(fontWeight: FontWeight.w300),
          )
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
