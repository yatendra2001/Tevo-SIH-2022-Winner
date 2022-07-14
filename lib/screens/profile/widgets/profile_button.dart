import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:tevo/screens/profile/bloc/profile_bloc.dart';
import 'package:tevo/screens/screens.dart';
import 'package:tevo/screens/stream_chat/models/chat_type.dart';
import 'package:tevo/utils/theme_constants.dart';

class ProfileButton extends StatelessWidget {
  final bool isCurrentUser;
  final bool isFollowing;
  final bool isRequesting;

  const ProfileButton({
    Key? key,
    required this.isCurrentUser,
    required this.isFollowing,
    required this.isRequesting,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isCurrentUser
        ? Row(
            children: [
              SizedBox(width: 4.w),
              Expanded(
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pushNamed(
                    EditProfileScreen.routeName,
                    arguments: EditProfileScreenArgs(context: context),
                  ),
                  icon: const Icon(
                    Icons.edit,
                    color: kPrimaryWhiteColor,
                    size: 19,
                  ),
                  label: Text(
                    'Edit Profile',
                    style: TextStyle(
                        fontSize: 9.5.sp,
                        fontFamily: kFontFamily,
                        color: Colors.white),
                  ),
                ),
              ),
              SizedBox(width: 7.w),
              Expanded(
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey[50],
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(color: Colors.grey)),
                  ),
                  onPressed: () {
                    Share.share(
                        '👋Hey-You should join us on Tevo. I share my everyday progress there on health, career and personal interests to stay inspired!.\n\nHere is the link:  \nhttps://app.tevo.social/download',
                        subject: 'Noobs Assemble!');
                  },
                  icon: const Icon(
                    Icons.share,
                    color: kPrimaryBlackColor,
                    size: 19,
                  ),
                  label: Text(
                    'Share ',
                    style: TextStyle(
                        fontSize: 9.5.sp,
                        fontFamily: kFontFamily,
                        color: kPrimaryBlackColor),
                  ),
                ),
              ),
              SizedBox(width: 4.w),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 4.w),
              Expanded(
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: isFollowing
                        ? Colors.grey[300]
                        : Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    if (isRequesting) {
                      context.read<ProfileBloc>().add(ProfileDeleteRequest());
                    } else {
                      isFollowing
                          ? context
                              .read<ProfileBloc>()
                              .add(ProfileUnfollowUser())
                          : context
                              .read<ProfileBloc>()
                              .add(ProfileFollowUser());
                    }
                  },
                  label: Text(
                    isRequesting
                        ? 'Requested'
                        : isFollowing
                            ? 'Unfollow'
                            : 'Follow',
                    style: TextStyle(
                      fontSize: 9.5.sp,
                      fontFamily: kFontFamily,
                      color: kPrimaryWhiteColor,
                    ),
                  ),
                  icon: Icon(
                    isFollowing
                        ? Icons.person_remove_outlined
                        : Icons.person_add_outlined,
                    color: kPrimaryWhiteColor,
                    size: 19,
                  ),
                ),
              ),
              SizedBox(width: 7.w),
              Expanded(
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey[50],
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(color: kPrimaryBlackColor)),
                  ),
                  onPressed: () =>
                      Navigator.of(context).pushNamed(ChannelScreen.routeName,
                          arguments: ChannelScreenArgs(
                            user: context.read<ProfileBloc>().state.user,
                            profileImage: context
                                .read<ProfileBloc>()
                                .state
                                .user
                                .profileImageUrl,
                            chatType: ChatType.oneOnOne,
                          )),
                  label: Text(
                    "Message",
                    style: TextStyle(
                      fontSize: 9.5.sp,
                      fontFamily: kFontFamily,
                      color: kPrimaryBlackColor,
                    ),
                  ),
                  icon: const Icon(
                    Linecons.paper_plane,
                    color: kPrimaryBlackColor,
                    size: 19,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
            ],
          );
  }
}
