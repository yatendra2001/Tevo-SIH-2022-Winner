part of 'initialize_stream_chat_cubit.dart';

abstract class InitializeStreamChatState extends Equatable {
  const InitializeStreamChatState();

  @override
  List<Object> get props => [];
}

class InitializeStreamChatInitial extends InitializeStreamChatState {}

class StreamChatInitializedState extends InitializeStreamChatState {}
