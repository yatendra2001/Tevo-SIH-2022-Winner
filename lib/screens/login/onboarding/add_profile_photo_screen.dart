import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

import 'package:tevo/helpers/image_helper.dart';
import 'package:tevo/models/user_model.dart';
import 'package:tevo/repositories/repositories.dart';
import 'package:tevo/screens/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:tevo/screens/login/login_cubit/login_cubit.dart';
import 'package:tevo/screens/login/onboarding/follow_users_screen.dart';
import 'package:tevo/screens/login/widgets/standard_elevated_button.dart';
import 'package:tevo/screens/profile/bloc/profile_bloc.dart';
import 'package:tevo/utils/session_helper.dart';
import 'package:tevo/utils/theme_constants.dart';

class AddProfilePhotoScreen extends StatefulWidget {
  final PageController pageController;
  const AddProfilePhotoScreen({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  @override
  State<AddProfilePhotoScreen> createState() => _AddProfilePhotoScreenState();
}

class _AddProfilePhotoScreenState extends State<AddProfilePhotoScreen> {
  final TextEditingController _profilePicChecker = TextEditingController();
  bool isButtonNotActive = true;
  File? profileImage;

  @override
  void initState() {
    _profilePicChecker.addListener(() {
      final isButtonNotActive = _profilePicChecker.text.isEmpty;
      setState(() {
        this.isButtonNotActive = isButtonNotActive;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Add a profile picture!",
              style: TextStyle(fontSize: 15.sp),
            ),
            BlocListener<LoginCubit, LoginState>(
              listener: (context, state) {
                if (state.profilePhotoStatus == ProfilePhotoStatus.uploading) {
                  Center(
                      child: Platform.isIOS
                          ? const CupertinoActivityIndicator()
                          : const CircularProgressIndicator());
                }
              },
              child: GestureDetector(
                onTap: () => _selectProfileImage(context),
                child: Card(
                    elevation: profileImage == null ? 5 : 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: const BorderSide(
                          color: kPrimaryBlackColor, width: 1.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(40.sp),
                      child: profileImage == null
                          ? Icon(FontAwesomeIcons.photoFilm, size: 45.sp)
                          : Image(image: FileImage(profileImage!)),
                    )),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                StandardElevatedButton(
                  labelText: "Continue →",
                  onTap: () async {
                    BlocProvider.of<LoginCubit>(context)
                        .updateProfilePhoto(profileImage);
                    widget.pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn);
                  },
                  isButtonNull: isButtonNotActive,
                ),
                SizedBox(height: 1.h),
                Text(
                  "This is visible to everyone",
                  style: TextStyle(fontSize: 8.sp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _selectProfileImage(BuildContext context) async {
    final pickedFile = await ImageHelper.pickImageFromGallery(
      context: context,
      cropStyle: CropStyle.circle,
      title: 'Profile Image',
    );
    if (pickedFile != null) {
      profileImage = pickedFile;
      _profilePicChecker.text = 'done';
      context.read<EditProfileCubit>().profileImageChanged(pickedFile);
    }
  }
}
