import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';
import 'package:tevo/extensions/string_extension.dart';
import 'package:tevo/repositories/user/user_repository.dart';
import 'package:tevo/screens/stream_chat/cubit/initialize_stream_chat/initialize_stream_chat_cubit.dart';
import 'package:tevo/screens/stream_chat/ui/widgets/dm_inbox.dart';
import 'package:tevo/screens/stream_chat/ui/widgets/groups_inbox.dart';
import 'package:tevo/utils/session_helper.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:tevo/utils/theme_constants.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../search/search_screen.dart';
import 'channel_screen.dart';

class StreamChatInboxArgs {
  const StreamChatInboxArgs();
}

class StreamChatInbox extends StatefulWidget {
  static const String routeName = '/stream-chat-inbox-screen';
  const StreamChatInbox({Key? key}) : super(key: key);

  static Route route() {
    return PageTransition(
      settings: const RouteSettings(name: routeName),
      type: PageTransitionType.rightToLeft,
      child: BlocProvider(
        create: (context) => InitializeStreamChatCubit(),
        child: const StreamChatInbox(),
      ),
    );
  }

  @override
  _StreamChatInboxState createState() => _StreamChatInboxState();
}

class _StreamChatInboxState extends State<StreamChatInbox> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryWhiteColor,
        toolbarHeight: 8.h,
        title: Text(
          'Chat',
          style: TextStyle(fontSize: 20.sp),
        ),
        elevation: 0,
        centerTitle: false,
      ),
      body: DmInbox(),
      floatingActionButton: FloatingActionButton(
          backgroundColor: kPrimaryBlackColor,
          onPressed: () {
            Navigator.of(context).pushNamed(SearchScreen.routeName,
                arguments: SearchScreenArgs(type: SearchScreenType.message));
          },
          child: Icon(
            Icons.add,
            size: 30,
          )),
    );
  }
}

class InboxListItem extends StatefulWidget {
  final Channel channel;
  const InboxListItem({Key? key, required this.channel}) : super(key: key);

  @override
  State<InboxListItem> createState() => _InboxListItemState();
}

class _InboxListItemState extends State<InboxListItem> {
  List<Member> members = [];
  String image = '';
  int unreadCount = 0;
  String targetDisplayName = '';
  getAllMembers() async {
    var membersResponse = await widget.channel.queryMembers();
    members = membersResponse.members;
    log('INBOX PROFILE IMAGE:: $image');
    members.forEach((member) async {
      log('MEMBER IMAGE:: ${member.user!.image}');
      final user =
          await UserRepository().getUserWithId(userId: member.user!.id);
      setState(() {
        image = widget.channel.image!;
        targetDisplayName =
            widget.channel.extraData['chat_type'] == 'one_on_one'
                ? member.user!.name
                : widget.channel.name ?? '';
      });
    });

    log("Members: $members");
  }

  @override
  void initState() {
    log('CHANNEL:: ${widget.channel.name}');
    log('${SessionHelper.displayName}');
    getAllMembers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        Navigator.of(context).pushNamed(ChannelScreen.routeName,
            arguments: ChannelScreenArgs(
                channel: widget.channel,
                profileImage: image,
                chatType: widget.channel.extraData['chat_type'].toString()));
      },
      child: Container(
        height: 68,
        padding: const EdgeInsets.symmetric(vertical: 8),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
                color: kPrimaryBlackColor.withOpacity(0.5), width: 0.25),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 60,
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(image.isEmpty
                        ? 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png'
                        : image)),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  targetDisplayName.capitalized(),
                  style: TextStyle(
                      color: kPrimaryBlackColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 11.5.sp),
                ),
                const Spacer(),
                SizedBox(
                  width: 55.w,
                  child: Text(
                    widget.channel.state!.lastMessage?.text ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: widget.channel.state!.unreadCount > 0
                            ? FontWeight.w500
                            : FontWeight.w400,
                        color: widget.channel.state!.unreadCount > 0
                            ? kPrimaryBlackColor
                            : Colors.grey,
                        fontSize: 8.5.sp),
                  ),
                ),
                const SizedBox(height: 4)
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(height: 4),
                  if (widget.channel.state != null &&
                      widget.channel.state!.unreadCount > 0)
                    CircleAvatar(
                      radius: 11,
                      backgroundColor: kPrimaryBlackColor,
                      child: Text('${widget.channel.state?.unreadCount ?? ''}',
                          style: TextStyle(
                              color: kPrimaryWhiteColor, fontSize: 8.5.sp)),
                    ),
                  Text(
                    '${widget.channel.lastMessageAt != null ? timeago.format(widget.channel.lastMessageAt!) : ''}',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 8.5.sp,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
