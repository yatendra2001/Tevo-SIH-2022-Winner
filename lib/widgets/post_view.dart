import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tevo/extensions/extensions.dart';
import 'package:tevo/models/models.dart';
import 'package:tevo/screens/screens.dart';
import 'package:tevo/widgets/widgets.dart';

class PostView extends StatelessWidget {
  final Post post;
  // final bool isLiked;
  // final VoidCallback onLike;
  // final bool recentlyLiked;

  const PostView({
    Key? key,
    required this.post,
    // required this.isLiked,
    // required this.onLike,
    // this.recentlyLiked = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tasks = post.completedTask..addAll(post.toDoTask);
    return Card(
      elevation: 5,
      child: Column(
        children: [
          Row(
            children: [
              post.author.profileImageUrl == ''
                  ? const Icon(
                      Icons.person,
                      size: 50,
                    )
                  : CachedNetworkImage(
                      imageUrl: post.author.profileImageUrl,
                    ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.author.username),
                  Text(post.enddate.toString())
                ],
              )
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              if (index < post.completedTask.length - 1) {
                return _buildTaskTile(index + 1, tasks[index], Colors.green);
              } else {
                return _buildTaskTile(index + 1, tasks[index], Colors.red);
              }
            },
            itemCount: tasks.length,
          ),
          _buildCommentTile(),
          Icon(
            Icons.arrow_drop_down,
            size: 30,
          )
        ],
      ),
    );
  }
}

_buildTaskTile(int index, Task task, Color color) {
  return Card(
    color: color,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 10,
              ),
              Text(index.toString()),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.task),
                  Text(task.timestamp.toDate().toString())
                ],
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Text('24'),
              SizedBox(
                width: 10,
              ),
              Icon(Icons.favorite),
            ],
          )
        ],
      ),
    ),
  );
}

_buildCommentTile() {
  return ListTile(
    leading: Icon(Icons.person),
    minLeadingWidth: 10,
    title: Container(
      decoration: BoxDecoration(
          color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
      width: 100,
      height: 30,
    ),
    trailing: Icon(Icons.send),
  );
}
