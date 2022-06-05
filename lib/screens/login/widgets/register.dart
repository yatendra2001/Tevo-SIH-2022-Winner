import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:tevo/screens/login/login_cubit/login_cubit.dart';
import 'package:tevo/screens/login/widgets/phoneform_widget.dart';
import 'package:tevo/screens/screens.dart';
import 'package:tevo/utils/session_helper.dart';
import 'package:tevo/utils/theme_constants.dart';
import 'package:timer_button/timer_button.dart';

import '../../../widgets/widgets.dart';
import 'decoration_functions.dart';
import 'sign_in_up_bar.dart';
import 'title.dart';

class Register extends StatefulWidget {
  const Register({Key? key, this.onSignInPressed}) : super(key: key);

  final VoidCallback? onSignInPressed;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String? _genderRadioBtnVal;

  String? birthDateInString;

  DateTime? birthDate;
  bool isDateSelected = false;
  bool check = true;
  late TextEditingController _phoneNumberController;
  final TextEditingController _usernameController = TextEditingController();

  void _handleGenderChange(String? value) {
    setState(() {
      _genderRadioBtnVal = value;
    });
  }

  @override
  void initState() {
    _phoneNumberController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.centerLeft,
                child: LoginTitle(
                  title: "Let's Setup\n Your Account 🚀",
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: ListView(
                children: [
                  TextFormField(
                      controller: _usernameController,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "username can't be empty";
                        }
                        return null;
                      },
                      decoration:
                          registerInputDecoration(hintText: 'username*')),
                  const SizedBox(height: 32),
                  PhoneForm(
                    textColor: Colors.white,
                    phoneNumberController: _phoneNumberController,
                  ),
                  const SizedBox(height: 32),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'When did you first appeared on Earth 🌍?',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: kPrimaryBlackColor),
                              child: Padding(
                                padding: const EdgeInsets.all(9.0),
                                child: Text(
                                  isDateSelected
                                      ? "🎂 ${birthDateInString!} "
                                      : "🎂  mm/dd/yyyy",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              )),
                          onTap: () async {
                            final datePick = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100));
                            if (datePick != null && datePick != birthDate) {
                              setState(() {
                                birthDate = datePick;
                                isDateSelected = true;
                                // put it here
                                birthDateInString =
                                    "${birthDate!.month}/${birthDate!.day}/${birthDate!.year}"; // 08/14/2019
                              });
                              SessionHelper.dob = birthDateInString;
                              SessionHelper.gender = _genderRadioBtnVal;
                            }
                          }),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Gender',
                        style: TextStyle(
                            fontSize: 18,
                            height: 2,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                      Row(
                        children: <Widget>[
                          Radio<String>(
                            value: "Male",
                            activeColor: Colors.white,
                            groupValue: _genderRadioBtnVal,
                            onChanged: _handleGenderChange,
                          ),
                          const Text("Male",
                              style: TextStyle(color: Colors.white)),
                          Radio<String>(
                            activeColor: Colors.white,
                            value: "Female",
                            groupValue: _genderRadioBtnVal,
                            onChanged: _handleGenderChange,
                          ),
                          const Text("Female",
                              style: TextStyle(color: Colors.white)),
                          Radio<String>(
                            value: "Other",
                            activeColor: Colors.white,
                            groupValue: _genderRadioBtnVal,
                            onChanged: _handleGenderChange,
                          ),
                          const Text("Others",
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                  SignUpBar(
                    label: 'Sign up',
                    isLoading: false,
                    onPressed: () async {
                      if (_phoneNumberController.text.length == 10) {
                        check = await context.read<LoginCubit>().checkNumber(
                            _phoneNumberController.text,
                            newAccount: true);
                        if (check == false) {
                          flutterToast(
                            msg: 'Account Exists',
                          );
                        } else {
                          BlocProvider.of<LoginCubit>(context).sendOtpOnPhone(
                              phone: _phoneNumberController.text);
                          _otpBottomSheet(context);
                          flutterToast(
                            msg: 'Sending OTP',
                            position: ToastGravity.CENTER,
                          );
                        }
                      }
                    },
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      splashColor: Colors.white,
                      onTap: () {
                        widget.onSignInPressed?.call();
                      },
                      child: const Text(
                        'Sign in',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
                              .verifyOtp(otp: otp!, json: {
                            "uid": SessionHelper.uid,
                            "username": _usernameController.text,
                            "dateOfBirth": birthDateInString,
                            "gender": _genderRadioBtnVal,
                            "phoneNumber": "+91" + _phoneNumberController.text,
                            "followers": 0,
                            "following": 0,
                          });

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
}
