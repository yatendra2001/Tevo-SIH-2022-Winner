import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:tevo/extensions/string_extension.dart';
import 'package:tevo/models/user_model.dart' as userModel;
import 'package:tevo/repositories/repositories.dart';
import 'package:tevo/screens/screens.dart';
import 'package:tevo/screens/stream_chat/cubit/initialize_stream_chat/initialize_stream_chat_cubit.dart';
import 'package:tevo/screens/stream_chat/models/chat_type.dart';
import 'package:tevo/screens/stream_chat/models/inbox_utils.dart';
import 'package:tevo/screens/stream_chat/ui/widgets/members_list_sheet.dart';
import 'package:tevo/screens/stream_chat/utils/chat_encryption.dart';
import 'package:tevo/utils/session_helper.dart';
import 'package:tevo/utils/theme_constants.dart';
import 'package:tevo/widgets/user_profile_image.dart';

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
  var derivedKey;
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
              'u1': SessionHelper.displayName,
              'u2': widget.user!.displayName,
              'u1id': SessionHelper.uid,
              'u2id': widget.user!.id,
              'image': widget.user?.profileImageUrl
            },
            id: generateChannelId(SessionHelper.uid!, widget.user!.id),
          );
    } else {
      channel = widget.channel!;
    }
    // final receiverJwk = channel.extraData['publicKey'] as String;

// // Generating derivedKey using user's privateKey and receiver's publicKey
//     derivedKey = await deriveKey(
//         context.read<InitializeStreamChatCubit>().privateKey!, receiverJwk);
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
            showTypingIndicator: true,
            backgroundColor: Colors.white,
            title: Text(
              channel.extraData['u1id'] != SessionHelper.uid
                  ? channel.extraData['u1'].toString()
                  : channel.extraData['u2'].toString(),
              style: TextStyle(
                color: kPrimaryBlackColor,
                fontFamily: kFontFamily,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.start,
            ),
            // title: Text(
            //     channel.name!.replaceFirst(SessionHelper.displayName!, '')),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_outlined),
              onPressed: () => Navigator.of(context).pop(true),
            ),
            onTitleTap: () {
              Navigator.of(context).pushReplacementNamed(
                  ProfileScreen.routeName,
                  arguments: ProfileScreenArgs(
                      userId: channel.extraData["u2id"].toString()));
            },
            onBackPressed: () => Navigator.popUntil(context, (route) => false),
            actions: [
              if (channel.extraData['chat_type'] == ChatType.oneOnOne)
                GestureDetector(
                  onTap: () => Navigator.of(context).pushReplacementNamed(
                    ProfileScreen.routeName,
                    arguments: ProfileScreenArgs(
                      userId: SessionHelper.uid !=
                              channel.extraData["u2id"].toString()
                          ? channel.extraData["u2id"].toString()
                          : channel.extraData["u1id"].toString(),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: UserProfileImage(
                      radius: 14,
                      profileImageUrl: widget.profileImage!,
                      iconRadius: 49,
                    ),
                  ),
                ),
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
                    // Retrieving the message from details
                    final message = details.message;
                    // final decryptedMessageFuture =
                    //     decryptMessage(message.text ?? '', derivedKey);

                    // return FutureBuilder<String>(
                    //     future: decryptedMessageFuture,
                    //     builder: (context, snapshot) {
                    //       if (snapshot.hasError)
                    //         return Text('Error: ${snapshot.error}');
                    //       if (!snapshot.hasData) return Container();
                    //       // Updating the original message with the decrypted text
                    //       final decryptedMessage =
                    //           message.copyWith(text: snapshot.data);
                    return defaultMessage.copyWith(
                        message: message,
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
                // preMessageSending: (message) async {
                //   // Encrypting the message text using derivedKey
                //   final encryptedMessage =
                //       await encryptMessage(message.text!, derivedKey);

                //   // Creating a new message with the encrypted message text
                //   final newMessage = message.copyWith(text: encryptedMessage);

                //   return newMessage;
                // },
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
