import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tevo/repositories/repositories.dart';
import 'package:tevo/screens/login/login_cubit/login_cubit.dart';
import 'package:tevo/screens/login/widgets/register.dart';
import 'package:tevo/screens/login/widgets/sign_in.dart';

import 'widgets/background_painter.dart';

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth-screen';
  static Route route() {
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (context, _, __) => BlocProvider<LoginCubit>(
        create: (_) =>
            LoginCubit(authRepository: context.read<AuthRepository>()),
        child: AuthScreen(),
      ),
    );
  }

  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  ValueNotifier<bool> showSignInPage = ValueNotifier<bool>(true);

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: CustomPaint(
              painter: BackgroundPainter(
                animation: _controller,
              ),
            ),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: ValueListenableBuilder<bool>(
                valueListenable: showSignInPage,
                builder: (context, value, child) {
                  return SizedBox.expand(
                    child: PageTransitionSwitcher(
                      reverse: !value,
                      duration: const Duration(milliseconds: 800),
                      transitionBuilder:
                          (child, animation, secondaryAnimation) {
                        return SharedAxisTransition(
                          animation: animation,
                          secondaryAnimation: secondaryAnimation,
                          transitionType: SharedAxisTransitionType.vertical,
                          fillColor: Colors.transparent,
                          child: child,
                        );
                      },
                      child: value
                          ? SignIn(
                              key: const ValueKey('SignIn'),
                              onRegisterClicked: () {
                                showSignInPage.value = false;
                                _controller.forward();
                              },
                            )
                          : Register(
                              key: const ValueKey('Register'),
                              onSignInPressed: () {
                                showSignInPage.value = true;
                                _controller.reverse();
                              },
                            ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
