import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

import 'package:tevo/models/user_model.dart';
import 'package:tevo/repositories/repositories.dart';
import 'package:tevo/screens/profile/profile_screen.dart';
import 'package:tevo/utils/theme_constants.dart';
import 'package:tevo/widgets/custom_appbar.dart';
import 'package:tevo/widgets/user_profile_image.dart';

class LikesScreenArgs {
  final String postId;
  LikesScreenArgs({
    required this.postId,
  });
}

class LikesScreen extends StatefulWidget {
  static const routeName = 'likeScreen';
  final String postId;

  const LikesScreen({
    Key? key,
    required this.postId,
  }) : super(key: key);

  static Route route({required LikesScreenArgs args}) {
    return PageTransition(
      settings: const RouteSettings(name: routeName),
      type: PageTransitionType.rightToLeft,
      child: LikesScreen(postId: args.postId),
    );
  }

  @override
  State<LikesScreen> createState() => _LikesScreenState();
}

class _LikesScreenState extends State<LikesScreen> {
  List<User> likedBy = [];
  bool isLoading = false;

  @override
  void initState() {
    fun();
    super.initState();
  }

  fun() async {
    isLoading = true;
    setState(() {});
    likedBy = await context.read<UserRepository>().postLikeUsers(widget.postId);
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar("Liked By"),
      body: isLoading
          ? const Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : likedBy.isEmpty
              ? Center(
                  child: Text(
                    "No Likes Yet",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: kFontFamily,
                      color: kPrimaryBlackColor.withOpacity(0.5),
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).pushNamed(ProfileScreen.routeName,
                            arguments:
                                ProfileScreenArgs(userId: likedBy[index].id));
                      },
                      leading: UserProfileImage(
                          iconRadius: 12,
                          radius: 12,
                          profileImageUrl: likedBy[index].profileImageUrl),
                      title: Text(
                        likedBy[index].displayName,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: kFontFamily,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        "@ ${likedBy[index].username}",
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontFamily: kFontFamily,
                          fontWeight: FontWeight.w300,
                          color: kPrimaryBlackColor.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                  itemCount: likedBy.length,
                ),
    );
  }
}
