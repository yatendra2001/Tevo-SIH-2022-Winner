import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tevo/blocs/blocs.dart';
import 'package:tevo/cubits/cubits.dart';
import 'package:tevo/models/models.dart';
import 'package:tevo/repositories/repositories.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _userRepository;
  final PostRepository _postRepository;
  final AuthBloc _authBloc;
  final LikedPostsCubit _likedPostsCubit;

  StreamSubscription<List<Future<Post?>>>? _postsSubscription;

  ProfileBloc({
    required UserRepository userRepository,
    required PostRepository postRepository,
    required AuthBloc authBloc,
    required LikedPostsCubit likedPostsCubit,
  })  : _userRepository = userRepository,
        _postRepository = postRepository,
        _authBloc = authBloc,
        _likedPostsCubit = likedPostsCubit,
        super(ProfileState.initial());

  @override
  Future<void> close() {
    _postsSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is ProfileLoadUser) {
      yield* _mapProfileLoadUserToState(event);
    } else if (event is ProfileToggleGridView) {
      yield* _mapProfileToggleGridViewToState(event);
    } else if (event is ProfileUpdatePosts) {
      yield* _mapProfileUpdatePostsToState(event);
    } else if (event is ProfileFollowUser) {
      yield* _mapProfileFollowUserToState();
    } else if (event is ProfileUnfollowUser) {
      yield* _mapProfileUnfollowUserToState();
    } else if (event is ProfileDeleteRequest) {
      yield* _mapToDeleteRequest(event);
    } else if (event is ProfileToUpdateUser) {
      yield* _mapToUpdateUser(event);
    }
  }

  Stream<ProfileState> _mapProfileLoadUserToState(
    ProfileLoadUser event,
  ) async* {
    yield state.copyWith(status: ProfileStatus.loading);
    try {
      final user = await _userRepository.getUserWithId(userId: event.userId);
      final isCurrentUser = _authBloc.state.user!.uid == event.userId;

      final isFollowing = await _userRepository.isFollowing(
        userId: _authBloc.state.user!.uid,
        otherUserId: event.userId,
      );

      final isRequesting = await _userRepository.isRequesting(
        userId: _authBloc.state.user!.uid,
        otherUserId: event.userId,
      );

      _postsSubscription?.cancel();
      _postsSubscription = _postRepository
          .getUserPosts(userId: event.userId)
          .listen((posts) async {
        final allPosts = await Future.wait(posts);
        add(ProfileUpdatePosts(posts: allPosts));
      });

      yield state.copyWith(
        user: user,
        isCurrentUser: isCurrentUser,
        isFollowing: isFollowing,
        otherUserId: event.userId,
        isRequesting: isRequesting,
        status: ProfileStatus.loaded,
      );
    } catch (err) {
      yield state.copyWith(
        status: ProfileStatus.error,
        failure: const Failure(message: 'We were unable to load this profile.'),
      );
    }
  }

  Stream<ProfileState> _mapToDeleteRequest(ProfileDeleteRequest event) async* {
    _userRepository.deleteRequested(
        userId: _authBloc.state.user!.uid, otherUserId: state.otherUserId!);
    yield state.copyWith(isRequesting: false);
  }

  Stream<ProfileState> _mapProfileToggleGridViewToState(
    ProfileToggleGridView event,
  ) async* {
    yield state.copyWith(isGridView: event.isGridView);
  }

  Stream<ProfileState> _mapProfileUpdatePostsToState(
    ProfileUpdatePosts event,
  ) async* {
    yield state.copyWith(posts: event.posts);
    final likedPostIds = await _postRepository.getLikedPostIds(
      userId: _authBloc.state.user!.uid,
      posts: event.posts,
    );
    _likedPostsCubit.updateLikedPosts(postIds: likedPostIds);
  }

  Stream<ProfileState> _mapProfileFollowUserToState() async* {
    try {
      if (state.user.isPrivate) {
        _userRepository.requestUser(
            userId: _authBloc.state.user!.uid, followUserId: state.user.id);
        yield state.copyWith(isRequesting: true);
      } else {
        _userRepository.followUser(
            userId: _authBloc.state.user!.uid,
            followUserId: state.user.id,
            requestId: null);
        final updatedUser =
            state.user.copyWith(followers: state.user.followers + 1);
        yield state.copyWith(isFollowing: true, user: updatedUser);
      }
    } catch (err) {
      yield state.copyWith(
        status: ProfileStatus.error,
        failure:
            const Failure(message: 'Something went wrong! Please try again.'),
      );
    }
  }

  Stream<ProfileState> _mapProfileUnfollowUserToState() async* {
    try {
      _userRepository.unfollowUser(
        userId: _authBloc.state.user!.uid,
        unfollowUserId: state.user.id,
      );
      final updatedUser =
          state.user.copyWith(followers: state.user.followers - 1);
      yield state.copyWith(user: updatedUser, isFollowing: false);
    } catch (err) {
      yield state.copyWith(
        status: ProfileStatus.error,
        failure:
            const Failure(message: 'Something went wrong! Please try again.'),
      );
    }
  }

  Stream<ProfileState> _mapToUpdateUser(ProfileToUpdateUser event) async* {
    final User user = state.user.copyWith(isPrivate: event.isPrivate);
    _userRepository.updateUser(user: user);
    yield state.copyWith(user: user);
  }

  Future<List<User>> getFollowers(String userId) {
    return _userRepository.getFollowers(userId);
  }

  Future<List<User>> getFollowing(String userId) {
    return _userRepository.getFollowing(userId);
  }

  void blockUser(bool isIdBlocked, String blockId) {
    _userRepository.blockUser(_authBloc.state.user!.uid, blockId, isIdBlocked);
    if (isIdBlocked) {
      _userRepository.unfollowUser(
        userId: _authBloc.state.user!.uid,
        unfollowUserId: blockId,
      );
      _userRepository.unfollowUser(
        unfollowUserId: _authBloc.state.user!.uid,
        userId: blockId,
      );
    }
  }

  Future<bool> checkIsUserBlocked(String blockId) async {
    return await _userRepository.getblockUserId(
        _authBloc.state.user!.uid, blockId);
  }
}
