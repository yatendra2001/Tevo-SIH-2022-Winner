import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'package:tevo/config/paths.dart';
import 'package:tevo/models/models.dart';

class Post extends Equatable {
  final String? id;
  final User author;
  final List<Task> toDoTask;
  final List<Task> completedTask;
  final int likes;
  final Timestamp enddate;

  const Post({
    this.id,
    required this.author,
    required this.toDoTask,
    required this.completedTask,
    required this.likes,
    required this.enddate,
  });

  Post copyWith({
    String? id,
    User? author,
    List<Task>? toDoTask,
    List<Task>? completedTask,
    int? likes,
    Timestamp? enddate,
  }) {
    return Post(
      id: id ?? this.id,
      author: author ?? this.author,
      toDoTask: toDoTask ?? this.toDoTask,
      completedTask: completedTask ?? this.completedTask,
      likes: likes ?? this.likes,
      enddate: enddate ?? this.enddate,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'author':
          FirebaseFirestore.instance.collection(Paths.users).doc(author.id),
      'toDoTask': toDoTask.map((task) => task.toMap()).toList(),
      'completedTask': completedTask.map((task) => task.toMap()).toList(),
      'enddate': enddate.microsecondsSinceEpoch,
      'likes': likes,
    };
  }

  static Future<Post?> fromDocument(DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>;
    final authorRef = data['author'] as DocumentReference?;
    List<Task> ls = [];
    List<Task> ps = [];
    for (var map in data['toDoTask']) {
      ls.add(Task.fromMap(map));
    }
    for (var map in data['completedTask']) {
      ps.add(Task.fromMap(map));
    }
    if (authorRef != null) {
      final authorDoc = await authorRef.get();
      if (authorDoc.exists) {
        return Post(
          id: doc.id,
          author: User.fromDocument(authorDoc),
          toDoTask: ls,
          completedTask: ps,
          likes: (data['likes'] ?? 0).toInt(),
          enddate: Timestamp.fromMicrosecondsSinceEpoch(data['enddate']),
        );
      }
    }
    return null;
  }

  @override
  List<Object?> get props {
    return [
      id,
      author,
      toDoTask,
      completedTask,
      likes,
      enddate,
    ];
  }
}
