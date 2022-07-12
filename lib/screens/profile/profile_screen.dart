import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

import 'package:tevo/blocs/blocs.dart';
import 'package:tevo/cubits/cubits.dart';
import 'package:tevo/enums/bottom_nav_item.dart';
import 'package:tevo/main.dart';
import 'package:tevo/repositories/repositories.dart';
import 'package:tevo/screens/login/login_cubit/login_cubit.dart';
import 'package:tevo/screens/login/pageview.dart';
import 'package:tevo/screens/nav/cubit/bottom_nav_bar_cubit.dart';
import 'package:tevo/screens/profile/bloc/profile_bloc.dart';
import 'package:tevo/screens/profile/widgets/widgets.dart';
import 'package:tevo/screens/screens.dart';
import 'package:tevo/utils/theme_constants.dart';
import 'package:tevo/widgets/widgets.dart';

class ProfileScreenArgs {
  final String userId;
  const ProfileScreenArgs({required this.userId});
}

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile';
  final String userId;
  const ProfileScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  static Route route({required ProfileScreenArgs args}) {
    return PageTransition(
      settings: const RouteSettings(name: routeName),
      type: PageTransitionType.rightToLeft,
      child: BlocProvider<ProfileBloc>(
        create: (context) => ProfileBloc(
          userRepository: context.read<UserRepository>(),
          postRepository: context.read<PostRepository>(),
          authBloc: context.read<AuthBloc>(),
          likedPostsCubit: context.read<LikedPostsCubit>(),
        )..add(ProfileLoadUser(userId: args.userId)),
        child: ProfileScreen(
          userId: args.userId,
        ),
      ),
    );
  }

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.status == ProfileStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(content: state.failure.message),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            elevation: 0,
            backgroundColor: Colors.grey[50],
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back_ios_new_outlined)),
            title: Row(
              children: [
                Text(
                  "${!state.user.isPrivate ? "Public" : "Private"} Profile",
                  style: TextStyle(fontSize: 15.sp),
                ),
              ],
            ),
            actions: [
              if (state.isCurrentUser)
                Transform.scale(
                  scale: 0.8,
                  child: CupertinoSwitch(
                      activeColor: kPrimaryBlackColor,
                      value: state.user.isPrivate,
                      onChanged: (val) {
                        context
                            .read<ProfileBloc>()
                            .add(ProfileToUpdateUser(isPrivate: val));
                        String message = '';
                        setState(() {
                          message = state.user.isPrivate ? "Public" : "Private";
                        });
                        Fluttertoast.showToast(
                            msg: "Profile Updated: $message");
                      }),
                ),
              if (state.isCurrentUser)
                IconButton(
                  icon: const Icon(
                    Icons.exit_to_app,
                    color: kPrimaryBlackColor,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.grey[50],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(
                              color: kPrimaryBlackColor, width: 2.0),
                        ),
                        title: Center(
                          child: Text(
                            "Are you sure you want to logout?",
                            style: TextStyle(
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.w400,
                              color: kPrimaryBlackColor,
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                "No",
                                style: TextStyle(
                                    color: kPrimaryBlackColor,
                                    fontSize: 8.5.sp),
                              )),
                          TextButton(
                              onPressed: () {
                                context
                                    .read<AuthBloc>()
                                    .add(AuthLogoutRequested(context: context));
                                context.read<LoginCubit>().logoutRequested();
                                context
                                    .read<LikedPostsCubit>()
                                    .clearAllLikedPosts();
                                MyApp.navigatorKey.currentState!
                                    .pushReplacementNamed(
                                        LoginPageView.routeName);
                              },
                              child: Text(
                                "Yes",
                                style: TextStyle(
                                    color: kPrimaryBlackColor,
                                    fontSize: 8.5.sp),
                              )),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(ProfileState state) {
    switch (state.status) {
      case ProfileStatus.loading:
        return const Center(child: CircularProgressIndicator());
      default:
        return RefreshIndicator(
          onRefresh: () async {
            context
                .read<ProfileBloc>()
                .add(ProfileLoadUser(userId: state.user.id));
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),

                    UserProfileImage(
                      iconRadius: 45.sp,
                      radius: 45.sp,
                      profileImageUrl: state.user.profileImageUrl,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ProfileInfo(
                      username: state.user.username,
                      bio: state.user.bio,
                      displayName: state.user.displayName,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ProfileStats(
                      isRequesting: state.isRequesting,
                      isCurrentUser: state.isCurrentUser,
                      isFollowing: state.isFollowing,
                      posts: state.posts.length,
                      followers: state.user.followers,
                      following: state.user.following,
                      userId: widget.userId,
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    // const Divider(
                    //   color: kPrimaryBlackColor,
                    //   thickness: 1.2,
                    // ),
                    const SizedBox(
                      height: 32,
                    ),
                    if (state.posts.isEmpty && state.isCurrentUser)
                      Padding(
                        padding: const EdgeInsets.only(top: 64.0),
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                "Make your first post 🚀",
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
                                        borderRadius:
                                            BorderRadius.circular(5))),
                                onPressed: () {
                                  context
                                      .read<BottomNavBarCubit>()
                                      .updateSelectedItem(BottomNavItem.create);
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Create Task',
                                  style: TextStyle(
                                      color: kPrimaryBlackColor,
                                      fontSize: 9.5.sp),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final post = state.posts[index];
                    final date = post!.enddate.toDate();
                    final likedPostsState =
                        context.watch<LikedPostsCubit>().state;
                    final isLiked =
                        likedPostsState.likedPostIds.contains(post!.id);
                    log(post.toString());
                    log("This is length of posts: " +
                        state.posts.length.toString());
                    return Column(
                      children: [
                        Text(
                          DateFormat("EEEE, MMMM d, y").format(date!),
                          style: TextStyle(
                              color: kPrimaryBlackColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 11.5.sp),
                        ),
                        const SizedBox(height: 8),
                        PostView(
                          post: post,
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
                          onPressed: null,
                        ),
                        SizedBox(height: 32),
                      ],
                    );
                  },
                  childCount: state.posts.length,
                ),
              )
            ],
          ),
        );
    }
  }
}
