import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tevo/repositories/repositories.dart';
import 'package:tevo/screens/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:tevo/screens/login/login_screen.dart';
import 'package:tevo/screens/login/onboarding/add_profile_photo_screen.dart';
import 'package:tevo/screens/login/onboarding/dob_screen.dart';
import 'package:tevo/screens/login/onboarding/follow_users_screen.dart';
import 'package:tevo/screens/login/onboarding/registration_screen.dart';
import 'package:tevo/screens/login/onboarding/username_screen.dart';
import 'package:tevo/screens/profile/bloc/profile_bloc.dart';
import 'package:tevo/screens/screens.dart';
import 'package:tevo/utils/theme_constants.dart';

class Onboardingpageview extends StatefulWidget {
  static const routeName = '/Onboardingpageview';
  Onboardingpageview({Key? key}) : super(key: key);

  static Route route() {
    return PageRouteBuilder(
        settings: const RouteSettings(name: routeName),
        transitionDuration: const Duration(seconds: 0),
        pageBuilder: (context, _, __) => Onboardingpageview());
  }

  @override
  State<Onboardingpageview> createState() => _OnboardingpageviewState();
}

class _OnboardingpageviewState extends State<Onboardingpageview> {
  int _page = 0;

  final PageController _pageController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: _page != 0 && _page != 4
              ? AppBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.linear,
                        );
                      },
                      icon: Icon(Icons.arrow_back_ios_new_outlined)),
                  actions: _page == 3
                      ? [
                          TextButton(
                            onPressed: () {
                              _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeIn);
                            },
                            child: Text(
                              "Skip",
                              style: TextStyle(
                                color: kPrimaryBlackColor.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ]
                      : null,
                )
              : null,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              children: _buildPages(),
              controller: _pageController,
              onPageChanged: _onPageViewChange,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPages() {
    return [
      RegistrationScreen(
        pageController: _pageController,
      ),
      UsernameScreen(pageController: _pageController),
      DobScreen(pageController: _pageController),
      BlocProvider<EditProfileCubit>(
        create: (context) => EditProfileCubit(
          userRepository: context.read<UserRepository>(),
          storageRepository: context.read<StorageRepository>(),
          profileBloc: context.read<ProfileBloc>(),
        ),
        child: AddProfilePhotoScreen(
          pageController: _pageController,
        ),
      ),
      FollowUsersScreen()
    ];
  }

  _onPageViewChange(int value) {
    setState(() {
      _page = value;
    });
  }
}
