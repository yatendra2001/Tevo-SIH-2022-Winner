import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:tevo/blocs/blocs.dart';
import 'package:tevo/blocs/simple_bloc_observer.dart';
import 'package:tevo/config/custom_router.dart';
import 'package:tevo/cubits/cubits.dart';
import 'package:tevo/keys/key.dart';
import 'package:tevo/repositories/repositories.dart';
import 'package:tevo/screens/create_post/bloc/create_post_bloc.dart';
import 'package:tevo/screens/login/login_cubit/login_cubit.dart';
import 'package:tevo/screens/screens.dart';
import 'package:tevo/utils/app_themes.dart';
import 'screens/create_post/bloc/create_post_bloc.dart';
import 'package:sizer/sizer.dart';
import 'screens/stream_chat/bloc/initialize_stream_chat/initialize_stream_chat_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  EquatableConfig.stringify = kDebugMode;
  Bloc.observer = SimpleBlocObserver();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  MyApp({Key? key}) : super(key: key);

  final client = StreamChatClient(
    streamChatApiKey,
    logLevel: Level.INFO,
  );

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AuthRepository>(
            create: (_) => AuthRepository(),
          ),
          RepositoryProvider<UserRepository>(
            create: (_) => UserRepository(),
          ),
          RepositoryProvider<StorageRepository>(
            create: (_) => StorageRepository(),
          ),
          RepositoryProvider<PostRepository>(
            create: (_) => PostRepository(),
          ),
          RepositoryProvider<NotificationRepository>(
            create: (_) => NotificationRepository(),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(
              create: (context) =>
                  AuthBloc(authRepository: context.read<AuthRepository>()),
            ),
            BlocProvider<LoginCubit>(
              create: (context) => LoginCubit(
                  authRepository: context.read<AuthRepository>(),
                  userRepository: context.read<UserRepository>()),
            ),
            BlocProvider<LikedPostsCubit>(
              create: (context) => LikedPostsCubit(
                postRepository: context.read<PostRepository>(),
                authBloc: context.read<AuthBloc>(),
              ),
            ),
            BlocProvider<CreatePostBloc>(
              create: (context) => CreatePostBloc(
                authBloc: context.read<AuthBloc>(),
                userRepository: context.read<UserRepository>(),
                postRepository: context.read<PostRepository>(),
              ),
            ),
            BlocProvider(
              create: (context) => InitializeStreamChatCubit(),
            ),
          ],
          child: Sizer(
            builder: (context, orientation, deviceType) => MaterialApp(
              builder: (context, child) => StreamChat(
                client: client,
                child: child,
              ),
              navigatorKey: navigatorKey,
              title: 'Flutter Tevo',
              debugShowCheckedModeBanner: false,
              theme: AppThemes.lightTheme,
              onGenerateRoute: CustomRouter.onGenerateRoute,
              initialRoute: SplashScreen.routeName,
            ),
          ),
        ));
  }
}
