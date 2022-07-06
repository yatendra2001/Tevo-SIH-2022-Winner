import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'package:tevo/screens/login/login_cubit/login_cubit.dart';
import 'package:tevo/screens/login/otp_screen.dart';
import 'package:tevo/screens/login/widgets/phoneform_widget.dart';
import 'package:tevo/screens/login/widgets/standard_elevated_button.dart';
import 'package:tevo/utils/session_helper.dart';
import 'package:tevo/utils/theme_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  final PageController controller;
  const LoginScreen({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  bool isButtonNotActive = true;

  @override
  void initState() {
    _textEditingController.text =
        SessionHelper.phone?.replaceAll("+91", "") ?? "";
    _textEditingController.addListener(() {
      final isButtonNotActive = _textEditingController.text.length != 10;
      setState(() {
        this.isButtonNotActive = isButtonNotActive;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(height: 4.h),
                  Text(
                    "Sign in with your phone number",
                    style: TextStyle(fontSize: 15.sp),
                  ),
                  SizedBox(height: 3.h),
                  Container(
                    height: 6.h,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: DefaultTextStyle(
                        style: TextStyle(
                          color: kPrimaryBlackColor,
                          fontSize: 10.sp,
                        ),
                        textAlign: TextAlign.center,
                        child: _animatedQuotedTextsMethod(),
                      ),
                    ),
                  ),
                  SizedBox(height: 6.5.h),
                  PhoneForm(textEditingController: _textEditingController),
                  SizedBox(height: 1.h),
                  _termsAndPrivacyPolicy(),
                ],
              ),
              SizedBox(height: 2.5.h),
              StandardElevatedButton(
                  labelText: "Continue →",
                  onTap: () {
                    widget.controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn);
                    BlocProvider.of<LoginCubit>(context).sendOtpOnPhone(
                        phone: context.read<LoginCubit>().phone);
                    SessionHelper.phone = context.read<LoginCubit>().phone;
                  },
                  isButtonNull: isButtonNotActive),
              Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom)),
            ],
          ),
        ),
      ),
    );
  }

  RichText _termsAndPrivacyPolicy() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: "By continuing you agree to our ",
            style: TextStyle(
                color: kPrimaryBlackColor.withOpacity(0.6),
                fontSize: 7.sp,
                fontWeight: FontWeight.w600),
          ),
          // TextSpan(
          //     text: "Terms",
          //     style: TextStyle(
          //         color: Colors.blue,
          //         fontSize: 7.sp,
          //         fontWeight: FontWeight.w600),
          //     recognizer: TapGestureRecognizer()
          //       ..onTap = () {
          //         const url = '';
          //         print("Terms tapped");
          //         // if (await canLaunch(url)) {
          //         //   await launch(url);
          //         // } else {
          //         //   throw 'Could not launch $url';
          //         // }
          //       }),
          // TextSpan(
          //   text: " and ",
          //   style: TextStyle(
          //       color: kPrimaryBlackColor.withOpacity(0.6),
          //       fontSize: 7.sp,
          //       fontWeight: FontWeight.w600),
          // ),
          TextSpan(
              text: "Privacy Policy",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 7.sp,
                  fontWeight: FontWeight.w600),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  const url =
                      'https://docs.google.com/document/d/1I-HN3dkIZPssPKQEi_5tLnNFJq8bQVqFvv6gINBEgbk/edit';
                  print("Terms tapped");
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchURL(context, url);
                  } else {
                    throw 'Could not launch $url';
                  }
                }),
        ],
      ),
    );
  }

  AnimatedTextKit _animatedQuotedTextsMethod() {
    return AnimatedTextKit(
      pause: const Duration(seconds: 1),
      repeatForever: true,
      animatedTexts: [
        RotateAnimatedText(
            'Life Before Death. Strength Before Weakness. Journey Before Destination.  - Brandon Sanderson📚',
            duration: const Duration(seconds: 3),
            textStyle: TextStyle(fontSize: 8.5.sp)),
        RotateAnimatedText('The journey is the reward. - Steve Jobs🍎',
            duration: const Duration(seconds: 3),
            textStyle: TextStyle(fontSize: 8.5.sp)),
        RotateAnimatedText(
            'Process is more important than tesult. - MS Dhoni🏏',
            duration: const Duration(seconds: 3),
            textStyle: TextStyle(fontSize: 8.5.sp)),
        RotateAnimatedText(
            'How you climb a mountain is more important than reaching the top. - Yvon Chouinard🧗',
            duration: const Duration(seconds: 3),
            textStyle: TextStyle(fontSize: 8.5.sp)),
      ],
    );
  }
}
