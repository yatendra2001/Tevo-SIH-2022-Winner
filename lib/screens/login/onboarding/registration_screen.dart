import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';
import 'package:tevo/screens/login/onboarding/username_screen.dart';
import 'package:tevo/screens/login/widgets/standard_elevated_button.dart';
import 'package:tevo/utils/session_helper.dart';
import 'package:tevo/utils/theme_constants.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);
  static const String routeName = '/registration-screen';
  static Route route() {
    return PageTransition(
        settings: const RouteSettings(name: routeName),
        type: PageTransitionType.rightToLeft,
        child: const RegistrationScreen());
  }

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _secondNameController = TextEditingController();
  bool isButtonNotActive1 = true;
  bool isButtonNotActive2 = true;

  @override
  void initState() {
    _firstNameController.addListener(() {
      final isButtonNotActive1 = _firstNameController.text.isEmpty;
      setState(() {
        this.isButtonNotActive1 = isButtonNotActive1;
      });
    });
    _secondNameController.addListener(() {
      final isButtonNotActive2 = _firstNameController.text.isEmpty;
      setState(() {
        this.isButtonNotActive2 = isButtonNotActive2;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SizedBox(height: 10.h),
                      Text(
                        "What's your full name?",
                        style: TextStyle(fontSize: 20.sp),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        "People use their real name at Tevo",
                        style: TextStyle(fontSize: 10.sp),
                      ),
                      SizedBox(height: 8.h),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 8.h,
                                width: 30.w,
                                child: TextField(
                                  controller: _firstNameController,
                                  autofocus: true,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: kPrimaryBlackColor,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: kPrimaryBlackColor,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: kPrimaryBlackColor,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    focusedErrorBorder:
                                        const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: kPrimaryBlackColor,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    filled: true,
                                    hintText: "First",
                                    hintStyle: TextStyle(
                                        fontSize: 12.sp,
                                        color: kPrimaryBlackColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              SizedBox(width: 4.w),
                              SizedBox(
                                height: 8.h,
                                width: 30.w,
                                child: TextField(
                                  controller: _secondNameController,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: kPrimaryBlackColor,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: kPrimaryBlackColor,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: kPrimaryBlackColor,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    focusedErrorBorder:
                                        const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: kPrimaryBlackColor,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    filled: true,
                                    hintText: "Last",
                                    hintStyle: TextStyle(
                                        fontSize: 12.sp,
                                        color: kPrimaryBlackColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              )
                            ],
                          )),
                    ],
                  ),
                  StandardElevatedButton(
                    labelText: "Continue →",
                    onTap: () {
                      Navigator.of(context).pushNamed(UsernameScreen.routeName);
                      SessionHelper.firstName = _firstNameController.text;
                      SessionHelper.lastName = _secondNameController.text;
                      SessionHelper.displayName = _firstNameController.text +
                          " " +
                          _secondNameController.text;
                    },
                    isButtonNull: isButtonNotActive1 || isButtonNotActive2,
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
