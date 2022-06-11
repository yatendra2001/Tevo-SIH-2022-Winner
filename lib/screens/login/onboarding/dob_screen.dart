import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';
import 'package:tevo/models/user_model.dart';
import 'package:tevo/repositories/user/user_repository.dart';
import 'package:tevo/screens/login/login_cubit/login_cubit.dart';
import 'package:tevo/screens/login/onboarding/add_profile_photo_screen.dart';
import 'package:tevo/screens/login/widgets/standard_elevated_button.dart';
import 'package:tevo/utils/session_helper.dart';
import 'package:tevo/utils/theme_constants.dart';

class DobScreen extends StatefulWidget {
  const DobScreen({Key? key}) : super(key: key);
  static const String routeName = '/dob-screen';
  static Route route() {
    return PageTransition(
        settings: const RouteSettings(name: routeName),
        type: PageTransitionType.rightToLeft,
        child: const DobScreen());
  }

  @override
  State<DobScreen> createState() => _DobScreenState();
}

class _DobScreenState extends State<DobScreen> {
  final TextEditingController _ageController = TextEditingController();
  bool isButtonNotActive = true;

  @override
  void initState() {
    _ageController.addListener(() {
      final isButtonNotActive = _ageController.text.isEmpty;
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
                      "How old are you? 🍰",
                      style: TextStyle(fontSize: 20.sp),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "It helps us personalising your experience and will not be visible on your profile.",
                      style: TextStyle(fontSize: 10.sp),
                    ),
                    SizedBox(height: 8.h),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        child: SizedBox(
                          height: 8.h,
                          width: 40.w,
                          child: TextField(
                            controller: _ageController,
                            keyboardType: TextInputType.number,
                            autofocus: true,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                FontAwesomeIcons.hashtag,
                                color: kPrimaryBlackColor,
                              ),
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
                              hintText: "your age",
                              hintStyle: TextStyle(
                                  fontSize: 12.sp,
                                  color: kPrimaryBlackColor,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        )),
                  ],
                ),
                StandardElevatedButton(
                  labelText: "Continue →",
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.grey[50],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side:
                              BorderSide(color: kPrimaryBlackColor, width: 2.0),
                        ),
                        title: Center(
                          child: Text(
                            "You're ${_ageController.text} years old. Is it correct?",
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400,
                              color: kPrimaryBlackColor,
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                "RE-ENTER AGE",
                                style: TextStyle(
                                  color: kPrimaryBlackColor,
                                ),
                              )),
                          TextButton(
                              onPressed: () async {
                                SessionHelper.age = _ageController.text;
                                UserRepository().setUser(
                                    user: User(
                                        id: SessionHelper.uid ?? "",
                                        username: SessionHelper.username ?? "",
                                        displayName:
                                            SessionHelper.displayName ?? "",
                                        profileImageUrl:
                                            SessionHelper.profileImageUrl ?? '',
                                        age: SessionHelper.age ?? '',
                                        phone: SessionHelper.phone ?? '',
                                        followers: 0,
                                        following: 0,
                                        bio: ""));
                                Navigator.of(context)
                                    .pushNamed(AddProfilePhotoScreen.routeName);
                              },
                              child: Text(
                                "YES, I'M ${_ageController.text}",
                                style: const TextStyle(
                                  color: kPrimaryBlackColor,
                                ),
                              )),
                        ],
                      ),
                    );
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
      ),
    );
  }
}
