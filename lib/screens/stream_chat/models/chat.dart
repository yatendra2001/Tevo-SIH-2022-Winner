import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:tevo/keys.env.dart';

class ChatModel extends ChangeNotifier {
  late StreamChatClient _streamChatClient;

  ChatModel() {
    _streamChatClient = StreamChatClient(
      streamChatApiKeyProd,
      logLevel: Level.SEVERE,
    );
  }

  StreamChatClient get streamClient => _streamChatClient;
}
