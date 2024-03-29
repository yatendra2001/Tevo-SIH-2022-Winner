import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tevo/blocs/blocs.dart';
import 'package:tevo/cubits/cubits.dart';
import 'package:tevo/models/models.dart';
import 'package:tevo/repositories/repositories.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final PostRepository _postRepository;
  final AuthBloc _authBloc;
  final LikedPostsCubit _likedPostsCubit;
  final UserRepository _userRepository;

  FeedBloc(
      {required PostRepository postRepository,
      required AuthBloc authBloc,
      required LikedPostsCubit likedPostsCubit,
      required UserRepository userRepository})
      : _postRepository = postRepository,
        _authBloc = authBloc,
        _likedPostsCubit = likedPostsCubit,
        _userRepository = userRepository,
        super(FeedState.initial());

  @override
  Stream<FeedState> mapEventToState(FeedEvent event) async* {
    if (event is FeedFetchPosts) {
      yield* _mapFeedFetchPostsToState();
    } else if (event is FeedPaginatePosts) {
      yield* _mapFeedPaginatePostsToState();
    } else if (event is FeedToUnfollowUser) {
      yield* _mapToUnfollowUserToState(event);
    }
  }

  Stream<FeedState> _mapFeedFetchPostsToState() async* {
    yield state.copyWith(posts: [], status: FeedStatus.loading);
    try {
      final posts =
          await _postRepository.getUserFeed(userId: _authBloc.state.user!.uid);
      _likedPostsCubit.clearAllLikedPosts();

      final likedPostIds = await _postRepository.getLikedPostIds(
        userId: _authBloc.state.user!.uid,
        posts: posts,
      );
      _likedPostsCubit.updateLikedPosts(postIds: likedPostIds);
      yield state.copyWith(posts: posts, status: FeedStatus.loaded);
    } catch (err) {
      yield state.copyWith(
        status: FeedStatus.error,
        failure: const Failure(message: 'We were unable to load your feed.'),
      );
    }
  }

  Stream<FeedState> _mapFeedPaginatePostsToState() async* {
    yield state.copyWith(status: FeedStatus.paginating);
    try {
      final lastPostId = state.posts.isNotEmpty ? state.posts.last!.id : null;

      final posts = await _postRepository.getUserFeed(
        userId: _authBloc.state.user!.uid,
        lastPostId: lastPostId,
      );
      final updatedPosts = List<Post?>.from(state.posts)..addAll(posts);

      final likedPostIds = await _postRepository.getLikedPostIds(
        userId: _authBloc.state.user!.uid,
        posts: posts,
      );
      _likedPostsCubit.updateLikedPosts(postIds: likedPostIds);

      yield state.copyWith(posts: updatedPosts, status: FeedStatus.loaded);
    } catch (err) {
      yield state.copyWith(
        status: FeedStatus.error,
        failure: const Failure(message: 'We were unable to load your feed.'),
      );
    }
  }

  Stream<FeedState> _mapToUnfollowUserToState(FeedToUnfollowUser event) async* {
    try {
      final userId = _authBloc.state.user!.uid;
      _userRepository.unfollowUser(
          userId: userId, unfollowUserId: event.unfollowUserId);
      List<Post?> posts = List<Post?>.from(state.posts)
        ..removeWhere((post) => post!.author.id == event.unfollowUserId);
      yield state.copyWith(posts: posts);
    } catch (err) {
      yield state.copyWith(
        status: FeedStatus.error,
        failure: const Failure(message: 'We were unable to Unfollow User'),
      );
    }
  }
}
