import 'package:flutter/material.dart';
import 'package:tevo/screens/login/onboarding/add_profile_photo_screen.dart';
import 'package:tevo/screens/login/onboarding/dob_screen.dart';
import 'package:tevo/screens/login/onboarding/follow_users_screen.dart';
import 'package:tevo/screens/login/onboarding/onboarding_pageview.dart';
import 'package:tevo/screens/login/onboarding/registration_screen.dart';
import 'package:tevo/screens/login/onboarding/username_screen.dart';
import 'package:tevo/screens/login/pageview.dart';
import 'package:tevo/screens/profile/followers_screen.dart';
import 'package:tevo/screens/profile/following_screen.dart';

import 'package:tevo/screens/screens.dart';
import 'package:tevo/screens/stream_chat/ui/stream_chat_inbox.dart';

class CustomRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    print('Route: ${settings.name}');
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          settings: const RouteSettings(name: '/'),
          builder: (_) => const Scaffold(),
        );
      case SplashScreen.routeName:
        return SplashScreen.route();
      case FollowerScreen.routeName:
        return FollowerScreen.route(
            args: settings.arguments as FollowerScreenArgs);
      case FollowingScreen.routeName:
        return FollowingScreen.route(
          args: settings.arguments as FollowingScreenArgs,
        );

      case NavScreen.routeName:
        return NavScreen.route();
      case ProfileScreen.routeName:
        return ProfileScreen.route(
          args: settings.arguments as ProfileScreenArgs,
        );
      case Onboardingpageview.routeName:
        return Onboardingpageview.route();
      case LoginPageView.routeName:
        return LoginPageView.route();
      case EditProfileScreen.routeName:
        return EditProfileScreen.route(
          args: settings.arguments as EditProfileScreenArgs,
        );
      case SearchScreen.routeName:
        return SearchScreen.route(
          args: settings.arguments as SearchScreenArgs,
        );
      case CommentsScreen.routeName:
        return CommentsScreen.route(
          args: settings.arguments as CommentsScreenArgs,
        );
      case ChannelScreen.routeName:
        return ChannelScreen.route(
          args: settings.arguments as ChannelScreenArgs,
        );
      case StreamChatInbox.routeName:
        return StreamChatInbox.route();

      case FollowUsersScreen.routeName:
        return FollowUsersScreen.route();
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Something went wrong!'),
        ),
      ),
    );
  }
}
