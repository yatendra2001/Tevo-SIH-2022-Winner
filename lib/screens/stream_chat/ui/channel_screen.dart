import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:tevo/extensions/string_extension.dart';
import 'package:tevo/models/user_model.dart' as userModel;
import 'package:tevo/screens/screens.dart';
import 'package:tevo/screens/stream_chat/models/chat_type.dart';
import 'package:tevo/screens/stream_chat/models/inbox_utils.dart';
import 'package:tevo/screens/stream_chat/ui/widgets/members_list_sheet.dart';
import 'package:tevo/utils/session_helper.dart';
import 'package:tevo/utils/theme_constants.dart';

class ChannelScreenArgs {
  final userModel.User? user;
  final Channel? channel;
  final String? chatType;
  final String? profileImage;
  const ChannelScreenArgs(
      {Key? key, this.user, this.channel, this.chatType, this.profileImage});
}

class ChannelScreen extends StatefulWidget {
  static const routeName = '/channel-screen';

  static Route route({required ChannelScreenArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => ChannelScreen(
        user: args.user,
        channel: args.channel,
        chatType: args.chatType,
        profileImage: args.profileImage,
      ),
    );
  }

  final userModel.User? user;
  final Channel? channel;
  final String? chatType;
  final String? profileImage;
  const ChannelScreen(
      {Key? key, this.user, this.channel, this.chatType, this.profileImage})
      : super(key: key);

  @override
  State<ChannelScreen> createState() => _ChannelScreenState();
}

class _ChannelScreenState extends State<ChannelScreen> {
  late Channel channel;
  bool isOneOnOne = false;
  FocusNode _messageFocusNode = FocusNode();
  @override
  void initState() {
    setChannel();
    super.initState();
  }

  setChannel() async {
    if (widget.channel == null) {
      print("Setting up the required channel");
      print("User to chat with is" + widget.user.toString());
      channel = StreamChat.of(context).client.channel(
            'messaging',
            extraData: {
              'usernames':
                  widget.user!.username + "," + SessionHelper.username!,
              'members': [SessionHelper.uid!, widget.user!.id],
              'chat_type': widget.chatType,
              'u1': SessionHelper.username,
              'u2': widget.user!.username,
              'u1id': SessionHelper.uid,
              'u2id': widget.user!.id,
              'image': widget.user?.profileImageUrl
            },
            id: generateChannelId(SessionHelper.uid!, widget.user!.id),
          );
    } else {
      channel = widget.channel!;
    }
    isOneOnOne = channel.extraData['chat_type'] == 'one_on_one';
    log('IS ONE ON ONE: $isOneOnOne');
    await channel.watch();
    channel.addMembers([SessionHelper.uid!]);
  }

  Message? _quotedMessage;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop(true);
        return Future.value(true);
      },
      child: StreamChannel(
        channel: channel,
        child: Scaffold(
          appBar: ChannelHeader(
            title: Text(
              channel.extraData['u1id'] != SessionHelper.uid
                  ? channel.extraData['u1'].toString().capitalized()
                  : channel.extraData['u2'].toString().capitalized(),
              style: TextStyle(
                color: kPrimaryBlackColor,
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            // title: Text(
            //     channel.name!.replaceFirst(SessionHelper.displayName!, '')),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(true),
            ),
            onBackPressed: () => Navigator.popUntil(context, (route) => false),
            actions: [
              if (channel.extraData['chat_type'] == ChatType.oneOnOne)
                GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed(
                      ProfileScreen.routeName,
                      arguments:
                          ProfileScreenArgs(userId: widget.user!.id ?? '')),
                  child: Container(
                    width: 44,
                    height: 44,
                    margin: EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kPrimaryBlackColor,
                        image: DecorationImage(
                            image: NetworkImage((isOneOnOne
                                    ? (widget.profileImage ??
                                        'https://www.kindpng.com/picc/m/495-4952535_create-digital-profile-icon-blue-user-profile-icon.png')
                                    : channel.image) ??
                                'https://www.kindpng.com/picc/m/495-4952535_create-digital-profile-icon-blue-user-profile-icon.png'))),
                  ),
                ),
              if (channel.extraData['chat_type'] != ChatType.oneOnOne)
                SizedBox(
                  width: 30,
                  child: PopupMenuButton(
                      padding: EdgeInsets.zero,
                      onSelected: (index) {
                        if (index == 0) {
                          showModalBottomSheet(
                              context: context,
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(32),
                                      topRight: Radius.circular(32))),
                              builder: (context) {
                                return MembersListSheet(
                                  channel: channel,
                                );
                              });
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            value: 0,
                            child: Text('Show Members'),
                          )
                        ];
                      }),
                )
            ],
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: MessageListView(
                  // threadBuilder: (_, parentMessage) {
                  //   return ThreadPage();
                  // },
                  onMessageSwiped: (message) {
                    setState(() {
                      _quotedMessage = message;
                    });
                  },
                  messageBuilder: (context, details, messages, defaultMessage) {
                    return defaultMessage.copyWith(
                        showFlagButton: true,
                        showEditMessage: details.isMyMessage,
                        showCopyMessage: true,
                        showDeleteMessage: details.isMyMessage,
                        showReplyMessage: true,
                        showThreadReplyMessage: true,
                        onReplyTap: (message) {
                          setState(() {
                            _quotedMessage = message;
                          });
                        });
                  },
                ),
              ),
              MessageInput(
                quotedMessage: _quotedMessage,
                focusNode: _messageFocusNode,
                idleSendButton: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 16,
                    child: Icon(
                      Icons.arrow_forward,
                      color: kPrimaryWhiteColor,
                      size: 16,
                    ),
                  ),
                ),
                activeSendButton: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.black,
                    child: Icon(
                      Icons.arrow_upward,
                      size: 16,
                      color: kPrimaryWhiteColor,
                    ),
                  ),
                ),
                onQuotedMessageCleared: () {
                  setState(() => _quotedMessage = null);
                },
                onMessageSent: (message) =>
                    log('Sending message: ${message.text}'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
