import 'package:tevo/models/models.dart';

abstract class BaseUserRepository {
  Future<User> getUserWithId({required String userId});
  Future<void> updateUser({required User user});
  Future<List<User>> searchUsers({required String query});

  void followUser({
    required String userId,
    required String followUserId,
    required String requestId,
  });
  void unfollowUser({required String userId, required String unfollowUserId});
  Future<bool> searchUserbyPhone(
      {required String query, required bool newAccount});
  Future<bool> isFollowing({
    required String userId,
    required String otherUserId,
  });

  Future<bool> isRequesting({
    required String userId,
    required String otherUserId,
  });
}
