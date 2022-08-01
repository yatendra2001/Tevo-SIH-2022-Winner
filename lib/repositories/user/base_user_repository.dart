import 'package:tevo/models/models.dart';

abstract class BaseUserRepository {
  Future<User> getUserWithId({required String userId});
  Future<void> updateUser({required User user});
  Future<void> setUser({required User user});
  Future<List<User>> searchUsers({required String query});
  Future<List<User>> getUsersByFollowers(String userId);

  void followUser({
    required String userId,
    required String followUserId,
    required String requestId,
  });
  void unfollowUser({required String userId, required String unfollowUserId});
  Future<bool> searchUserbyPhone(
      {required String query, required bool newAccount});
  Future<bool> searchUserbyUsername({required String query});
  Future<bool> isFollowing({
    required String userId,
    required String otherUserId,
  });

  Future<bool> isRequesting({
    required String userId,
    required String otherUserId,
  });
}
