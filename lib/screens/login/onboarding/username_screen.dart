import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';
import 'package:tevo/blocs/auth/auth_bloc.dart';
import 'package:tevo/repositories/wallet_repository/wallet_repo.dart';

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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 4.h),
                    Text(
                      "Your username",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontFamily: kFontFamily,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      "You can always change it later as per availability.",
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontFamily: kFontFamily,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        child: Center(
                          child: SizedBox(
                              height: 9.5.h,
                              width: 50.w,
                              child: TextField(
                                controller: _usernameController,
                                focusNode: _focusNode,
                                style: TextStyle(fontWeight: FontWeight.w400),
                                onChanged: (val) {
                                  BlocProvider.of<LoginCubit>(context)
                                      .checkUsername(val);
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    FontAwesomeIcons.at,
                                    color: kPrimaryBlackColor.withOpacity(0.8),
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
                                              _usernameController.text.isEmpty)
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
                                  focusedErrorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: kPrimaryBlackColor,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  filled: true,
                                  helperText: "*atleast 4 letters required",
                                  hintText: "username",
                                  hintStyle: TextStyle(
                                      fontFamily: kFontFamily,
                                      fontSize: 12.sp,
                                      color: kPrimaryBlackColor,
                                      fontWeight: FontWeight.w400),
                                ),
                              )),
                        )),
                  ],
                ),
                StandardElevatedButton(
                  isArrowButton: true,
                  labelText: "Continue",
                  onTap: () async {
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
