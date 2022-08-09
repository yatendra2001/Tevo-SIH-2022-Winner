import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:tevo/helpers/helpers.dart';
import 'package:tevo/models/models.dart';
import 'package:tevo/repositories/repositories.dart';
import 'package:tevo/screens/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:tevo/screens/profile/bloc/profile_bloc.dart';
import 'package:tevo/utils/theme_constants.dart';
import 'package:tevo/widgets/custom_appbar.dart';
import 'package:tevo/widgets/widgets.dart';
import 'package:image_cropper/image_cropper.dart';

class EditProfileScreenArgs {
  final BuildContext context;

  const EditProfileScreenArgs({required this.context});
}

class EditProfileScreen extends StatelessWidget {
  static const String routeName = '/editProfile';

  static Route route({required EditProfileScreenArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<EditProfileCubit>(
        create: (_) => EditProfileCubit(
          userRepository: context.read<UserRepository>(),
          storageRepository: context.read<StorageRepository>(),
          profileBloc: args.context.read<ProfileBloc>(),
        ),
        child: EditProfileScreen(
            user: args.context.read<ProfileBloc>().state.user),
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final User user;

  EditProfileScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: customAppbar('Edit Profile'),
        body: BlocConsumer<EditProfileCubit, EditProfileState>(
          listener: (context, state) {
            if (state.status == EditProfileStatus.success) {
              Navigator.of(context).pop();
            } else if (state.status == EditProfileStatus.error) {
              showDialog(
                context: context,
                builder: (context) =>
                    ErrorDialog(content: state.failure.message),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  if (state.status == EditProfileStatus.submitting)
                    LinearProgressIndicator(
                      color: kPrimaryBlackColor,
                      backgroundColor: kPrimaryBlackColor.withOpacity(0.3),
                    ),
                  const SizedBox(height: 32.0),
                  GestureDetector(
                    onTap: () => _selectProfileImage(context),
                    child: Card(
                      elevation: 3,
                      shape: const CircleBorder(
                          side:
                              BorderSide(color: kPrimaryBlackColor, width: 3)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: UserProfileImage(
                          iconRadius: 80,
                          radius: 80.0,
                          profileImageUrl: user.profileImageUrl,
                          profileImage: state.profileImage,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            style: TextStyle(
                              color: kPrimaryBlackColor,
                              fontFamily: kFontFamily,
                              fontSize: 9.5.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            initialValue: user.username,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              labelStyle: TextStyle(
                                color: kPrimaryBlackColor,
                                fontSize: 9.5.sp,
                                fontFamily: kFontFamily,
                              ),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: kPrimaryBlackColor),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: kPrimaryBlackColor),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onChanged: (value) => context
                                .read<EditProfileCubit>()
                                .usernameChanged(value),
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return "Username cannot be empty";
                              } else if (value.trim().length < 4) {
                                return "Username cannot be less than four letter";
                              }

                              return null;
                            },
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          TextFormField(
                            style: TextStyle(
                              color: kPrimaryBlackColor,
                              fontFamily: kFontFamily,
                              fontSize: 9.5.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            initialValue: user.displayName,
                            decoration: InputDecoration(
                              labelText: 'Name',
                              labelStyle: TextStyle(
                                color: kPrimaryBlackColor,
                                fontFamily: kFontFamily,
                              ),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: kPrimaryBlackColor),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: kPrimaryBlackColor),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onChanged: (value) => context
                                .read<EditProfileCubit>()
                                .nameChanged(value),
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return "name cannot be empty";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            style: TextStyle(
                              color: kPrimaryBlackColor,
                              fontFamily: kFontFamily,
                              fontSize: 9.5.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            initialValue: user.bio,
                            maxLines: 3,
                            minLines: 3,
                            decoration: InputDecoration(
                              labelText: 'Bio',
                              labelStyle: TextStyle(
                                color: kPrimaryBlackColor,
                                fontSize: 9.5.sp,
                                fontFamily: kFontFamily,
                              ),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: kPrimaryBlackColor),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: kPrimaryBlackColor),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onChanged: (value) => context
                                .read<EditProfileCubit>()
                                .bioChanged(value),
                            validator: (value) => value!.trim().isEmpty
                                ? 'Bio cannot be empty.'
                                : null,
                          ),
                          const SizedBox(height: 28.0),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(8),
                              primary: Theme.of(context).primaryColor,
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontFamily: kFontFamily,
                              ),
                            ),
                            onPressed: () => _submitForm(
                              context,
                              state.status == EditProfileStatus.submitting,
                            ),
                            child: Text(
                              'Update',
                              style: TextStyle(
                                color: kPrimaryWhiteColor,
                                fontFamily: kFontFamily,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
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
      context.read<EditProfileCubit>().profileImageChanged(pickedFile);
    }
  }

  void _submitForm(BuildContext context, bool isSubmitting) async {
    FocusScope.of(context).requestFocus(FocusNode());
    final userNameAvaialable =
        await context.read<EditProfileCubit>().checkUsernameExists();
    if (userNameAvaialable == false) {
      flutterToast(msg: "Username exists");
    } else if (_formKey.currentState!.validate() && !isSubmitting) {
      context.read<EditProfileCubit>().submit();
    }
  }
}
