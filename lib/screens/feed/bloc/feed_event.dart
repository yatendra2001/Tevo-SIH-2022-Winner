part of 'feed_bloc.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object?> get props => [];
}

class FeedFetchPosts extends FeedEvent {}

class FeedPaginatePosts extends FeedEvent {}

class FeedToUnfollowUser extends FeedEvent {
  String unfollowUserId;
  FeedToUnfollowUser({required this.unfollowUserId});
  @override
  List<Object?> get props => [unfollowUserId];
}
