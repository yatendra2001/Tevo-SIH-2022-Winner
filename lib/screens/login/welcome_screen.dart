import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:tevo/repositories/repositories.dart';
import 'package:tevo/screens/login/login_cubit/login_cubit.dart';
import 'package:tevo/screens/login/widgets/standard_elevated_button.dart';
import 'package:tevo/screens/screens.dart';
import 'package:tevo/utils/theme_constants.dart';

class WelcomeScreen extends StatefulWidget {
  static const String routeName = '/welcome-screen';
  static Route route() {
    return PageRouteBuilder(
        settings: const RouteSettings(name: routeName),
        transitionDuration: const Duration(seconds: 0),
        pageBuilder: (context, _, __) => WelcomeScreen());
  }

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 35.h),
                AnimatedTextKit(
                  animatedTexts: [
                    WavyAnimatedText('TEVO',
                        textStyle: TextStyle(
                            fontSize: 50.sp,
                            color: kPrimaryBlackColor,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 10.sp)),
                  ],
                  isRepeatingAnimation: true,
                  totalRepeatCount: 5,
                ),
                SizedBox(height: 40.h),
                StandardElevatedButton(
                  labelText: "🍾  Come on in! →",
                  onTap: () {
                    Navigator.pushNamed(context, LoginScreen.routeName);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
