import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String displayName;
  final String age;
  final String phone;
  final String profileImageUrl;
  final int followers;
  final int following;
  final String bio;
  final bool isPrivate;
  final int todo;
  final int completed;
  final int walletBalance;

  const User({
    required this.id,
    required this.username,
    required this.displayName,
    required this.age,
    required this.phone,
    this.isPrivate = false,
    required this.profileImageUrl,
    required this.followers,
    required this.following,
    required this.bio,
    required this.todo,
    required this.completed,
    required this.walletBalance,
  });

  static const empty = User(
    id: '',
    username: '',
    displayName: '',
    age: '',
    phone: '',
    profileImageUrl: '',
    followers: 0,
    following: 0,
    bio: '',
    todo: 0,
    completed: 0,
    walletBalance: 0,
  );

  @override
  List<Object?> get props => [
        id,
        username,
        displayName,
        isPrivate,
        age,
        phone,
        profileImageUrl,
        followers,
        following,
        bio,
        todo,
        completed,
        walletBalance,
      ];

  User copyWith({
    String? id,
    String? username,
    String? displayName,
    String? age,
    String? phone,
    String? profileImageUrl,
    bool? isPrivate,
    int? followers,
    int? following,
    String? bio,
    int? todo,
    int? completed,
    int? walletBalance,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      age: age ?? this.age,
      isPrivate: isPrivate ?? this.isPrivate,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      bio: bio ?? this.bio,
      todo: todo ?? this.todo,
      completed: completed ?? this.completed,
      walletBalance: walletBalance ?? this.walletBalance,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'username': username,
      'username_lower': username.toLowerCase(),
      'displayName': displayName,
      'age': age,
      'phone': phone,
      'isPrivate': isPrivate,
      'profileImageUrl': profileImageUrl,
      'followers': followers,
      'following': following,
      'bio': bio,
      'todo': todo,
      'completed': completed,
      'walletBalance': walletBalance,
    };
  }

  factory User.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      username: data['username'] ?? '',
      displayName: data['displayName'] ?? '',
      age: data['age'] ?? '',
      phone: data['phone'] ?? '',
      isPrivate: data["isPrivate"] ?? false,
      profileImageUrl: data['profileImageUrl'] ?? '',
      followers: (data['followers'] ?? 0).toInt(),
      following: (data['following'] ?? 0).toInt(),
      bio: data['bio'] ?? '',
      todo: (data['todo'] ?? 0).toInt(),
      completed: (data['completed'] ?? 0).toInt(),
      walletBalance: (data['walletBalance'] ?? 0).toInt(),
    );
  }
}
