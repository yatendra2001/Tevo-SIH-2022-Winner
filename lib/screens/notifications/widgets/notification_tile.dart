import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:tevo/enums/enums.dart';
import 'package:tevo/models/models.dart';
import 'package:tevo/screens/screens.dart';
import 'package:tevo/utils/theme_constants.dart';
import 'package:tevo/widgets/widgets.dart';
import 'package:intl/intl.dart';

class NotificationTile extends StatelessWidget {
  final Notif notification;

  const NotificationTile({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: ListTile(
        leading: UserProfileImage(
          radius: 18.0,
          iconRadius: 12,
          profileImageUrl: notification.fromUser.profileImageUrl,
        ),
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: notification.fromUser.username,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: kPrimaryBlackColor,
                    fontSize: 11.5.sp),
              ),
              const TextSpan(text: '  '),
              TextSpan(
                text: _getText(notification),
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: kPrimaryBlackColor,
                    fontSize: 11.5.sp),
              ),
            ],
          ),
        ),
        subtitle: Text(
          DateFormat('MMM d, ' 'yyyy' '--').add_jm().format(notification.date),
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w400,
            fontSize: 8.5.sp,
          ),
        ),
        trailing: _getTrailing(context, notification),
        onTap: () => Navigator.of(context).pushNamed(
          ProfileScreen.routeName,
          arguments: ProfileScreenArgs(userId: notification.fromUser.id),
        ),
      ),
    );
  }

  String _getText(Notif notification) {
    switch (notification.type) {
      case NotifType.like:
        return 'liked your post.';
      case NotifType.comment:
        return 'commented on your post.';
      case NotifType.follow:
        return 'followed you.';
      case NotifType.requestAccepted:
        return 'accepted your follow request.';
      default:
        return '';
    }
  }

  Widget _getTrailing(BuildContext context, Notif notif) {
    if (notification.type == NotifType.like) {
      return _getTrailingIcon(
          "https://cdn-icons.flaticon.com/png/512/3336/premium/3336149.png?token=exp=1657057179~hmac=087d27a537a334bfefdc36daa856612b");
    } else if (notification.type == NotifType.comment) {
      return _getTrailingIcon(
          "https://cdn-icons.flaticon.com/png/512/2939/premium/2939460.png?token=exp=1657057302~hmac=7ff825b8d586c7c0b6f14e2d890363ef");
      // return GestureDetector(
      //   onTap: () => Navigator.of(context).pushNamed(
      //     CommentsScreen.routeName,
      //     arguments: CommentsScreenArgs(post: notification.post!),
      //   ),
      //   child: SizedBox(
      //     height: 60,
      //     width: 60,
      //     child: PostView(post: notification.post!),
      //   ),
      // );
    } else if (notification.type == NotifType.follow) {
      return _getTrailingIcon(
          "https://cdn-icons-png.flaticon.com/512/2097/2097705.png");
    }
    return const SizedBox.shrink();
  }

  SizedBox _getTrailingIcon(String url) {
    return SizedBox(
      height: 3.h,
      width: 3.h,
      child: CachedNetworkImage(imageUrl: url),
    );
  }
}
