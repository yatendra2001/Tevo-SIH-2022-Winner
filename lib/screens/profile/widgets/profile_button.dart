import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  onPressed: () => Navigator.of(context).pushNamed(
                    EditProfileScreen.routeName,
                    arguments: EditProfileScreenArgs(context: context),
                  ),
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(fontSize: 9.5.sp, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(width: 7.w),
              Expanded(
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    Share.share(
                        '👋Hey-You should join us on Tevo. I share my everyday progress there on health, career and personal interests to stay inspired!.\n\nHere is the link:  \nhttps://app.tevo.social/download',
                        subject: 'Noobs Assemble!');
                  },
                  icon: const Icon(
                    Icons.share,
                    color: kPrimaryWhiteColor,
                    size: 19,
                  ),
                  label: Text(
                    'Share ',
                    style:
                        TextStyle(fontSize: 9.5.sp, color: kPrimaryWhiteColor),
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
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: isFollowing
                        ? Colors.grey[300]
                        : Theme.of(context).primaryColor,
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
                  child: Text(
                    isRequesting
                        ? 'Requested'
                        : isFollowing
                            ? 'Unfollow'
                            : 'Follow',
                    style: TextStyle(
                      fontSize: 9.5.sp,
                      color: isFollowing ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 7.w),
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
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
                  child: Text(
                    "Message",
                    style: TextStyle(
                      fontSize: 9.5.sp,
                      color:
                          isFollowing ? kPrimaryWhiteColor : kPrimaryBlackColor,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 4.w),
            ],
          );
  }
}
