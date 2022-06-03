import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:tevo/screens/login/widgets/phoneform_widget.dart';
import 'package:tevo/screens/screens.dart';
import 'package:tevo/widgets/widgets.dart';
import 'package:timer_button/timer_button.dart';

import 'package:tevo/screens/login/login_cubit/login_cubit.dart';
import 'package:tevo/screens/login/widgets/sign_in_up_bar.dart';
import 'package:tevo/utils/session_helper.dart';
import 'package:tevo/utils/theme_constants.dart';

import 'title.dart';

class SignIn extends StatefulWidget {
  const SignIn({
    Key? key,
    this.onRegisterClicked,
  }) : super(key: key);

  final VoidCallback? onRegisterClicked;

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late TextEditingController _phoneNumberController;
  bool check = true;
  @override
  void initState() {
    _phoneNumberController = TextEditingController();
    _phoneNumberController.addListener(() async {
      if (_phoneNumberController.text.length == 10) {
        check = await context
            .read<LoginCubit>()
            .checkNumber(_phoneNumberController.text);
        if (check == false) {
          BlocProvider.of<LoginCubit>(context)
              .sendOtpOnPhone(phone: _phoneNumberController.text);
          _otpBottomSheet(context);
          flutterToast(msg: 'Sending OTP', position: ToastGravity.TOP);
          flutterToast(msg: 'Please Wait', position: ToastGravity.TOP);
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          const Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.centerLeft,
              child: LoginTitle(
                title: 'Welcome\nBack 🙌',
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: PhoneForm(
                    phoneNumberController: _phoneNumberController,
                    onSubmit: onSubmit,
                  ),
                ),
                const SizedBox(height: 32),
                SignInBar(
                  isLoading: false,
                  label: "Sign In",
                  onPressed: onSubmit,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    splashColor: Colors.white,
                    onTap: () {
                      widget.onRegisterClicked?.call();
                    },
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                        color: Palette.darkBlue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  onSubmit() {
    if (_phoneNumberController.text.length < 10) {
      flutterToast(msg: 'Invalid Number', position: ToastGravity.TOP);
    } else if (check == false) {
      BlocProvider.of<LoginCubit>(context)
          .sendOtpOnPhone(phone: _phoneNumberController.text);
      _otpBottomSheet(context);
      flutterToast(msg: 'Sending OTP', position: ToastGravity.CENTER);
    } else {
      flutterToast(msg: 'Authentication Failed', position: ToastGravity.TOP);
    }
  }
}

void _otpBottomSheet(context) {
  String? otp;
  showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      backgroundColor: kPrimaryTealColor,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.status == LoginStatus.submitting) {
              const Center(child: CircularProgressIndicator());
            } else if (state.status == LoginStatus.success) {
              Navigator.of(context).pushNamed(NavScreen.routeName);
            }
          },
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: PinFieldAutoFill(
                    autoFocus: true,
                    keyboardType: TextInputType.number,
                    decoration: const UnderlineDecoration(
                      textStyle: TextStyle(fontSize: 20, color: Colors.white),
                      colorBuilder: FixedColorBuilder(Colors.white),
                      lineStrokeCap: StrokeCap.square,
                    ),
                    currentCode: otp,
                    onCodeSubmitted: (code) {},
                    onCodeChanged: (code) {
                      if (code!.length == 6) {
                        otp = code;
                        BlocProvider.of<LoginCubit>(context)
                            .verifyOtp(otp: otp!);
                        FocusScope.of(context).requestFocus(FocusNode());
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: TimerButton(
                    label: 'Resend',
                    onPressed: () {
                      BlocProvider.of<LoginCubit>(context)
                          .sendOtpOnPhone(phone: SessionHelper.phone!);
                    },
                    timeOutInSeconds: 30,
                    activeTextStyle: const TextStyle(color: Colors.white),
                    disabledTextStyle:
                        const TextStyle(color: kPrimaryBlackColor),
                    color: kPrimaryBlackColor,
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
