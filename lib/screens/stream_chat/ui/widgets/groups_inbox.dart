import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:tevo/screens/stream_chat/models/chat_type.dart';
import 'package:tevo/screens/stream_chat/ui/stream_chat_inbox.dart';
import 'package:tevo/utils/session_helper.dart';

class GroupsInbox extends StatefulWidget {
  const GroupsInbox({Key? key}) : super(key: key);

  @override
  _GroupsInboxState createState() => _GroupsInboxState();
}

class _GroupsInboxState extends State<GroupsInbox> {
  @override
  Widget build(BuildContext context) {
    return ChannelsBloc(
      child: ChannelListView(
        watch: true,
        listBuilder: (context, channels) {
          log('CHANNELS: $channels');
          log('USER_ID: ${SessionHelper.uid}');
          if (channels.length > 0) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                      itemCount: channels.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return InboxListItem(
                          channel: channels[index],
                        );
                      }),
                ],
              ),
            );
          }
          return Center(
            child: Text(
              'No Messages yet',
            ),
          );
        },
        limit: 20,
        filter: Filter.and([
          Filter.in_(
            'members',
            [SessionHelper.uid!],
          ),
          Filter.equal('chat_type', ChatType.group)
        ]),
        sort: [
          SortOption('last_message_at'),
          SortOption('has_unread', direction: -1),
        ],
        // channelWidget: ChannelPage(),
      ),
    );
  }
}
