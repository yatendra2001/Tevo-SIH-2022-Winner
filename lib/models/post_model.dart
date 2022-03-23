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
  final DateTime date;

  const Post({
    this.id,
    required this.author,
    required this.toDoTask,
    required this.completedTask,
    required this.likes,
    required this.date,
  });

  @override
  List<Object?> get props => [
        id,
        author,
        toDoTask,
        completedTask,
        likes,
        date,
      ];

  Map<String, dynamic> toDocument() {
    return {
      'author':
          FirebaseFirestore.instance.collection(Paths.users).doc(author.id),
      'toDoTask': toDoTask,
      'completedTask': completedTask,
      'likes': likes,
      'date': Timestamp.fromDate(date),
    };
  }

  static Future<Post?> fromDocument(DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>;
    final authorRef = data['author'] as DocumentReference?;
    if (authorRef != null) {
      final authorDoc = await authorRef.get();
      if (authorDoc.exists) {
        return Post(
          id: doc.id,
          author: User.fromDocument(authorDoc),
          toDoTask: data['toDoTask'] ?? '',
          completedTask: data['completedTask'] ?? '',
          likes: (data['likes'] ?? 0).toInt(),
          date: (data['date'] as Timestamp).toDate(),
        );
      }
    }
    return null;
  }

  Post copyWith({
    String? id,
    User? author,
    List<Task>? toDoTask,
    List<Task>? completedTask,
    int? likes,
    DateTime? date,
  }) {
    return Post(
      id: id ?? this.id,
      author: author ?? this.author,
      toDoTask: toDoTask ?? this.toDoTask,
      completedTask: completedTask ?? this.completedTask,
      likes: likes ?? this.likes,
      date: date ?? this.date,
    );
  }
}
