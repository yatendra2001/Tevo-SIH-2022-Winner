import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttericon/linearicons_free_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:tevo/cubits/cubits.dart';
import 'package:tevo/screens/feed/bloc/feed_bloc.dart';
import 'package:tevo/screens/login/onboarding/follow_users_screen.dart';
import 'package:tevo/screens/profile/followers_screen.dart';
import 'package:tevo/screens/screens.dart';
import 'package:tevo/screens/stream_chat/cubit/initialize_stream_chat/initialize_stream_chat_cubit.dart';
import 'package:tevo/screens/stream_chat/ui/stream_chat_inbox.dart';
import 'package:tevo/utils/session_helper.dart';
import 'package:tevo/utils/theme_constants.dart';
import 'package:tevo/widgets/widgets.dart';
import 'package:fluttericon/linecons_icons.dart';

class FeedScreen extends StatefulWidget {
  static const String routeName = '/feed';

  const FeedScreen({Key? key}) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late ScrollController _scrollController;
  late TextEditingController _textEditingController;
  bool isScrollingDown = true;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.offset >=
                _scrollController.position.maxScrollExtent &&
            !_scrollController.position.outOfRange &&
            context.read<FeedBloc>().state.status != FeedStatus.paginating) {
          context.read<FeedBloc>().add(FeedPaginatePosts());
        }
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (!isScrollingDown) {
            isScrollingDown = true;
            setState(() {});
          }
        }
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (isScrollingDown) {
            isScrollingDown = false;
            setState(() {});
          }
        }
      });
    StreamChat.of(context)
        .client
        .on()
        .where((Event event) => event.totalUnreadCount != null)
        .listen((Event event) {
      setState(() {
        SessionHelper.totalUnreadMessagesCount = event.totalUnreadCount!;
      });
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FeedBloc, FeedState>(
      listener: (context, state) {
        if (state.status == FeedStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(content: state.failure.message),
          );
        } else if (state.status == FeedStatus.paginating) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Theme.of(context).primaryColor,
              duration: const Duration(seconds: 1),
              content: const Text('Fetching More Posts...'),
            ),
          );
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
              body: SafeArea(
            child: NestedScrollView(
              clipBehavior: Clip.none,
              controller: _scrollController,
              headerSliverBuilder: (_, __) {
                return [
                  SliverAppBar(
                    floating: true,
                    snap: true,
                    automaticallyImplyLeading: false,
                    centerTitle: false,
                    pinned: true,
                    elevation: 1,
                    toolbarHeight: 9.h,
                    title: Text("TEVO",
                        style: Theme.of(context).textTheme.displayLarge),
                    bottom: PreferredSize(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 16, right: 16, left: 16),
                          child: SizedBox(
                            height: 7.5.h,
                            child: TextField(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    SearchScreen.routeName,
                                    arguments: SearchScreenArgs(
                                        type: SearchScreenType.profile));
                              },
                              readOnly: true,
                              decoration: InputDecoration(
                                fillColor: const Color(0xffF5F5F5),
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 1.0),
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 1.0),
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                hintText: 'Search for accounts',
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 8.5.sp),
                                suffixIcon: const Icon(
                                  Icons.search,
                                  color: Colors.black38,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ),
                        preferredSize: Size(double.infinity, 11.h)),
                    actions: [
                      Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  ProfileScreen.routeName,
                                  arguments: ProfileScreenArgs(
                                      userId: SessionHelper.uid!));
                            },
                            child: UserProfileImage(
                              radius: 16,
                              profileImageUrl: SessionHelper.profileImageUrl!,
                            ),
                          )),
                      BlocBuilder<InitializeStreamChatCubit,
                          InitializeStreamChatState>(
                        builder: (context, state) {
                          if (state is StreamChatInitializedState) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 8),
                              child: Stack(
                                children: [
                                  if (SessionHelper.totalUnreadMessagesCount >
                                      0)
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: kPrimaryBlackColor),
                                      child: Text(
                                        '${SessionHelper.totalUnreadMessagesCount}',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  IconButton(
                                    icon: const Icon(Linecons.paper_plane),
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, StreamChatInbox.routeName);
                                    },
                                  ),
                                ],
                              ),
                            );
                          }
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: IconButton(
                              icon: const Icon(Linecons.paper_plane),
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, StreamChatInbox.routeName);
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ];
              },
              body: _buildBody(state),
              floatHeaderSlivers: true,
            ),
          )),
        );
      },
    );
  }

  _buildBody(FeedState state) {
    switch (state.status) {
      case FeedStatus.loading:
        return const Center(child: CircularProgressIndicator());
      default:
        return RefreshIndicator(
          onRefresh: () async {
            context.read<FeedBloc>().add(FeedFetchPosts());
            context.read<LikedPostsCubit>().clearAllLikedPosts();
            print("Laaaaaaaaa    " + state.posts.length.toString());
          },
          child: state.posts.isEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 128.0),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          "Your feed looks empty 📭",
                          style: TextStyle(
                              color: kPrimaryBlackColor.withOpacity(0.7),
                              fontWeight: FontWeight.w500,
                              fontSize: 15.sp),
                        ),
                        const SizedBox(height: 8.0),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: kPrimaryWhiteColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: kPrimaryBlackColor),
                                  borderRadius: BorderRadius.circular(5))),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const FollowUsersScreen()),
                            );
                          },
                          child: Text(
                            'Follow users',
                            style: TextStyle(
                                color: kPrimaryBlackColor, fontSize: 8.5.sp),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: state.posts.length,
                  itemBuilder: (BuildContext context, int index) {
                    final post = state.posts[index];
                    final likedPostsState =
                        context.watch<LikedPostsCubit>().state;
                    final isLiked =
                        likedPostsState.likedPostIds.contains(post!.id);
                    final recentlyLiked =
                        likedPostsState.recentlyLikedPostIds.contains(post.id);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: PostView(
                        isLiked: isLiked,
                        onLike: () {
                          if (isLiked) {
                            context
                                .read<LikedPostsCubit>()
                                .unlikePost(post: post);
                          } else {
                            context
                                .read<LikedPostsCubit>()
                                .likePost(post: post);
                          }
                        },
                        recentlyLiked: recentlyLiked,
                        post: post,
                        onPressed: () {
                          context.read<FeedBloc>().add(FeedToUnfollowUser(
                              unfollowUserId: post.author.id));
                          Fluttertoast.showToast(
                            msg: "${post.author.username} Unfollowed",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.black54,
                          );
                        },
                      ),
                    );
                  },
                ),
        );
    }
  }
}
