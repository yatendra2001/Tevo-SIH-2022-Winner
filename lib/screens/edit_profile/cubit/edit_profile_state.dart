part of 'edit_profile_cubit.dart';

enum EditProfileStatus { initial, submitting, success, error }

class EditProfileState extends Equatable {
  final File? profileImage;
  final String username;
  final String bio;
  final String name;
  final EditProfileStatus status;
  final Failure failure;

  const EditProfileState({
    required this.profileImage,
    required this.username,
    required this.bio,
    required this.status,
    required this.name,
    required this.failure,
  });

  factory EditProfileState.initial() {
    return const EditProfileState(
      profileImage: null,
      username: '',
      name: '',
      bio: '',
      status: EditProfileStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object?> get props => [
        profileImage,
        username,
        bio,
        status,
        name,
        failure,
      ];

  EditProfileState copyWith({
    File? profileImage,
    String? username,
    String? bio,
    EditProfileStatus? status,
    Failure? failure,
    String? name,
  }) {
    return EditProfileState(
      profileImage: profileImage ?? this.profileImage,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      status: status ?? this.status,
      name: name ?? this.name,
      failure: failure ?? this.failure,
    );
  }
}
