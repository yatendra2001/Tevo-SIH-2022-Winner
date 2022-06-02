import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:tevo/screens/stream_chat/models/chat_type.dart';
import 'package:tevo/screens/stream_chat/ui/stream_chat_inbox.dart';
import 'package:tevo/utils/session_helper.dart';

class DmInbox extends StatefulWidget {
  const DmInbox({Key? key}) : super(key: key);

  @override
  _DmInboxState createState() => _DmInboxState();
}

class _DmInboxState extends State<DmInbox> {
  @override
  Widget build(BuildContext context) {
    log('USER_ID: ${SessionHelper.uid}');
    return Scaffold(
      body: ChannelsBloc(
        child: ChannelListView(
          watch: true,
          listBuilder: (context, channels) {
            log('CHANNELS: $channels');
            log('USER_ID: ${SessionHelper.uid}');
            if (channels.isNotEmpty) {
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
              child: Text('No Messages yet'),
            );
          },
          limit: 20,
          filter: Filter.and([
            Filter.in_(
              'members',
              [SessionHelper.uid!],
            ),
            Filter.equal('chat_type', ChatType.oneOnOne)
          ]),
          sort: [
            SortOption('last_message_at'),
            SortOption('has_unread', direction: -1),
          ],
          // channelWidget: ChannelPage(),
        ),
      ),
    );
  }
}
