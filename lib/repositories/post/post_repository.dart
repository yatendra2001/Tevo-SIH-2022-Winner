import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tevo/config/paths.dart';
import 'package:tevo/enums/enums.dart';
import 'package:tevo/models/models.dart';
import 'package:tevo/repositories/repositories.dart';

class PostRepository extends BasePostRepository {
  final FirebaseFirestore _firebaseFirestore;

  PostRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<String> createPost({required Post post}) async {
    final ref =
        await _firebaseFirestore.collection(Paths.posts).add(post.toDocument());
    return ref.id;
  }

  @override
  Future<void> createComment({
    required Post post,
    required Comment comment,
  }) async {
    await _firebaseFirestore
        .collection(Paths.comments)
        .doc(comment.postId)
        .collection(Paths.postComments)
        .add(comment.toDocument());

    final notification = Notif(
      type: NotifType.comment,
      fromUser: comment.author,
      post: post,
      date: DateTime.now(),
    );

    _firebaseFirestore
        .collection(Paths.notifications)
        .doc(post.author.id)
        .collection(Paths.userNotifications)
        .add(notification.toDocument());
  }

  @override
  void createLike({
    required Post post,
    required String userId,
  }) {
    _firebaseFirestore
        .collection(Paths.posts)
        .doc(post.id)
        .update({'likes': FieldValue.increment(1)});

    _firebaseFirestore
        .collection(Paths.likes)
        .doc(post.id)
        .collection(Paths.postLikes)
        .doc(userId)
        .set({});

    final notification = Notif(
      type: NotifType.like,
      fromUser: User.empty.copyWith(id: userId),
      post: post,
      date: DateTime.now(),
    );

    _firebaseFirestore
        .collection(Paths.notifications)
        .doc(post.author.id)
        .collection(Paths.userNotifications)
        .add(notification.toDocument());
  }

  Future<Post?> getPost(String postId) async {
    final doc =
        await _firebaseFirestore.collection(Paths.posts).doc(postId).get();
    return doc.exists ? Post.fromDocument(doc) : null;
  }

  @override
  Stream<List<Future<Post?>>> getUserPosts({required String userId}) {
    final authorRef = _firebaseFirestore.collection(Paths.users).doc(userId);
    return _firebaseFirestore
        .collection(Paths.posts)
        .where('author', isEqualTo: authorRef)
        .orderBy('enddate', descending: false)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => Post.fromDocument(doc)).toList());
  }

  @override
  Future<double> getCompletionRate({required String userId}) async {
    final authorRef = _firebaseFirestore.collection(Paths.users).doc(userId);
    final userSnap = await _firebaseFirestore
        .collection(Paths.posts)
        .where('author', isEqualTo: authorRef)
        .get();

    double totalCompletedTasks = 0;
    double totalTasks = 0;
    final postsList =
        userSnap.docs.map((doc) => Post.fromDocument(doc)).toList();

    postsList.forEach((element) async {
      await element.then((value) {
        totalCompletedTasks += value?.completedTask.length ?? 0;
        totalTasks =
            totalTasks + (value?.toDoTask.length ?? 0) + totalCompletedTasks;
      });
    });
    return totalTasks != 0 ? ((totalCompletedTasks * 100) / totalTasks) : 0;
  }

  Future<Post?> getUserLastPost({required String userId}) async {
    final authorRef = _firebaseFirestore.collection(Paths.users).doc(userId);
    final currentTimeStamp = Timestamp.now();
    final post = await _firebaseFirestore
        .collection(Paths.posts)
        .where('author', isEqualTo: authorRef)
        .where('enddate',
            isGreaterThan: currentTimeStamp.microsecondsSinceEpoch)
        .get();
    return post.docs.isNotEmpty ? Post.fromDocument(post.docs.single) : null;
  }

  @override
  Stream<List<Future<Comment?>>> getPostComments({required String postId}) {
    return _firebaseFirestore
        .collection(Paths.comments)
        .doc(postId)
        .collection(Paths.postComments)
        .orderBy('date', descending: false)
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => Comment.fromDocument(doc)).toList());
  }

  @override
  Future<List<Post?>> getUserFeed({
    required String userId,
    String? lastPostId,
  }) async {
    QuerySnapshot postsSnap;
    if (lastPostId == null) {
      postsSnap = await _firebaseFirestore
          .collection(Paths.feeds)
          .doc(userId)
          .collection(Paths.userFeed)
          .orderBy('enddate', descending: true)
          .limit(8)
          .get();
    } else {
      final lastPostDoc = await _firebaseFirestore
          .collection(Paths.feeds)
          .doc(userId)
          .collection(Paths.userFeed)
          .doc(lastPostId)
          .get();

      if (!lastPostDoc.exists) {
        return [];
      }

      postsSnap = await _firebaseFirestore
          .collection(Paths.feeds)
          .doc(userId)
          .collection(Paths.userFeed)
          .where('enddate')
          .startAfterDocument(lastPostDoc)
          .limit(8)
          .get();
    }

    final posts = Future.wait(
      postsSnap.docs.map((doc) => Post.fromDocument(doc)).toList(),
    );
    return posts;
  }

  @override
  Future<Set<String>> getLikedPostIds({
    required String userId,
    required List<Post?> posts,
  }) async {
    final postIds = <String>{};
    for (final post in posts) {
      final likeDoc = await _firebaseFirestore
          .collection(Paths.likes)
          .doc(post!.id)
          .collection(Paths.postLikes)
          .doc(userId)
          .get();
      if (likeDoc.exists) {
        postIds.add(post.id!);
      }
    }
    return postIds;
  }

  @override
  void deleteLike({required String postId, required String userId}) {
    _firebaseFirestore
        .collection(Paths.posts)
        .doc(postId)
        .update({'likes': FieldValue.increment(-1)});

    _firebaseFirestore
        .collection(Paths.likes)
        .doc(postId)
        .collection(Paths.postLikes)
        .doc(userId)
        .delete();
  }

  void updatePost({required Post post}) {
    _firebaseFirestore
        .collection(Paths.posts)
        .doc(post.id)
        .update(post.toDocument());
  }

  Future<void> deletePost({required String postId}) async {
    await _firebaseFirestore.collection(Paths.posts).doc(postId).delete();
  }
}
