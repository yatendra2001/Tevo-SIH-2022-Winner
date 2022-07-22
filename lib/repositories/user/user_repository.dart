import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tevo/config/paths.dart';
import 'package:tevo/enums/enums.dart';
import 'package:tevo/models/models.dart';
import 'package:tevo/repositories/repositories.dart';
import 'package:tevo/utils/session_helper.dart';
import 'package:tevo/widgets/widgets.dart';

class UserRepository extends BaseUserRepository {
  final FirebaseFirestore _firebaseFirestore;

  UserRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<User> getUserWithId({required String userId}) async {
    final doc =
        await _firebaseFirestore.collection(Paths.users).doc(userId).get();
    return doc.exists ? User.fromDocument(doc) : User.empty;
  }

  @override
  Future<void> updateUser({required User user}) async {
    await _firebaseFirestore
        .collection(Paths.users)
        .doc(user.id)
        .update(user.toDocument());
  }

  @override
  Future<void> setUser({required User user}) async {
    await _firebaseFirestore
        .collection(Paths.users)
        .doc(user.id)
        .set(user.toDocument());
  }

  @override
  Future<List<User>> searchUsers({required String query}) async {
    List<User> list;

    final userNameSnap = await _firebaseFirestore
        .collection(Paths.users)
        .where('name', isGreaterThanOrEqualTo: query)
        .get();
    list = userNameSnap.docs.map((doc) => User.fromDocument(doc)).toList();

    final nameSnap = await _firebaseFirestore
        .collection(Paths.users)
        .where('username', isGreaterThanOrEqualTo: query)
        .get();

    list.addAll(nameSnap.docs.map((doc) => User.fromDocument(doc)).toList());
    return list;
  }

  @override
  Future<List<User>> getUsersByFollowers(String userId) async {
    final snap = await _firebaseFirestore
        .collection(Paths.following)
        .doc(userId)
        .collection(Paths.userFollowing)
        .get();

    final list = snap.docs.map((val) => val.id).toList();

    final userSnap = await _firebaseFirestore
        .collection(Paths.users)
        .orderBy(Paths.followers, descending: true)
        .where("isPrivate", isEqualTo: false)
        .get();
    // log(SessionHelper.uid!);

    final followersList =
        userSnap.docs.map((doc) => User.fromDocument(doc)).toList();
    List<User> topFollowersList = [];
    for (var element in followersList) {
      if (list.contains(element.id) == false &&
          element.id != SessionHelper.uid) {
        topFollowersList.add(element);
      }
    }
    return topFollowersList;
  }

  @override
  Future<bool> searchUserbyPhone(
      {required String query, required bool newAccount}) async {
    try {
      return await _firebaseFirestore
          .collection(Paths.users)
          .where("phoneNumber", isEqualTo: query)
          .snapshots()
          .isEmpty;
    } on FirebaseException catch (err) {
      if (err.code == 'permission-denied') {
        flutterToast(
            msg: newAccount ? 'New Account' : 'Account does not exists',
            position: ToastGravity.CENTER);
      } else {
        flutterToast(msg: 'An Error occured', position: ToastGravity.CENTER);
      }
    } catch (err) {
      flutterToast(msg: 'An Error occured', position: ToastGravity.CENTER);
    }
    return true;
  }

  @override
  Future<bool> searchUserbyUsername({required String query}) async {
    try {
      final QuerySnapshot users = await _firebaseFirestore
          .collection(Paths.users)
          .where(Paths.usernameLower, isEqualTo: query.toLowerCase())
          .get();
      return users.size == 0;
    } on FirebaseException catch (err) {
      log(err.message!);
    } catch (e) {
      log(e.toString());
    }
    return false;
  }

  void requestUser({
    required String userId,
    required String followUserId,
  }) {
    final notification = Notif(
      type: NotifType.request,
      fromUser: User.empty.copyWith(id: userId),
      date: DateTime.now(),
    );

    _firebaseFirestore
        .collection(Paths.requests)
        .doc(followUserId)
        .collection(Paths.userRequests)
        .add(notification.toDocument());
  }

  void deleteRequest({
    required String requestId,
    required String followUserId,
  }) {
    _firebaseFirestore
        .collection(Paths.requests)
        .doc(followUserId)
        .collection(Paths.userRequests)
        .doc(requestId)
        .delete();
  }

  @override
  Future<void> followUser({
    required String userId,
    required String followUserId,
    required String? requestId,
  }) async {
    log("han yeh bhi");

    // Add followUser to user's userFollowing.
    await _firebaseFirestore
        .collection(Paths.following)
        .doc(userId)
        .collection(Paths.userFollowing)
        .doc(followUserId)
        .set({});

    // Add user to followUser's userFollowers.
    await _firebaseFirestore
        .collection(Paths.followers)
        .doc(followUserId)
        .collection(Paths.userFollowers)
        .doc(userId)
        .set({});

    final notification = Notif(
      type: NotifType.follow,
      fromUser: User.empty.copyWith(id: userId),
      date: DateTime.now(),
    );

    if (requestId != null) {
      final notificationRequestAccepted = Notif(
        type: NotifType.requestAccepted,
        fromUser: User.empty.copyWith(id: followUserId),
        date: DateTime.now(),
      );

      _firebaseFirestore
          .collection(Paths.notifications)
          .doc(userId)
          .collection(Paths.userNotifications)
          .add(notificationRequestAccepted.toDocument());

      _firebaseFirestore
          .collection(Paths.notifications)
          .doc(followUserId)
          .collection(Paths.userNotifications)
          .add(notification.toDocument());

      deleteRequest(requestId: requestId, followUserId: followUserId);
    }
  }

  @override
  void unfollowUser({
    required String userId,
    required String unfollowUserId,
  }) {
    // Remove unfollowUser from user's userFollowing.
    _firebaseFirestore
        .collection(Paths.following)
        .doc(userId)
        .collection(Paths.userFollowing)
        .doc(unfollowUserId)
        .delete();
    // Remove user from unfollowUser's userFollowers.
    _firebaseFirestore
        .collection(Paths.followers)
        .doc(unfollowUserId)
        .collection(Paths.userFollowers)
        .doc(userId)
        .delete();
  }

  @override
  Future<bool> isFollowing({
    required String userId,
    required String otherUserId,
  }) async {
    // is otherUser in user's userFollowing
    final otherUserDoc = await _firebaseFirestore
        .collection(Paths.following)
        .doc(userId)
        .collection(Paths.userFollowing)
        .doc(otherUserId)
        .get();
    return otherUserDoc.exists;
  }

  @override
  Future<bool> isRequesting({
    required String userId,
    required String otherUserId,
  }) async {
    // is otherUser in user's requesting
    final authref = _firebaseFirestore.collection(Paths.users).doc(userId);
    final otherUserDoc = await _firebaseFirestore
        .collection(Paths.requests)
        .doc(otherUserId)
        .collection(Paths.userRequests)
        .where("fromUser", isEqualTo: authref)
        .get();
    return otherUserDoc.docs.isNotEmpty;
  }

  void deleteRequested({
    //Person sending request is deleting the request sent
    required String userId,
    required String otherUserId,
  }) async {
    // is otherUser in user's requesting
    final authref = _firebaseFirestore.collection(Paths.users).doc(userId);
    _firebaseFirestore
        .collection(Paths.requests)
        .doc(otherUserId)
        .collection(Paths.userRequests)
        .where("fromUser", isEqualTo: authref)
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }

  Future<bool> checkUsernameAvailability(String username) async {
    try {
      var result =
          await _firebaseFirestore.collection(Paths.users).doc(username).get();
      return result.exists;
    } catch (e) {
      log(e.toString());
    }
    return true;
  }

  Future<List<User>> getFollowers(String userId) async {
    final userSnap = await _firebaseFirestore
        .collection(Paths.followers)
        .doc(userId)
        .collection(Paths.userFollowers)
        .get();
    List<User> followers = [];
    for (var element in userSnap.docs) {
      final user = await getUserWithId(userId: element.id);
      followers.add(user);
    }
    return followers;
  }

  Future<List<User>> getFollowing(String userId) async {
    final userSnap = await _firebaseFirestore
        .collection(Paths.following)
        .doc(userId)
        .collection(Paths.userFollowing)
        .get();
    List<User> following = [];
    for (var element in userSnap.docs) {
      final user = await getUserWithId(userId: element.id);
      following.add(user);
    }
    return following;
  }

  void setToDo(int value, String userId) async {
    SessionHelper.todo = SessionHelper.todo ?? 0 + value;
    await _firebaseFirestore
        .collection(Paths.users)
        .doc(userId)
        .update({"todo": FieldValue.increment(value)});
  }

  void setComplete(int value, String userId) async {
    SessionHelper.completed = SessionHelper.completed ?? 0 + value;
    await _firebaseFirestore
        .collection(Paths.users)
        .doc(userId)
        .update({"completed": FieldValue.increment(value)});
  }

  Future<List<User>> postLikeUsers(String postId) async {
    final userSnap = await _firebaseFirestore
        .collection(Paths.likes)
        .doc(postId)
        .collection(Paths.postLikes)
        .get();
    List<User> likeUsers = [];
    for (var element in userSnap.docs) {
      final user = await getUserWithId(userId: element.id);
      likeUsers.add(user);
    }
    return likeUsers;
  }

  Future<User?> postOneLikeUser(String postId) async {
    final userSnap = await _firebaseFirestore
        .collection(Paths.likes)
        .doc(postId)
        .collection(Paths.postLikes)
        .get();
    User? likeUser;
    for (var element in userSnap.docs) {
      final user = await getUserWithId(userId: element.id);
      likeUser = user;
      break;
    }
    return likeUser;
  }
}
