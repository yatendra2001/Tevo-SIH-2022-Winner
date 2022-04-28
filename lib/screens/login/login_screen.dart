import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tevo/repositories/repositories.dart';
import 'package:tevo/screens/login/cubit/login_cubit.dart';
import 'package:tevo/screens/screens.dart';
import 'package:tevo/widgets/widgets.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:tevo/repositories/repositories.dart';

// import '../../widgets/widgets.dart';
// import 'cubit/login_cubit.dart';

// class LoginScreen extends StatefulWidget {
//   static const String routeName = '/login';

//   static Route route() {
//     return PageRouteBuilder(
//       settings: const RouteSettings(name: routeName),
//       transitionDuration: const Duration(seconds: 0),
//       pageBuilder: (context, _, __) => BlocProvider<LoginCubit>(
//         create: (_) =>
//             LoginCubit(authRepository: context.read<AuthRepository>()),
//         child: LoginScreen(),
//       ),
//     );
//   }

//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final kHintTextStyle = const TextStyle(
//     color: Colors.white54,
//     fontFamily: 'OpenSans',
//   );

//   final kLabelStyle = const TextStyle(
//     color: Colors.white,
//     fontWeight: FontWeight.bold,
//     fontFamily: 'OpenSans',
//   );

//   final kBoxDecorationStyle = BoxDecoration(
//     color: const Color(0xFF6CA8F1),
//     borderRadius: BorderRadius.circular(10.0),
//     boxShadow: const [
//       BoxShadow(
//         color: Colors.black12,
//         blurRadius: 6.0,
//         offset: Offset(0, 2),
//       ),
//     ],
//   );

//   bool _rememberMe = false;

//   Widget _buildEmailTF() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Text(
//           'Email',
//           style: kLabelStyle,
//         ),
//         SizedBox(height: 10.0),
//         Container(
//           alignment: Alignment.centerLeft,
//           decoration: kBoxDecorationStyle,
//           height: 60.0,
//           child: TextField(
//             keyboardType: TextInputType.emailAddress,
//             style: TextStyle(
//               color: Colors.white,
//               fontFamily: 'OpenSans',
//             ),
//             decoration: InputDecoration(
//               border: InputBorder.none,
//               contentPadding: EdgeInsets.only(top: 14.0),
//               prefixIcon: Icon(
//                 Icons.email,
//                 color: Colors.white,
//               ),
//               hintText: 'Enter your Email',
//               hintStyle: kHintTextStyle,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildPasswordTF() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Text(
//           'Password',
//           style: kLabelStyle,
//         ),
//         SizedBox(height: 10.0),
//         Container(
//           alignment: Alignment.centerLeft,
//           decoration: kBoxDecorationStyle,
//           height: 60.0,
//           child: TextField(
//             obscureText: true,
//             style: const TextStyle(
//               color: Colors.white,
//               fontFamily: 'OpenSans',
//             ),
//             decoration: InputDecoration(
//               border: InputBorder.none,
//               contentPadding: EdgeInsets.only(top: 14.0),
//               prefixIcon: const Icon(
//                 Icons.lock,
//                 color: Colors.white,
//               ),
//               hintText: 'Enter your Password',
//               hintStyle: kHintTextStyle,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildForgotPasswordBtn() {
//     return Container(
//       alignment: Alignment.centerRight,
//       child: TextButton(
//         onPressed: () => print('Forgot Password Button Pressed'),
//         style: TextButton.styleFrom(padding: EdgeInsets.only(right: 0.0)),
//         child: Text(
//           'Forgot Password?',
//           style: kLabelStyle,
//         ),
//       ),
//     );
//   }

//   Widget _buildRememberMeCheckbox() {
//     return Container(
//       height: 20.0,
//       child: Row(
//         children: <Widget>[
//           Theme(
//             data: ThemeData(unselectedWidgetColor: Colors.white),
//             child: Checkbox(
//               value: _rememberMe,
//               checkColor: Colors.green,
//               activeColor: Colors.white,
//               onChanged: (value) {
//                 setState(() {
//                   _rememberMe = value!;
//                 });
//               },
//             ),
//           ),
//           Text(
//             'Remember me',
//             style: kLabelStyle,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLoginBtn() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 25.0),
//       width: double.infinity,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//             elevation: 5.0,
//             padding: const EdgeInsets.all(15.0),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(30.0),
//             ),
//             primary: Colors.white),
//         onPressed: () => print('Login Button Pressed'),
//         child: const Text(
//           'LOGIN',
//           style: TextStyle(
//             color: Color(0xFF527DAA),
//             letterSpacing: 1.5,
//             fontSize: 18.0,
//             fontWeight: FontWeight.bold,
//             fontFamily: 'OpenSans',
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSignInWithText() {
//     return Column(
//       children: <Widget>[
//         const Text(
//           '- OR -',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//         const SizedBox(height: 20.0),
//         Text(
//           'Sign in with',
//           style: kLabelStyle,
//         ),
//       ],
//     );
//   }

//   Widget _buildSocialBtn(Function() onTap, AssetImage logo) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: 60.0,
//         width: 60.0,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: Colors.white,
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.black26,
//               offset: Offset(0, 2),
//               blurRadius: 6.0,
//             ),
//           ],
//           image: DecorationImage(
//             image: logo,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSocialBtnRow() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 30.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: <Widget>[
//           _buildSocialBtn(
//             () => print('Login with Facebook'),
//             const AssetImage(
//               'assets/icons/facebook.jpeg',
//             ),
//           ),
//           _buildSocialBtn(
//             () => print('Login with Google'),
//             const AssetImage(
//               'assets/icons/google.jpeg',
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSignupBtn() {
//     return GestureDetector(
//       onTap: () => print('Sign Up Button Pressed'),
//       child: RichText(
//         text: const TextSpan(
//           children: [
//             TextSpan(
//               text: 'Don\'t have an Account? ',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 13.0,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//             TextSpan(
//               text: 'Sign Up',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 13.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<LoginCubit, LoginState>(
//       listener: (context, state) {
//         if (state.status == LoginStatus.error) {
//           showDialog(
//             context: context,
//             builder: (context) => ErrorDialog(content: state.failure.message),
//           );
//         }
//       },
//       builder: (context, state) {
//         return Scaffold(
//           body: AnnotatedRegion<SystemUiOverlayStyle>(
//             value: SystemUiOverlayStyle.light,
//             child: GestureDetector(
//               onTap: () => FocusScope.of(context).unfocus(),
//               child: Stack(
//                 children: <Widget>[
//                   Container(
//                     height: double.infinity,
//                     width: double.infinity,
//                     decoration: const BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                         colors: [
//                           Color(0xFF73AEF5),
//                           Color(0xFF61A4F1),
//                           Color(0xFF478DE0),
//                           Color(0xFF398AE5),
//                         ],
//                         stops: [0.1, 0.4, 0.7, 0.9],
//                       ),
//                     ),
//                   ),
//                   Container(
//                     height: double.infinity,
//                     child: SingleChildScrollView(
//                       physics: const AlwaysScrollableScrollPhysics(),
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 40.0,
//                         vertical: 120.0,
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           const Text(
//                             'tevo',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontFamily: 'OpenSans',
//                               fontSize: 50.0,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 15.0,
//                           ),
//                           const Text(
//                             'Share your progress!',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontFamily: 'OpenSans',
//                               fontSize: 20.0,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           const SizedBox(height: 30.0),
//                           _buildEmailTF(),
//                           const SizedBox(
//                             height: 30.0,
//                           ),
//                           _buildPasswordTF(),
//                           _buildForgotPasswordBtn(),
//                           _buildRememberMeCheckbox(),
//                           _buildLoginBtn(),
//                           _buildSignInWithText(),
//                           _buildSocialBtnRow(),
//                           _buildSignupBtn(),
//                         ],
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';

  static Route route() {
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (context, _, __) => BlocProvider<LoginCubit>(
        create: (_) =>
            LoginCubit(authRepository: context.read<AuthRepository>()),
        child: LoginScreen(),
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.status == LoginStatus.error) {
              showDialog(
                context: context,
                builder: (context) =>
                    ErrorDialog(content: state.failure.message),
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'TEVO',
                              style: TextStyle(
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12.0),
                            TextFormField(
                              decoration: InputDecoration(hintText: 'Email'),
                              onChanged: (value) => context
                                  .read<LoginCubit>()
                                  .emailChanged(value),
                              validator: (value) => !value!.contains('@')
                                  ? 'Please enter a valid email.'
                                  : null,
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              decoration: InputDecoration(hintText: 'Password'),
                              obscureText: true,
                              onChanged: (value) => context
                                  .read<LoginCubit>()
                                  .passwordChanged(value),
                              validator: (value) => value!.length < 6
                                  ? 'Must be at least 6 characters.'
                                  : null,
                            ),
                            const SizedBox(height: 28.0),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                                textStyle: const TextStyle(color: Colors.white),
                              ),
                              onPressed: () => _submitForm(
                                context,
                                state.status == LoginStatus.submitting,
                              ),
                              child: const Text('Log In'),
                            ),
                            const SizedBox(height: 12.0),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.grey[200],
                              ),
                              onPressed: () => Navigator.of(context)
                                  .pushNamed(SignupScreen.routeName),
                              child: const Text(
                                'No account? Sign up',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return BlocConsumer<LoginCubit, LoginState>(
  //     listener: (context, state) {
  //       if (state.status == LoginStatus.error) {
  //         showDialog(
  //           context: context,
  //           builder: (context) => ErrorDialog(content: state.failure.message),
  //         );
  //       }
  //     },
  //     builder: (context, state) {
  //       return Scaffold(
  //         resizeToAvoidBottomInset: false,
  //         body: AnnotatedRegion<SystemUiOverlayStyle>(
  //           value: SystemUiOverlayStyle.light,
  //           child: GestureDetector(
  //             onTap: () => FocusScope.of(context).unfocus(),
  //             child: Stack(
  //               children: <Widget>[
  //                 Container(
  //                   height: double.infinity,
  //                   width: double.infinity,
  //                   decoration: const BoxDecoration(
  //                     gradient: LinearGradient(
  //                       begin: Alignment.topCenter,
  //                       end: Alignment.bottomCenter,
  //                       colors: [
  //                         Color(0xFF73AEF5),
  //                         Color(0xFF61A4F1),
  //                         Color(0xFF478DE0),
  //                         Color(0xFF398AE5),
  //                       ],
  //                       stops: [0.1, 0.4, 0.7, 0.9],
  //                     ),
  //                   ),
  //                 ),
  //                 Center(
  //                   child: SizedBox(
  //                     height: double.infinity,
  //                     width: MediaQuery.of(context).size.width * 0.9,
  //                     child: Column(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: <Widget>[
  //                         const Text(
  //                           'tevo',
  //                           style: TextStyle(
  //                             color: Colors.white,
  //                             fontFamily: 'OpenSans',
  //                             fontSize: 50.0,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                         const SizedBox(
  //                           height: 15.0,
  //                         ),
  //                         const Text(
  //                           'Share your progress!',
  //                           style: TextStyle(
  //                             color: Colors.white,
  //                             fontFamily: 'OpenSans',
  //                             fontSize: 20.0,
  //                             fontWeight: FontWeight.w500,
  //                           ),
  //                         ),
  //                         const SizedBox(height: 30.0),
  //                         _buildPhoneTF(),
  //                         const SizedBox(
  //                           height: 30.0,
  //                         ),
  //                         _buildContinueBtn(),
  //                         _buildSignInWithText(),
  //                         _buildSocialBtnRow(),
  //                       ],
  //                     ),
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  void _submitForm(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState!.validate() && !isSubmitting) {
      context.read<LoginCubit>().logInWithCredentials();
    }
  }
}
