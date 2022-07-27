import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:tevo/blocs/auth/auth_bloc.dart';
import 'package:tevo/screens/stream_chat/utils/chat_encryption.dart';
import 'package:tevo/screens/stream_chat/utils/jwt_provider.dart';
import 'package:tevo/utils/session_helper.dart';

part 'initialize_stream_chat_state.dart';

class InitializeStreamChatCubit extends Cubit<InitializeStreamChatState> {
  InitializeStreamChatCubit() : super(InitializeStreamChatInitial());
  initializeStreamChat(BuildContext context) async {
    await StreamChat.of(context).client.disconnectUser();
    await JwtProvider.tokenProvider(context.read<AuthBloc>().state.user!.uid)
        .then((value) async {
      var user = User(
        id: context.read<AuthBloc>().state.user?.uid ?? '',
        name: SessionHelper.username,
        image: "",
        // extraData: {'publicKey': publicKey!},
      );

      var chatUser = await StreamChat.of(context).client.connectUser(
            user,
            value,
          );
      SessionHelper.totalUnreadMessagesCount = chatUser.totalUnreadCount;
    });
    log('PROFILE IMAGE: ${SessionHelper.profileImageUrl}');
    emit(StreamChatInitializedState());
  }
}
