import 'package:flutter/material.dart';
import 'package:tevo/screens/events/create_screen.dart';
import 'package:tevo/screens/events/direct_to_payments.dart';
import 'package:tevo/screens/events/event_room_screen.dart';
import 'package:tevo/screens/events/event_room_task_screen.dart';
import 'package:tevo/screens/events/events_screen.dart';
import 'package:tevo/screens/feed_back_screen.dart';
import 'package:tevo/screens/likes_screen.dart';
import 'package:tevo/screens/login/onboarding/add_profile_photo_screen.dart';
import 'package:tevo/screens/login/onboarding/dob_screen.dart';
import 'package:tevo/screens/login/onboarding/follow_users_screen.dart';
import 'package:tevo/screens/login/onboarding/onboarding_pageview.dart';
import 'package:tevo/screens/login/onboarding/registration_screen.dart';
import 'package:tevo/screens/login/onboarding/username_screen.dart';
import 'package:tevo/screens/login/pageview.dart';
import 'package:tevo/screens/profile/followers_screen.dart';
import 'package:tevo/screens/profile/following_screen.dart';
import 'package:tevo/screens/profile_feedback_screen.dart';

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

      case LikesScreen.routeName:
        return LikesScreen.route(
          args: settings.arguments as LikesScreenArgs,
        );

      case EventsScreen.routeName:
        return EventsScreen.route();

      case FollowUsersScreen.routeName:
        return FollowUsersScreen.route();

      case CreateEventScreen.routeName:
        return CreateEventScreen.route();
      case EventRoomScreen.routeName:
        return EventRoomScreen.route(
          args: settings.arguments as EventRoomScreenArgs,
        );
      case FeedBackScreen.routeName:
        return FeedBackScreen.route(
          args: settings.arguments as FeedBackArgs,
        );
      case ProflileFeedbackScreen.routeName:
        return ProflileFeedbackScreen.route();
      case DirectToPayments.routeName:
        return DirectToPayments.route();
      case EventRoomTaskScreen.routeName:
        return EventRoomTaskScreen.route(
          args: settings.arguments as EventRoomTaskScreenArgs,
        );
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
