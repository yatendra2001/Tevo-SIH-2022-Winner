import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:tevo/screens/login/login_cubit/login_cubit.dart';
import 'package:tevo/screens/login/onboarding/registration_screen.dart';
import 'package:tevo/screens/login/widgets/phoneform_widget.dart';
import 'package:tevo/screens/login/widgets/standard_elevated_button.dart';
import 'package:tevo/utils/session_helper.dart';
import 'package:tevo/utils/theme_constants.dart';
import 'package:tevo/widgets/error_dialog.dart';
import 'package:timer_button/timer_button.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);
  static const String routeName = '/otp-screen';
  static Route route() {
    return PageTransition(
        settings: const RouteSettings(name: routeName),
        type: PageTransitionType.rightToLeft,
        child: const OtpScreen());
  }

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController _otpController = TextEditingController();
  bool isButtonNotActive = true;

  @override
  void initState() {
    SmsAutoFill().listenForCode();
    _otpController.addListener(() {
      final isButtonNotActive = _otpController.text.length != 6;
      setState(() {
        this.isButtonNotActive = isButtonNotActive;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, backgroundColor: Colors.grey[50]),
      resizeToAvoidBottomInset: false,
      body: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          if (state.status == LoginStatus.otpVerifying) {
            return Center(
                child: (Platform.isIOS)
                    ? CupertinoActivityIndicator(color: kPrimaryBlackColor)
                    : CircularProgressIndicator(color: kPrimaryBlackColor));
          } else if (state.status == LoginStatus.error) {
            showDialog(
              context: context,
              builder: (context) => ErrorDialog(content: state.failure.message),
            );
          }
          return SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        SizedBox(height: 4.h),
                        Text(
                          "okay, check your texts💬 - we sent you a security code",
                          style: TextStyle(fontSize: 20.sp),
                        ),
                        SizedBox(height: 2.h),
                        SizedBox(height: 8.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: PinFieldAutoFill(
                            controller: _otpController,
                            autoFocus: true,
                            decoration: UnderlineDecoration(
                              textStyle: TextStyle(
                                  fontSize: 10.sp, color: kPrimaryBlackColor),
                              colorBuilder: FixedColorBuilder(
                                  kPrimaryBlackColor.withOpacity(0.6)),
                              lineStrokeCap: StrokeCap.round,
                            ),
                            currentCode: _otpController.text,
                            onCodeSubmitted: (code) {},
                            onCodeChanged: (code) {
                              if (code!.length == 6) {
                                _otpController.text = code;
                                BlocProvider.of<LoginCubit>(context)
                                    .verifyOtp(otp: _otpController.text);
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 1.3.h),
                        _didntReceiveCodeMethod(),
                      ],
                    ),
                    StandardElevatedButton(
                      labelText: "Continue →",
                      onTap: () {
                        BlocProvider.of<LoginCubit>(context)
                            .verifyOtp(otp: _otpController.text);
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      isButtonNull: isButtonNotActive,
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _didntReceiveCodeMethod() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Didn't get the code? ",
          style: TextStyle(fontSize: 10.sp),
        ),
        TimerButton(
          label: 'Resend',
          onPressed: () {
            BlocProvider.of<LoginCubit>(context)
                .sendOtpOnPhone(phone: context.read<LoginCubit>().phone);
          },
          timeOutInSeconds: 30,
          disabledColor: Colors.grey[50]!,
          buttonType: ButtonType.FlatButton,
          disabledTextStyle: TextStyle(
              color: kPrimaryBlackColor.withOpacity(0.4), fontSize: 10.sp),
          activeTextStyle:
              TextStyle(color: kPrimaryBlackColor, fontSize: 10.sp),
        ),
      ],
    );
  }
}
