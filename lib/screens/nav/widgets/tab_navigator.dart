import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tevo/blocs/blocs.dart';
import 'package:tevo/config/custom_router.dart';
import 'package:tevo/cubits/cubits.dart';
import 'package:tevo/enums/enums.dart';
import 'package:tevo/repositories/repositories.dart';
import 'package:tevo/screens/create_post/bloc/create_post_bloc.dart';
import 'package:tevo/screens/feed/bloc/feed_bloc.dart';
import 'package:tevo/screens/notifications/bloc/notifications_bloc.dart';
import 'package:tevo/screens/profile/bloc/profile_bloc.dart';
import 'package:tevo/screens/screens.dart';
import 'package:tevo/screens/search/cubit/search_cubit.dart';

class TabNavigator extends StatelessWidget {
  static const String tabNavigatorRoot = '/';

  final GlobalKey<NavigatorState> navigatorKey;
  final BottomNavItem item;

  const TabNavigator({
    Key? key,
    required this.navigatorKey,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders();
    return Navigator(
      key: navigatorKey,
      initialRoute: tabNavigatorRoot,
      onGenerateInitialRoutes: (_, initialRoute) {
        return [
          MaterialPageRoute(
            settings: const RouteSettings(name: tabNavigatorRoot),
            builder: (context) => routeBuilders[initialRoute]!(context),
          )
        ];
      },
      onGenerateRoute: CustomRouter.onGenerateNestedRoute,
    );
  }

  Map<String, WidgetBuilder> _routeBuilders() {
    return {tabNavigatorRoot: (context) => _getScreen(context, item)};
  }

  Widget _getScreen(BuildContext context, BottomNavItem item) {
    switch (item) {
      case BottomNavItem.feed:
        return BlocProvider<FeedBloc>(
          create: (context) => FeedBloc(
            postRepository: context.read<PostRepository>(),
            authBloc: context.read<AuthBloc>(),
            likedPostsCubit: context.read<LikedPostsCubit>(),
          )..add(FeedFetchPosts()),
          child: FeedScreen(),
        );
      case BottomNavItem.search:
        return BlocProvider<SearchCubit>(
          create: (context) =>
              SearchCubit(userRepository: context.read<UserRepository>()),
          child: const SearchScreen(),
        );
      case BottomNavItem.create:
        return BlocProvider<CreatePostBloc>(
          create: (context) => CreatePostBloc(
            userRepository: context.read<UserRepository>(),
            authBloc: context.read<AuthBloc>(),
            postRepository: context.read<PostRepository>(),
          )..add(const GetTaskEvent()),
          child: const CreatePostScreen(),
        );
      // case BottomNavItem.notifications:
      //   return BlocProvider<NotificationsBloc>(
      //     create: (context) => NotificationsBloc(
      //       notificationRepository: context.read<NotificationRepository>(),
      //       authBloc: context.read<AuthBloc>(),
      //     ),
      //     child: const NotificationsScreen(),
      //   );
      case BottomNavItem.profile:
        return BlocProvider<ProfileBloc>(
          create: (_) => ProfileBloc(
            userRepository: context.read<UserRepository>(),
            postRepository: context.read<PostRepository>(),
            authBloc: context.read<AuthBloc>(),
            likedPostsCubit: context.read<LikedPostsCubit>(),
          )..add(
              ProfileLoadUser(userId: context.read<AuthBloc>().state.user!.uid),
            ),
          child: const ProfileScreen(),
        );
      default:
        return Scaffold();
    }
  }
}
