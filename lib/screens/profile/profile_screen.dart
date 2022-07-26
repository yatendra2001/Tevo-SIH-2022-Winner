import 'dart:developer';
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rolling_switch/rolling_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sizer/sizer.dart';

import 'package:tevo/blocs/blocs.dart';
import 'package:tevo/cubits/cubits.dart';
import 'package:tevo/enums/bottom_nav_item.dart';
import 'package:tevo/main.dart';
import 'package:tevo/models/models.dart';
import 'package:tevo/repositories/repositories.dart';
import 'package:tevo/screens/login/login_cubit/login_cubit.dart';
import 'package:tevo/screens/login/pageview.dart';
import 'package:tevo/screens/nav/cubit/bottom_nav_bar_cubit.dart';
import 'package:tevo/screens/profile/bloc/profile_bloc.dart';
import 'package:tevo/screens/profile/widgets/widgets.dart';
import 'package:tevo/screens/screens.dart';
import 'package:tevo/utils/session_helper.dart';
import 'package:tevo/utils/theme_constants.dart';
import 'package:tevo/widgets/custom_appbar.dart';
import 'package:tevo/widgets/default_showcase_widget.dart';
import 'package:tevo/widgets/widgets.dart';

class ProfileScreenArgs {
  final String userId;
  const ProfileScreenArgs({required this.userId});
}

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile';
  static const PREFERENCES_IS_FIRST_LAUNCH_STRING =
      "PREFERENCES_IS_FIRST_LAUNCH_STRING";

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
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;
  AnimationStatus _animationStatus = AnimationStatus.dismissed;
  late TabController _controller;
  int tabBarIndex = 0;

  final TextEditingController _textControllerFollowing =
      TextEditingController();
  List<User> following = [];
  List<User> searchResultFollowing = [];
  bool isLoadingFollowing = true;
  bool isSearchingFollowing = false;

  final TextEditingController _textControllerFollowers =
      TextEditingController();
  List<User> followers = [];
  List<User> searchResultFollowers = [];

  bool isLoadingFollowers = true;
  bool isSearchingFollowers = false;

  bool isIdBlocked = false;

  @override
  void initState() {
    super.initState();
    checkUserBlocked();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _animation = Tween(end: 1.0, begin: 0.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        _animationStatus = status;
      });
    _controller = TabController(
      vsync: this,
      length: 3,
    );

    getfollowing();
    _textControllerFollowing.addListener(() {
      if (isSearchingFollowing == true &&
          _textControllerFollowing.text.isEmpty) {
        setState(() {
          isSearchingFollowing = false;
          searchResultFollowing = [];
        });
      } else if (isSearchingFollowing == false &&
          _textControllerFollowing.text.isNotEmpty) {
        for (var element in following) {
          if (element.displayName.startsWith(_textControllerFollowing.text) ||
              element.username.startsWith(_textControllerFollowing.text)) {
            if (searchResultFollowing.contains(element) == false) {
              searchResultFollowing.add(element);
            }
          }
        }
        setState(() {
          isSearchingFollowing = true;
        });
      }
    });

    getfollowers();
    _textControllerFollowers.addListener(() {
      if (isSearchingFollowers == true &&
          _textControllerFollowers.text.isEmpty) {
        setState(() {
          isSearchingFollowers = false;
          searchResultFollowers = [];
        });
      } else if (isSearchingFollowers == false &&
          _textControllerFollowers.text.isNotEmpty) {
        for (var element in followers) {
          if (element.displayName.startsWith(_textControllerFollowers.text) ||
              element.username.startsWith(_textControllerFollowers.text)) {
            if (searchResultFollowers.contains(element) == false) {
              searchResultFollowers.add(element);
            }
          }
        }
        setState(() {
          isSearchingFollowers = true;
        });
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isFirstLaunch().then((result) {
        if (result) ShowCaseWidget.of(myContext!).startShowCase([_one]);
      });
    });
  }

  checkUserBlocked() async {
    isIdBlocked =
        await context.read<ProfileBloc>().checkIsUserBlocked(widget.userId);
  }

  Future<bool> _isFirstLaunch() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    bool isFirstLaunch = sharedPreferences
            .getBool(ProfileScreen.PREFERENCES_IS_FIRST_LAUNCH_STRING) ??
        true;

    if (isFirstLaunch) {
      sharedPreferences.setBool(
          ProfileScreen.PREFERENCES_IS_FIRST_LAUNCH_STRING, false);
    }

    return isFirstLaunch;
  }

  getfollowing() async {
    following = await context.read<ProfileBloc>().getFollowing(widget.userId);
    setState(() {
      isLoadingFollowing = !isLoadingFollowing;
    });
  }

  getfollowers() async {
    followers = await context.read<ProfileBloc>().getFollowers(widget.userId);
    setState(() {
      isLoadingFollowers = !isLoadingFollowers;
    });
  }

  _getCompletionRateColor(double completionRate) {
    return completionRate >= 100
        ? kPrimaryVioletColor
        : completionRate >= 78
            ? kPrimaryTealColor
            : (completionRate < 20 ? kPrimaryRedColor : kSecondaryYellowColor);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _textControllerFollowers.dispose();
    _textControllerFollowing.dispose();
    super.dispose();
  }

  BuildContext? myContext;
  final GlobalKey _one = GlobalKey();
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
          body: ShowCaseWidget(
            builder: Builder(builder: (context) {
              myContext = context;
              return GestureDetector(
                  child: isIdBlocked == false
                      ? _buildBody(state)
                      : Container(
                          width: double.infinity,
                          child: Column(
                            children: [
                              customAppbar(""),
                              Spacer(),
                              Text("The user is Blocked"),
                              SizedBox(
                                height: 16,
                              ),
                              OutlinedButton(
                                  onPressed: () {
                                    context
                                        .read<ProfileBloc>()
                                        .blockUser(false, widget.userId);
                                    isIdBlocked = false;
                                    setState(() {});
                                  },
                                  child: Text("Unblock")),
                              Spacer()
                            ],
                          ),
                        ),
                  onTap: () => FocusScope.of(context).unfocus());
            }),
          ),
        );
      },
    );
  }

  Widget _buildBody(ProfileState state) {
    switch (state.status) {
      case ProfileStatus.loading:
        return const Center(
            child: CircularProgressIndicator(color: kPrimaryBlackColor));
      default:
        return RefreshIndicator(
          onRefresh: () async {
            context
                .read<ProfileBloc>()
                .add(ProfileLoadUser(userId: state.user.id));
          },
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: true,
                elevation: 0,
                backgroundColor: Colors.grey[50],
                leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back_ios_new_outlined)),
                title: Row(
                  children: [
                    Text(
                      "Profile",
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontFamily: kFontFamily,
                      ),
                    ),
                  ],
                ),
                actions: [
                  if (state.isCurrentUser)
                    Transform.scale(
                      scale: 0.6,
                      child: RollingSwitch.icon(
                        onChanged: (bool val) {
                          context
                              .read<ProfileBloc>()
                              .add(ProfileToUpdateUser(isPrivate: val));
                          String message = '';
                          setState(() {
                            message =
                                state.user.isPrivate ? "Public" : "Private";
                          });
                          flutterToast(msg: "Profile Updated: $message");
                        },
                        rollingInfoRight: RollingIconInfo(
                          icon: Icons.lock,
                          backgroundColor: kPrimaryBlackColor,
                          text: Text(
                            'Private',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: kFontFamily,
                            ),
                          ),
                        ),
                        rollingInfoLeft: RollingIconInfo(
                          icon: Icons.public,
                          backgroundColor: Colors.grey,
                          text: Text(
                            'Public',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: kFontFamily,
                            ),
                          ),
                        ),
                      ),
                    ),
                  state.isCurrentUser
                      ? Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: IconButton(
                            icon: SizedBox(
                              height: 3.2.h,
                              width: 3.2.h,
                              child: CachedNetworkImage(
                                  imageUrl:
                                      "https://cdn-icons-png.flaticon.com/512/159/159707.png"),
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) => AlertDialog(
                                  backgroundColor: Colors.grey[50],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: const BorderSide(
                                        color: kPrimaryBlackColor, width: 2.0),
                                  ),
                                  title: Center(
                                    child: Text(
                                      "Are you sure you want to logout?",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: kPrimaryBlackColor,
                                        fontFamily: kFontFamily,
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    OutlinedButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text(
                                          "No",
                                          style: TextStyle(
                                            color: kPrimaryBlackColor,
                                            fontSize: 10.sp,
                                            fontFamily: kFontFamily,
                                          ),
                                        )),
                                    OutlinedButton(
                                      onPressed: () {
                                        context.read<AuthBloc>().add(
                                            AuthLogoutRequested(
                                                context: context));
                                        context
                                            .read<LoginCubit>()
                                            .logoutRequested();
                                        context
                                            .read<LikedPostsCubit>()
                                            .clearAllLikedPosts();
                                        SessionHelperEmpty();
                                        MyApp.navigatorKey.currentState!
                                            .pushReplacementNamed(
                                                LoginPageView.routeName);
                                      },
                                      child: Text(
                                        "Yes",
                                        style: TextStyle(
                                            color: kPrimaryBlackColor,
                                            fontFamily: kFontFamily,
                                            fontSize: 10.sp),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      : IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) => AlertDialog(
                                backgroundColor: Colors.grey[50],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: const BorderSide(
                                      color: kPrimaryBlackColor, width: 2.0),
                                ),
                                title: Center(
                                  child: Text(
                                    "Are you sure you want to block the user?",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: kPrimaryBlackColor,
                                      fontFamily: kFontFamily,
                                    ),
                                  ),
                                ),
                                actions: [
                                  OutlinedButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(
                                      "No",
                                      style: TextStyle(
                                        color: kPrimaryBlackColor,
                                        fontSize: 10.sp,
                                        fontFamily: kFontFamily,
                                      ),
                                    ),
                                  ),
                                  OutlinedButton(
                                    onPressed: () {
                                      isIdBlocked = !isIdBlocked;
                                      context.read<ProfileBloc>().blockUser(
                                          isIdBlocked, widget.userId);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Yes",
                                      style: TextStyle(
                                        color: kPrimaryBlackColor,
                                        fontFamily: kFontFamily,
                                        fontSize: 10.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: isIdBlocked
                              ? const Icon(Icons.lock)
                              : const Icon(Icons.lock_open),
                        )
                ],
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _Statistics(
                            count: state.posts.length.toString(),
                            label: "POSTS"),
                        Center(
                          child: Card(
                            elevation:
                                _animationStatus == AnimationStatus.dismissed
                                    ? 3
                                    : 3,
                            shape: const CircleBorder(),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _getCompletionRateColor(
                                    (state.user.completed + state.user.todo) !=
                                            0
                                        ? (((state.user.completed) * 100) /
                                            (state.user.completed +
                                                state.user.todo))
                                        : 0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Transform(
                                  alignment: FractionalOffset.center,
                                  transform: Matrix4.identity()
                                    ..setEntry(2, 3, 0.002)
                                    ..rotateY(math.pi * _animation.value),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (_animationStatus ==
                                          AnimationStatus.dismissed) {
                                        _animationController.forward();
                                      } else {
                                        _animationController.reverse();
                                      }
                                    },
                                    child: _animation.value <= 0.5
                                        ? SizedBox(
                                            height: 100.sp,
                                            width: 100.sp,
                                            child: DefaultShowcase(
                                              myKey: _one,
                                              title: "Profile Image",
                                              description:
                                                  "Tap on this to find completion rate",
                                              disposeOnTap: true,
                                              onTap: () {
                                                if (_animationStatus ==
                                                    AnimationStatus.dismissed) {
                                                  _animationController
                                                      .forward();
                                                } else {
                                                  _animationController
                                                      .reverse();
                                                }
                                              },
                                              child: UserProfileImage(
                                                iconRadius: 100.sp,
                                                radius: 38.sp,
                                                profileImageUrl:
                                                    state.user.profileImageUrl,
                                              ),
                                            ),
                                          )
                                        : Transform(
                                            alignment: Alignment.center,
                                            transform:
                                                Matrix4.rotationY(math.pi),
                                            child: SizedBox(
                                              height: 100.sp,
                                              width: 100.sp,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const Spacer(
                                                    flex: 1,
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Text(
                                                      (state.user.completed +
                                                                  state.user
                                                                      .todo) !=
                                                              0
                                                          ? (((state.user.completed) *
                                                                          100) /
                                                                      (state.user
                                                                              .completed +
                                                                          state
                                                                              .user
                                                                              .todo))
                                                                  .toStringAsFixed(
                                                                      1)
                                                                  .toString() +
                                                              "%"
                                                          : "0 %",
                                                      style: TextStyle(
                                                          fontSize: 26.sp,
                                                          fontFamily:
                                                              kFontFamily,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              kPrimaryWhiteColor),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    "COMPLETION\nRATE",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 11.sp,
                                                        fontFamily: kFontFamily,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            kPrimaryWhiteColor),
                                                  ),
                                                  const Spacer(
                                                    flex: 1,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _Statistics(
                                count: state.user.followers.toString(),
                                label: "FOLLOWERS"),
                            if (state.isCurrentUser) SizedBox(height: 2.h),
                            if (state.isCurrentUser)
                              _Statistics(
                                  count: state.user.following.toString(),
                                  label: "FOLLOWING"),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16),
                      child: ProfileInfo(
                        username: state.user.username,
                        bio: state.user.bio,
                        displayName: state.user.displayName,
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: ProfileButton(
                        isRequesting: state.isRequesting,
                        isCurrentUser: state.isCurrentUser,
                        isFollowing: state.isFollowing,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    // const SizedBox(
                    //   height: 16,
                    // ),
                    // ProfileStats(
                    //   isRequesting: state.isRequesting,
                    //   isCurrentUser: state.isCurrentUser,
                    //   isFollowing: state.isFollowing,
                    //   posts: state.posts.length,
                    //   followers: state.user.followers,
                    //   following: state.user.following,
                    //   userId: widget.userId,
                    // ),
                    Container(
                      height: 1.h,
                      color: kPrimaryWhiteColor,
                      child: Container(
                        height: 1.h,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(50),
                              bottomRight: Radius.circular(50),
                            ),
                            color: Colors.grey[50]),
                      ),
                    ),
                    Container(
                      height: 2.h,
                      color: kPrimaryWhiteColor,
                    ),
                    Container(
                      height: 1.h,
                      color: kPrimaryWhiteColor,
                      child: Container(
                          height: 1.h,
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50),
                              ),
                              color: Colors.grey[50])),
                    ),
                  ],
                ),
              ),
              SliverAppBar(
                backgroundColor: Colors.grey[50],
                floating: true,
                snap: true,
                automaticallyImplyLeading: false,
                centerTitle: false,
                pinned: true,
                elevation: 1,
                toolbarHeight: 0,
                bottom: TabBar(
                    indicatorColor: kPrimaryBlackColor,
                    controller: _controller,
                    isScrollable: false,
                    unselectedLabelStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 11.sp,
                      fontFamily: kFontFamily,
                      fontWeight: FontWeight.w500,
                    ),
                    unselectedLabelColor: Colors.grey,
                    labelColor: kPrimaryBlackColor,
                    labelStyle: TextStyle(
                      color: kPrimaryBlackColor,
                      fontSize: 11.sp,
                      fontFamily: kFontFamily,
                      fontWeight: FontWeight.w500,
                    ),
                    tabs: const [
                      Tab(
                        text: "Posts",
                      ),
                      Tab(
                        text: "Followers",
                      ),
                      Tab(
                        text: "Following",
                      ),
                    ]),
              ),
              SliverFillRemaining(
                child: TabBarView(
                  controller: _controller,
                  children: [
                    (state.isCurrentUser && state.posts.isEmpty)
                        ? Padding(
                            padding: const EdgeInsets.only(top: 64.0),
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    "Create your first post 🚀",
                                    style: TextStyle(
                                        color:
                                            kPrimaryBlackColor.withOpacity(0.7),
                                        fontFamily: kFontFamily,
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
                                          .updateSelectedItem(
                                              BottomNavItem.create);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      'Create Task',
                                      style: TextStyle(
                                          color: kPrimaryBlackColor,
                                          fontFamily: kFontFamily,
                                          fontSize: 9.5.sp),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final post = state.posts[index];
                                final date = post!.enddate.toDate();
                                final likedPostsState =
                                    context.watch<LikedPostsCubit>().state;
                                final isLiked = likedPostsState.likedPostIds
                                    .contains(post.id);
                                log(post.toString());
                                log("This is length of posts: " +
                                    state.posts.length.toString());
                                return Column(
                                  children: [
                                    Text(
                                      DateFormat("EEEE, MMMM d, y")
                                          .format(date),
                                      style: TextStyle(
                                          color: kPrimaryBlackColor,
                                          fontFamily: kFontFamily,
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
                                    const SizedBox(height: 32),
                                  ],
                                );
                              },
                              itemCount: state.posts.length,
                            ),
                          ),
                    ListFollowersFollowing(
                        textController: _textControllerFollowers,
                        isLoading: isLoadingFollowers,
                        isSearching: isSearchingFollowers,
                        searchResult: searchResultFollowers,
                        followers: followers),
                    ListFollowersFollowing(
                        textController: _textControllerFollowing,
                        isLoading: isLoadingFollowing,
                        isSearching: isSearchingFollowing,
                        searchResult: searchResultFollowing,
                        followers: following)
                  ],
                ),
              ),
            ],
          ),
        );
    }
  }
}

class _Statistics extends StatelessWidget {
  final String count;
  final String label;
  const _Statistics({
    Key? key,
    required this.count,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            count,
            style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                fontFamily: kFontFamily,
                color: kPrimaryBlackColor),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 8.5.sp,
                fontFamily: kFontFamily,
                fontWeight: FontWeight.w400,
                color: kPrimaryBlackColor),
          ),
        ],
      ),
    );
  }
}
