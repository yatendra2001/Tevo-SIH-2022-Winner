import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

import 'package:tevo/screens/login/login_cubit/login_cubit.dart';
import 'package:tevo/screens/login/onboarding/dob_screen.dart';
import 'package:tevo/screens/login/widgets/standard_elevated_button.dart';
import 'package:tevo/utils/session_helper.dart';
import 'package:tevo/utils/theme_constants.dart';
import 'package:tevo/widgets/widgets.dart';

class UsernameScreen extends StatefulWidget {
  final PageController pageController;

  const UsernameScreen({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  @override
  State<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _usernameController.text = SessionHelper.username ?? "";
    _focusNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(height: 10.h),
                    Text(
                      "Your username",
                      style: TextStyle(fontSize: 15.sp),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "You can always change it later as per availability.",
                      style: TextStyle(fontSize: 8.5.sp),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      "Username must have atleast 4 characters.",
                      style: TextStyle(
                          fontSize: 8.5.sp, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 8.h),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: 8.h,
                                width: 50.w,
                                child: TextField(
                                  controller: _usernameController,
                                  focusNode: _focusNode,
                                  style: TextStyle(
                                      fontSize: 9.5.sp,
                                      color: kPrimaryBlackColor,
                                      fontWeight: FontWeight.w500),
                                  onChanged: (val) {
                                    BlocProvider.of<LoginCubit>(context)
                                        .checkUsername(val);
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      FontAwesomeIcons.at,
                                      size: 15.sp,
                                      color: kPrimaryBlackColor,
                                    ),
                                    suffixIcon: (state.usernameStatus ==
                                                UsernameStatus
                                                    .usernameAvailable &&
                                            _usernameController.text.isNotEmpty)
                                        ? const Icon(Icons.check_circle,
                                            color: Colors.green)
                                        : (state.usernameStatus ==
                                                    UsernameStatus
                                                        .usernameExists ||
                                                _usernameController
                                                    .text.isEmpty)
                                            ? const Icon(Icons.close_rounded,
                                                color: Colors.red)
                                            : null,
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
                                    hintText: "username",
                                    hintStyle: TextStyle(
                                        fontSize: 9.5.sp,
                                        color: kPrimaryBlackColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )),
                          ],
                        )),
                  ],
                ),
                StandardElevatedButton(
                  labelText: "Continue →",
                  onTap: () {
                    SessionHelper.username = _usernameController.text;
                    widget.pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn);
                  },
                  isButtonNull:
                      state.usernameStatus == UsernameStatus.usernameExists ||
                          _usernameController.text.isEmpty,
                ),
                Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom)),
              ],
            );
          },
        ),
      ),
    );
  }
}
