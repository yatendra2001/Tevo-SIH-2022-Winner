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
  final PageController controller;

  const WelcomeScreen({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 35.h),
            AnimatedTextKit(
              animatedTexts: [
                WavyAnimatedText('TEVO',
                    textStyle: TextStyle(
                        fontSize: 50.sp,
                        fontFamily: kFontFamily,
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
                widget.controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn);
              },
            ),
          ],
        ),
      ),
    );
  }
}
