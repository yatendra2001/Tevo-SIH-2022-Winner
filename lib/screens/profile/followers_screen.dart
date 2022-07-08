import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import 'package:tevo/cubits/cubits.dart';
import 'package:tevo/repositories/repositories.dart';
import 'package:tevo/screens/profile/bloc/profile_bloc.dart';
import 'package:tevo/screens/profile/profile_screen.dart';
import 'package:tevo/widgets/user_profile_image.dart';

import '../../blocs/blocs.dart';
import '../../models/user_model.dart';

class FollowerScreenArgs {
  final String userId;
  FollowerScreenArgs({
    required this.userId,
  });
}

class FollowerScreen extends StatefulWidget {
  static const routeName = 'follower_screen';
  final String userId;

  const FollowerScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  static Route route({required FollowerScreenArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<ProfileBloc>(
        create: (_) => ProfileBloc(
          userRepository: context.read<UserRepository>(),
          postRepository: context.read<PostRepository>(),
          authBloc: context.read<AuthBloc>(),
          likedPostsCubit: context.read<LikedPostsCubit>(),
        ),
        child: FollowerScreen(
          userId: args.userId,
        ),
      ),
    );
  }

  @override
  State<FollowerScreen> createState() => _FollowerScreenState();
}

class _FollowerScreenState extends State<FollowerScreen> {
  final TextEditingController _textController = TextEditingController();
  List<User> followers = [];
  List<User> searchResult = [];

  bool isLoading = true;
  bool isSearching = false;

  @override
  void initState() {
    getfollowers();
    _textController.addListener(() {
      if (isSearching == true && _textController.text.isEmpty) {
        setState(() {
          isSearching = false;
          searchResult = [];
        });
      } else if (isSearching == false && _textController.text.isNotEmpty) {
        for (var element in followers) {
          if (element.displayName.contains(_textController.text) ||
              element.username.contains(_textController.text)) {
            if (searchResult.contains(element) == false) {
              searchResult.add(element);
            }
          }
        }
        setState(() {
          isSearching = true;
        });
      }
    });
    super.initState();
  }

  getfollowers() async {
    followers = await context.read<ProfileBloc>().getFollowers(widget.userId);
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                PreferredSize(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: _textController,
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
                        hintStyle:
                            const TextStyle(fontWeight: FontWeight.normal),
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
                            _textController.clear();
                          },
                        ),
                      ),
                      textInputAction: TextInputAction.search,
                      textAlignVertical: TextAlignVertical.center,
                    ),
                  ),
                  preferredSize: Size(100, 100),
                ),
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : isSearching == true
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      ProfileScreen.routeName,
                                      arguments: ProfileScreenArgs(
                                          userId: searchResult[index].id));
                                },
                                tileColor: Colors.grey[100],
                                leading: UserProfileImage(
                                    iconRadius: 12,
                                    radius: 12,
                                    profileImageUrl:
                                        searchResult[index].profileImageUrl),
                                title: Text(searchResult[index].displayName),
                                subtitle:
                                    Text("@ ${searchResult[index].username}"),
                                trailing: Text("Following Button"),
                              ),
                            ),
                            itemCount: searchResult.length,
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      ProfileScreen.routeName,
                                      arguments: ProfileScreenArgs(
                                          userId: followers[index].id));
                                },
                                tileColor: Colors.grey[100],
                                leading: UserProfileImage(
                                    iconRadius: 12,
                                    radius: 12,
                                    profileImageUrl:
                                        followers[index].profileImageUrl),
                                title: Text(followers[index].displayName),
                                subtitle:
                                    Text("@ ${followers[index].username}"),
                                trailing: Text("Following Button"),
                              ),
                            ),
                            itemCount: followers.length,
                          )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
