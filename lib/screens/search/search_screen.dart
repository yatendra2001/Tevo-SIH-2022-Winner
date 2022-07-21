import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

import 'package:tevo/repositories/repositories.dart';
import 'package:tevo/screens/screens.dart';
import 'package:tevo/screens/search/cubit/search_cubit.dart';
import 'package:tevo/screens/stream_chat/models/chat_type.dart';
import 'package:tevo/utils/theme_constants.dart';
import 'package:tevo/widgets/widgets.dart';

import '../profile/bloc/profile_bloc.dart';

enum SearchScreenType { profile, message }

class SearchScreenArgs {
  final SearchScreenType type;
  SearchScreenArgs({
    required this.type,
  });
}

class SearchScreen extends StatefulWidget {
  static const String routeName = '/search';
  final SearchScreenType type;

  const SearchScreen({
    Key? key,
    required this.type,
  }) : super(key: key);

  static Route route({required SearchScreenArgs args}) {
    return PageTransition(
      type: PageTransitionType.rightToLeft,
      settings: const RouteSettings(name: routeName),
      child: BlocProvider<SearchCubit>(
        create: (context) =>
            SearchCubit(userRepository: context.read<UserRepository>()),
        child: SearchScreen(
          type: args.type,
        ),
      ),
    );
  }

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _textController,
                autofocus: true,
                style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: kFontFamily,
                    fontWeight: FontWeight.w400),
                decoration: InputDecoration(
                  focusColor: Colors.black,
                  fillColor: const Color(0xffF5F5F5),
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.white, width: 1.0),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.white, width: 1.0),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontFamily: kFontFamily,
                  ),
                  hintText: 'Search Users @ John',
                  prefixIcon: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.black38,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.clear,
                      color: Colors.black38,
                    ),
                    onPressed: () {
                      context.read<SearchCubit>().clearSearch();
                      _textController.clear();
                    },
                  ),
                ),
                textInputAction: TextInputAction.search,
                textAlignVertical: TextAlignVertical.center,
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    context.read<SearchCubit>().searchUsers(value.trim());
                  }
                },
              ),
            ),
            preferredSize: Size(100, 100),
          ),
          body: BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              switch (state.status) {
                case SearchStatus.error:
                  return CenteredText(text: state.failure.message);
                case SearchStatus.loading:
                  return const Center(
                      child:
                          CircularProgressIndicator(color: kPrimaryBlackColor));
                case SearchStatus.loaded:
                  return state.users.isNotEmpty
                      ? ListView.builder(
                          itemCount: state.users.length,
                          itemBuilder: (BuildContext context, int index) {
                            final user = state.users[index];
                            return ListTile(
                              leading: UserProfileImage(
                                iconRadius: 48,
                                radius: 15.0,
                                profileImageUrl: user.profileImageUrl,
                              ),
                              title: Text(
                                user.displayName,
                                style: TextStyle(
                                    fontSize: 10.sp,
                                    fontFamily: kFontFamily,
                                    fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                "@" + user.username,
                                style: TextStyle(
                                    fontSize: 8.sp,
                                    fontFamily: kFontFamily,
                                    fontWeight: FontWeight.w400),
                              ),
                              onTap: () => widget.type ==
                                      SearchScreenType.message
                                  ? Navigator.of(context)
                                      .pushNamed(ChannelScreen.routeName,
                                          arguments: ChannelScreenArgs(
                                            user: user,
                                            profileImage: user.profileImageUrl,
                                            chatType: ChatType.oneOnOne,
                                          ))
                                  : Navigator.of(context).pushNamed(
                                      ProfileScreen.routeName,
                                      arguments:
                                          ProfileScreenArgs(userId: user.id),
                                    ),
                            );
                          },
                        )
                      : const CenteredText(text: 'No users found');
                default:
                  return Center(
                      child: Text(
                    widget.type == SearchScreenType.profile
                        ? 'Find People....'
                        : 'So Whom you wanna chat with...',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontFamily: kFontFamily,
                    ),
                  ));
              }
            },
          ),
        ),
      ),
    );
  }
}
