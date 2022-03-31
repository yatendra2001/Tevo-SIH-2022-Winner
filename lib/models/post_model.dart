import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:tevo/config/paths.dart';
import 'package:tevo/models/models.dart';

class Post extends Equatable {
  final String? id;
  final User author;
  final List<Task> toDoTask;
  final List<Task> completedTask;
  final DateTime enddate;

  const Post({
    this.id,
    required this.author,
    required this.toDoTask,
    required this.completedTask,
    required this.enddate,
  });

  @override
  List<Object?> get props => [
        id,
        author,
        toDoTask,
        completedTask,
        enddate,
      ];

  Map<String, dynamic> toDocument() {
    return {
      'author':
          FirebaseFirestore.instance.collection(Paths.users).doc(author.id),
      'toDoTask': toDoTask.map((task) => task.toMap()).toList(),
      'completedTask': completedTask.map((task) => task.toMap()).toList(),
      'enddate': Timestamp.fromDate(enddate),
    };
  }

  static Future<Post?> fromDocument(DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>;
    final authorRef = data['author'] as DocumentReference?;
    List<Task> ls = [];
    List<Task> ps = [];
    for (var map in data['toDoTask']) {
      ls.add(Task(timestamp: map['timestamp'], task: map['task'], likes: 0));
    }
    for (var map in data['completedTask']) {
      ps.add(Task(
          timestamp: map['timestamp'],
          task: map['task'],
          likes: (map['likes'] ?? 0).toInt()));
    }
    if (authorRef != null) {
      final authorDoc = await authorRef.get();
      if (authorDoc.exists) {
        return Post(
          id: doc.id,
          author: User.fromDocument(authorDoc),
          toDoTask: ls,
          completedTask: ps,
          enddate: (data['enddate'] as Timestamp).toDate(),
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
    DateTime? enddate,
  }) {
    return Post(
      id: id ?? this.id,
      author: author ?? this.author,
      toDoTask: toDoTask ?? this.toDoTask,
      completedTask: completedTask ?? this.completedTask,
      enddate: enddate ?? this.enddate,
    );
  }
}
