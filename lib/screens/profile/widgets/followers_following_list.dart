import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:tevo/models/models.dart';
import 'package:tevo/screens/profile/profile_screen.dart';
import 'package:tevo/utils/theme_constants.dart';

import '../../../widgets/widgets.dart';

class ListFollowersFollowing extends StatelessWidget {
  const ListFollowersFollowing({
    Key? key,
    required TextEditingController textController,
    required this.isLoading,
    required this.isSearching,
    required this.searchResult,
    required this.followers,
  })  : _textController = textController,
        super(key: key);

  final TextEditingController _textController;
  final bool isLoading;
  final bool isSearching;
  final List<User> searchResult;
  final List<User> followers;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontFamily: kFontFamily,
                    fontSize: 10.sp),
                controller: _textController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  focusColor: Colors.black,
                  fillColor: const Color(0xffF5F5F5),
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.white, width: 1.0),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.white, width: 1.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontFamily: kFontFamily,
                      fontSize: 10.sp),
                  hintText: 'Search Users @ John',
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.clear,
                      color: Colors.black38,
                      size: 21,
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
            isLoading
                ? Center(
                    child: CircularProgressIndicator(color: kPrimaryBlackColor),
                  )
                : isSearching == true
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  ProfileScreen.routeName,
                                  arguments: ProfileScreenArgs(
                                      userId: searchResult[index].id));
                            },
                            tileColor: Colors.grey[100],
                            leading: UserProfileImage(
                                iconRadius: 28.sp,
                                radius: 12.sp,
                                profileImageUrl:
                                    searchResult[index].profileImageUrl),
                            title: Text(searchResult[index].displayName),
                            subtitle: Text("@ ${searchResult[index].username}"),
                            // trailing: Text("Following Button"),
                          ),
                        ),
                        itemCount: searchResult.length,
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            minVerticalPadding: 16,
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  ProfileScreen.routeName,
                                  arguments: ProfileScreenArgs(
                                      userId: followers[index].id));
                            },
                            tileColor: Colors.white.withOpacity(0.8),
                            leading: UserProfileImage(
                                iconRadius: 40,
                                radius: 12,
                                profileImageUrl:
                                    followers[index].profileImageUrl),
                            title: Text(followers[index].displayName),
                            subtitle: Text("@ ${followers[index].username}"),
                          ),
                        ),
                        itemCount: followers.length,
                      )
          ],
        ),
      ),
    );
  }
}
