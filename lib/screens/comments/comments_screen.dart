import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tevo/blocs/blocs.dart';
import 'package:tevo/models/models.dart';
import 'package:tevo/repositories/repositories.dart';
import 'package:tevo/screens/comments/bloc/comments_bloc.dart';
import 'package:tevo/screens/screens.dart';
import 'package:tevo/widgets/widgets.dart';
import 'package:intl/intl.dart';

class CommentsScreenArgs {
  final Post post;
  const CommentsScreenArgs({required this.post});
}

class CommentsScreen extends StatefulWidget {
  static const String routeName = 'comments_screen';

  const CommentsScreen({Key? key}) : super(key: key);

  static Route route({required CommentsScreenArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<CommentsBloc>(
        create: (_) => CommentsBloc(
          postRepository: context.read<PostRepository>(),
          authBloc: context.read<AuthBloc>(),
        )..add(CommentsFetchComments(post: args.post)),
        child: const CommentsScreen(),
      ),
    );
  }

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CommentsBloc, CommentsState>(
      listener: (context, state) {
        if (state.status == CommentsStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(content: state.failure.message),
          );
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: const Text(
                'Comments',
                style: TextStyle(color: Colors.black),
              ),
              bottom: PreferredSize(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _commentController,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: const InputDecoration.collapsed(
                                  hintText: 'Write a comment...'),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () {
                              final content = _commentController.text.trim();
                              if (content.isNotEmpty) {
                                context
                                    .read<CommentsBloc>()
                                    .add(CommentsPostComment(content: content));
                                _commentController.clear();
                              }
                            },
                          ),
                        ],
                      ),
                      if (state.status == CommentsStatus.submitting)
                        const LinearProgressIndicator(),
                    ],
                  ),
                ),
                preferredSize: Size(300, 50),
              ),
            ),
            body: state.status == CommentsStatus.loading
                ? const CircularProgressIndicator()
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 60.0),
                    itemCount: state.comments.length,
                    itemBuilder: (BuildContext context, int index) {
                      final comment = state.comments[index];
                      return ListTile(
                        leading: UserProfileImage(
                          radius: 22.0,
                          profileImageUrl: comment!.author.profileImageUrl,
                        ),
                        title: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: comment.author.username,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              ),
                              const TextSpan(text: ' '),
                              TextSpan(text: comment.content),
                            ],
                          ),
                        ),
                        subtitle: Text(
                          DateFormat.yMd().add_jm().format(comment.date),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () => Navigator.of(context).pushNamed(
                          ProfileScreen.routeName,
                          arguments:
                              ProfileScreenArgs(userId: comment.author.id),
                        ),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
