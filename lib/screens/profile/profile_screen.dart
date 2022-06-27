import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:tevo/blocs/blocs.dart';
import 'package:tevo/cubits/cubits.dart';
import 'package:tevo/main.dart';
import 'package:tevo/repositories/repositories.dart';
import 'package:tevo/screens/login/login_cubit/login_cubit.dart';
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

  const ProfileScreen({Key? key}) : super(key: key);

  static Route route({required ProfileScreenArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<ProfileBloc>(
        create: (_) => ProfileBloc(
          userRepository: context.read<UserRepository>(),
          postRepository: context.read<PostRepository>(),
          authBloc: context.read<AuthBloc>(),
          likedPostsCubit: context.read<LikedPostsCubit>(),
        )..add(ProfileLoadUser(userId: args.userId)),
        child: const ProfileScreen(),
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
            elevation: 0,
            backgroundColor: Colors.grey[50],
            actions: [
              if (state.isCurrentUser)
                Switch(
                    value: state.user.isPrivate,
                    onChanged: (val) {
                      context
                          .read<ProfileBloc>()
                          .add(ProfileToUpdateUser(isPrivate: val));
                    }),
              if (state.isCurrentUser)
                IconButton(
                  icon: const Icon(
                    Icons.exit_to_app,
                    color: kPrimaryBlackColor,
                  ),
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthLogoutRequested());
                    context.read<LoginCubit>().logoutRequested();
                    context.read<LikedPostsCubit>().clearAllLikedPosts();
                    MyApp.navigatorKey.currentState!
                        .pushReplacementNamed(WelcomeScreen.routeName);
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          UserProfileImage(
                            radius: 40.0,
                            profileImageUrl: state.user.profileImageUrl,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30.0,
                                vertical: 10.0,
                              ),
                              child: ProfileInfo(
                                username: state.user.username,
                                bio: state.user.bio,
                                displayName: state.user.displayName,
                              ),
                            ),
                          ),
                        ],
                      ),
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
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Divider(
                      color: kPrimaryBlackColor,
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                  ],
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final post = state.posts[index];
                    final date = state.posts[index]!.toDoTask[0].dateTime;
                    final likedPostsState =
                        context.watch<LikedPostsCubit>().state;
                    final isLiked =
                        likedPostsState.likedPostIds.contains(post!.id);
                    return Column(
                      children: [
                        Text(
                          DateFormat("EEEE, MMMM d, y").format(date),
                          style: TextStyle(
                              color: kPrimaryBlackColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 18.sp),
                        ),
                        SizedBox(height: 8),
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
