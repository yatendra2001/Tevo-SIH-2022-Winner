import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tevo/screens/profile/bloc/profile_bloc.dart';
import 'package:tevo/screens/screens.dart';
import 'package:tevo/screens/stream_chat/models/chat_type.dart';

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
        ? TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
            ),
            onPressed: () => Navigator.of(context).pushNamed(
              EditProfileScreen.routeName,
              arguments: EditProfileScreenArgs(context: context),
            ),
            child: const Text(
              'Edit Profile',
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
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
                        ? context.read<ProfileBloc>().add(ProfileUnfollowUser())
                        : context.read<ProfileBloc>().add(ProfileFollowUser());
                  }
                },
                child: Text(
                  isRequesting
                      ? 'Requested'
                      : isFollowing
                          ? 'Unfollow'
                          : 'Follow',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: isFollowing ? Colors.black : Colors.white,
                  ),
                ),
              ),
              TextButton(
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
                    fontSize: 16.0,
                    color: isFollowing ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ],
          );
  }
}
