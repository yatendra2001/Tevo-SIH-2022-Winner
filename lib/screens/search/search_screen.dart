import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tevo/repositories/repositories.dart';
import 'package:tevo/screens/screens.dart';
import 'package:tevo/screens/search/cubit/search_cubit.dart';
import 'package:tevo/widgets/widgets.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = '/search';

  const SearchScreen({Key? key}) : super(key: key);

  static Route route() {
    return PageRouteBuilder(
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.linear;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      settings: const RouteSettings(name: routeName),
      pageBuilder: (_, __, ___) => BlocProvider<SearchCubit>(
        create: (context) =>
            SearchCubit(userRepository: context.read<UserRepository>()),
        child: SearchScreen(),
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
      child: Scaffold(
        appBar: PreferredSize(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _textController,
              autofocus: true,
              decoration: InputDecoration(
                iconColor: Colors.black,
                focusColor: Colors.black,
                fillColor: const Color(0xffF5F5F5),
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white, width: 1.0),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white, width: 1.0),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                hintStyle: const TextStyle(fontWeight: FontWeight.normal),
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
                return const Center(child: CircularProgressIndicator());
              case SearchStatus.loaded:
                return state.users.isNotEmpty
                    ? ListView.builder(
                        itemCount: state.users.length,
                        itemBuilder: (BuildContext context, int index) {
                          final user = state.users[index];
                          return ListTile(
                            leading: UserProfileImage(
                              radius: 22.0,
                              profileImageUrl: user.profileImageUrl,
                            ),
                            title: Text(
                              user.username,
                              style: const TextStyle(fontSize: 16.0),
                            ),
                            onTap: () => Navigator.of(context).pushNamed(
                              ProfileScreen.routeName,
                              arguments: ProfileScreenArgs(userId: user.id),
                            ),
                          );
                        },
                      )
                    : const CenteredText(text: 'No users found');
              default:
                return Center(child: Text('So Whom To Stalk....'));
            }
          },
        ),
      ),
    );
  }
}
