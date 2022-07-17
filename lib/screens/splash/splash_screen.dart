import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tevo/blocs/blocs.dart';
import 'package:tevo/screens/login/onboarding/onboarding_pageview.dart';
import 'package:tevo/screens/login/onboarding/registration_screen.dart';
import 'package:tevo/screens/login/pageview.dart';
import 'package:tevo/screens/login/welcome_screen.dart';
import 'package:tevo/screens/screens.dart';
import 'package:tevo/screens/stream_chat/cubit/initialize_stream_chat/initialize_stream_chat_cubit.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = '/splash';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => SplashScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocListener<AuthBloc, AuthState>(
        listenWhen: (prevState, state) => prevState.status != state.status,
        listener: (context, state) {
          if (state.status == AuthStatus.unauthenticated) {
            //Go to welcome screen
            Navigator.of(context).pushNamed(LoginPageView.routeName);
          } else if (state.status == AuthStatus.authenticated &&
              state.isUserExist == true) {
            //Go to navigation screen
            BlocProvider.of<InitializeStreamChatCubit>(context)
                .initializeStreamChat(context);
            Navigator.of(context).pushNamed(NavScreen.routeName);
          } else if (state.status == AuthStatus.authenticated &&
              state.isUserExist == false) {
            BlocProvider.of<InitializeStreamChatCubit>(context)
                .initializeStreamChat(context);
            Navigator.of(context).pushNamed(Onboardingpageview.routeName);
          }
        },
        child: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
