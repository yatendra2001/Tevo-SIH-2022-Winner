import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:tevo/blocs/blocs.dart';
import 'package:tevo/models/models.dart';
import 'package:tevo/repositories/repositories.dart';
import 'package:tevo/screens/comments/bloc/comments_bloc.dart';
import 'package:tevo/screens/screens.dart';
import 'package:tevo/utils/theme_constants.dart';
import 'package:tevo/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

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
              title: Text(
                'Comments',
                style: TextStyle(
                  color: kPrimaryBlackColor,
                  fontSize: 15.sp,
                  fontFamily: kFontFamily,
                ),
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
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                fontFamily: kFontFamily,
                              ),
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration.collapsed(
                                hintText: 'Write a comment...',
                                hintStyle: TextStyle(
                                    fontFamily: kFontFamily,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500),
                              ),
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
                        const LinearProgressIndicator(
                            color: kPrimaryBlackColor),
                    ],
                  ),
                ),
                preferredSize: Size(300, 50),
              ),
            ),
            body: state.status == CommentsStatus.loading
                ? const CircularProgressIndicator(
                    color: kPrimaryBlackColor,
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 60.0),
                    itemCount: state.comments.length,
                    itemBuilder: (BuildContext context, int index) {
                      final comment = state.comments[index];
                      return ListTile(
                        leading: UserProfileImage(
                          iconRadius: 49,
                          radius: 14.0,
                          profileImageUrl: comment!.author.profileImageUrl,
                        ),
                        title: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: comment.author.displayName.split(" ")[0],
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: kFontFamily,
                                ),
                              ),
                              TextSpan(
                                text: " : " + comment.content,
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: kFontFamily,
                                ),
                              ),
                            ],
                          ),
                        ),
                        subtitle: Text(
                          timeago.format(comment.date),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontFamily: kFontFamily,
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
