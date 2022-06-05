import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tevo/screens/stream_chat/bloc/initialize_stream_chat/initialize_stream_chat_cubit.dart';
import 'package:tevo/screens/stream_chat/ui/widgets/dm_inbox.dart';
import 'package:tevo/screens/stream_chat/ui/widgets/groups_inbox.dart';
import 'package:tevo/utils/session_helper.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:tevo/utils/theme_constants.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'channel_screen.dart';

class StreamChatInboxArgs {
  const StreamChatInboxArgs();
}

class StreamChatInbox extends StatefulWidget {
  static const String routeName = '/stream-chat-inbox-screen';
  const StreamChatInbox({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider(
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
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Chat'),
          centerTitle: true,
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                child: Column(
                  children: const [
                    Icon(
                      FontAwesomeIcons.message,
                      color: kPrimaryBlackColor,
                      size: 20,
                    ),
                    Text(
                      'Messages',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Column(
                  children: const [
                    Icon(
                      Icons.people_outline_rounded,
                      color: kPrimaryBlackColor,
                      size: 20,
                    ),
                    Text('Groups', style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            DmInbox(),
            GroupsInbox(),
          ],
        ),
      ),
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
    members.forEach((member) {
      log('MEMBER IMAGE:: ${member.user?.image}');
    });
    setState(() {
      image = widget.channel.extraData['chat_type'] == 'one_on_one'
          ? SessionHelper.uid == members[0].user!.id
              ? members[1].user!.image!
              : members[0].user!.image!
          : widget.channel.image ?? '';
      targetDisplayName = widget.channel.extraData['chat_type'] == 'one_on_one'
          ? SessionHelper.uid == members[0].user!.id
              ? members[1].user!.name
              : members[0].user!.name
          : widget.channel.name ?? '';
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
        height: 60,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
          color: Colors.grey.shade700,
          width: 0.25,
        ))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 40,
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.cyan,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(image.isEmpty
                        ? 'https://www.kindpng.com/picc/m/495-4952535_create-digital-profile-icon-blue-user-profile-icon.png'
                        : image)),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 2),
                Text(targetDisplayName),
                const Spacer(),
                Text(
                  widget.channel.state!.lastMessage?.text ?? '',
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Colors.grey.shade200,
                      fontSize: 13,
                      fontStyle: FontStyle.italic),
                )
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (widget.channel.state != null &&
                    widget.channel.state!.unreadCount > 0)
                  Text(
                    '${widget.channel.state?.unreadCount ?? ''}',
                  ),
                Text(
                  '${widget.channel.lastMessageAt != null ? timeago.format(widget.channel.lastMessageAt!) : ''}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
