// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:tevo/cubits/cubits.dart';
// import 'package:tevo/screens/feed/bloc/feed_bloc.dart';
// import 'package:tevo/utils/assets_constants.dart';
// import 'package:tevo/widgets/widgets.dart';

// class FeedScreen extends StatefulWidget {
//   static const String routeName = '/feed';

//   const FeedScreen();

//   @override
//   _FeedScreenState createState() => _FeedScreenState();
// }

// class _FeedScreenState extends State<FeedScreen> {
//   late ScrollController _scrollController;

//   @override
//   void initState() {
//     super.initState();
//     _scrollController = ScrollController()
//       ..addListener(() {
//         if (_scrollController.offset >=
//                 _scrollController.position.maxScrollExtent &&
//             !_scrollController.position.outOfRange &&
//             context.read<FeedBloc>().state.status != FeedStatus.paginating) {
//           context.read<FeedBloc>().add(FeedPaginatePosts());
//         }
//       });
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<FeedBloc, FeedState>(
//       listener: (context, state) {
//         if (state.status == FeedStatus.error) {
//           showDialog(
//             context: context,
//             builder: (context) => ErrorDialog(content: state.failure.message),
//           );
//         } else if (state.status == FeedStatus.paginating) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               backgroundColor: Theme.of(context).primaryColor,
//               duration: const Duration(seconds: 1),
//               content: const Text('Fetching More Posts...'),
//             ),
//           );
//         }
//       },
//       builder: (context, state) {
//         return GestureDetector(
//           onTap: () => FocusScope.of(context).unfocus(),
//           child: Scaffold(
//             appBar: AppBar(
//               automaticallyImplyLeading: false,
//               centerTitle: false,
//               elevation: 1,
//               toolbarHeight: 70,
//               title: const Text(
//                 "TEVO",
//                 style: TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.w900,
//                     fontSize: 32),
//               ),
//               actions: [
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(30),
//                     child: Image.asset(kBaseProfileImagePath),
//                   ),
//                 )
//               ],
//             ),
//             body: _buildBody(state),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildBody(FeedState state) {
//     switch (state.status) {
//       case FeedStatus.loading:
//         return const Center(child: CircularProgressIndicator());
//       default:
//         return RefreshIndicator(
//           onRefresh: () async {
//             context.read<FeedBloc>().add(FeedFetchPosts());
//             context.read<LikedPostsCubit>().clearAllLikedPosts();
//           },
//           child: ListView.builder(
//             controller: _scrollController,
//             itemCount: state.posts.length,
//             itemBuilder: (BuildContext context, int index) {
//               final post = state.posts[index];
//               // final likedPostsState = context.watch<LikedPostsCubit>().state;
//               // final isLiked = likedPostsState.likedPostIds.contains(post!.id);
//               // final recentlyLiked =
//               //     likedPostsState.recentlyLikedPostIds.contains(post.id);
//               return PostView(
//                 post: post!,
//               );
//             },
//           ),
//         );
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tevo/cubits/cubits.dart';
import 'package:tevo/screens/feed/bloc/feed_bloc.dart';
import 'package:tevo/utils/assets_constants.dart';
import 'package:tevo/widgets/widgets.dart';

class FeedScreen extends StatefulWidget {
  static const String routeName = '/feed';

  const FeedScreen();

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late ScrollController _scrollController;
  bool _showSeachBox = true;
  bool isScrollingDown = true;

  @override
  void initState() {
    super.initState();
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
            _showSeachBox = false;
            setState(() {});
          }
        }
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (isScrollingDown) {
            isScrollingDown = false;
            _showSeachBox = true;
            setState(() {});
          }
        }
      });
  }

  @override
  void dispose() {
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
              body: NestedScrollView(
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
                  toolbarHeight: 70,
                  title: const Text(
                    "TEVO",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 38,
                    ),
                  ),
                  bottom: PreferredSize(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: TextField(
                            // controller: _textEditingController,
                            decoration: InputDecoration(
                              fillColor: Color(0xffF5F5F5),
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 1.0),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 1.0),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              hintText: 'Search for accounts',
                              hintStyle: const TextStyle(
                                  fontWeight: FontWeight.normal),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  // context.read<SearchCubit>().clearSearch();
                                  // _textEditingController?.clear();
                                },
                                icon: const Icon(
                                  Icons.search,
                                  size: 30,
                                ),
                              ),
                            ),
                            textInputAction: TextInputAction.search,
                            textAlignVertical: TextAlignVertical.center,
                            onChanged: (value) {
                              //   context.read<SearchCubit>().clearSearch();
                              //   if (value.trim().isNotEmpty) {
                              //     context.read<SearchCubit>().searchUser(query: value.trim());
                              //   }
                              // },
                            }),
                      ),
                      preferredSize: Size(double.infinity, 77)),
                  actions: [
                    Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: UserProfileImage(
                          radius: 20,
                          profileImageUrl:
                              'https://www.htplonline.com/wp-content/uploads/2020/01/Awesome-Profile-Pictures-for-Guys-look-away2.jpg',
                        ))
                  ],
                ),
              ];
            },
            body: _buildBody(state),
            floatHeaderSlivers: true,
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
          },
          // child: Padding(
          //   padding: const EdgeInsets.only(bottom: 50),
          //   child: CustomScrollView(
          //     // controller: _scrollController,

          //     slivers: [
          //       SliverList(
          //         delegate: SliverChildBuilderDelegate(
          //           (context, index) {
          //             final post = state.posts[index];
          //             return PostView(
          //               post: post!,
          //             );
          //           },
          //           childCount: state.posts.length,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

          child: ListView.builder(
            itemCount: state.posts.length,
            itemBuilder: (BuildContext context, int index) {
              final post = state.posts[index];
              // final likedPostsState = context.watch<LikedPostsCubit>().state;
              // final isLiked = likedPostsState.likedPostIds.contains(post!.id);
              // final recentlyLiked =
              //     likedPostsState.recentlyLikedPostIds.contains(post.id);
              return PostView(
                post: post!,
              );
            },
          ),
        );
    }
  }
}
