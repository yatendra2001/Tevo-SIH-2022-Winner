import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:tevo/screens/stream_chat/utils/jwt_provider.dart';
import 'package:tevo/utils/session_helper.dart';

part 'initialize_stream_chat_state.dart';

class InitializeStreamChatCubit extends Cubit<InitializeStreamChatState> {
  InitializeStreamChatCubit() : super(InitializeStreamChatInitial());

  initializeStreamChat(BuildContext context) async {
    var token = await JwtProvider.tokenProvider(SessionHelper.uid!);
    log('PROFILE IMAGE: ${SessionHelper.profileImageUrl}');
    var user = User(
        id: SessionHelper.uid ?? '', name: SessionHelper.username, image: "");
    var chatUser = await StreamChat.of(context).client.connectUser(
          user,
          token,
        );
    SessionHelper.totalUnreadMessagesCount = chatUser.totalUnreadCount;
    emit(StreamChatInitializedState());
  }
}
