part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileLoadUser extends ProfileEvent {
  final String userId;

  const ProfileLoadUser({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class ProfileToggleGridView extends ProfileEvent {
  final bool isGridView;

  const ProfileToggleGridView({required this.isGridView});

  @override
  List<Object?> get props => [isGridView];
}

class ProfileUpdatePosts extends ProfileEvent {
  final List<Post?> posts;

  const ProfileUpdatePosts({required this.posts});

  @override
  List<Object?> get props => [posts];
}

class ProfileFollowUser extends ProfileEvent {}

class ProfileUnfollowUser extends ProfileEvent {}

class ProfileDeleteRequest extends ProfileEvent {}

class ProfileToUpdateUser extends ProfileEvent {
  final bool isPrivate;
  const ProfileToUpdateUser({
    required this.isPrivate,
  });

  @override
  List<Object?> get props => [isPrivate];
}
