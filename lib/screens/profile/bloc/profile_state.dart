part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, loaded, error }

class ProfileState extends Equatable {
  final User user;
  final List<Post?> posts;
  final bool isCurrentUser;
  final String? otherUserId;
  final bool isGridView;
  final bool isFollowing;
  final bool isRequesting;
  final ProfileStatus status;
  final Failure failure;

  const ProfileState({
    required this.user,
    required this.posts,
    required this.isCurrentUser,
    required this.isGridView,
    required this.isFollowing,
    required this.otherUserId,
    required this.isRequesting,
    required this.status,
    required this.failure,
  });

  factory ProfileState.initial() {
    return const ProfileState(
      user: User.empty,
      posts: [],
      isCurrentUser: false,
      otherUserId: null,
      isGridView: true,
      isRequesting: false,
      isFollowing: false,
      status: ProfileStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object?> get props => [
        user,
        posts,
        isCurrentUser,
        isGridView,
        otherUserId,
        isFollowing,
        isRequesting,
        status,
        failure,
      ];

  ProfileState copyWith({
    User? user,
    List<Post?>? posts,
    String? otherUserId,
    bool? isCurrentUser,
    bool? isGridView,
    bool? isFollowing,
    bool? isRequesting,
    ProfileStatus? status,
    Failure? failure,
  }) {
    return ProfileState(
      user: user ?? this.user,
      posts: posts ?? this.posts,
      isRequesting: isRequesting ?? this.isRequesting,
      otherUserId: otherUserId ?? this.otherUserId,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
      isGridView: isGridView ?? this.isGridView,
      isFollowing: isFollowing ?? this.isFollowing,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
