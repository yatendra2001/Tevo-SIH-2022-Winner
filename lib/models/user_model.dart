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

  const User({
    required this.id,
    required this.username,
    required this.displayName,
    required this.age,
    required this.phone,
    required this.profileImageUrl,
    required this.followers,
    required this.following,
    required this.bio,
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
  );

  @override
  List<Object?> get props => [
        id,
        username,
        displayName,
        age,
        phone,
        profileImageUrl,
        followers,
        following,
        bio,
      ];

  User copyWith({
    String? id,
    String? username,
    String? displayName,
    String? age,
    String? phone,
    String? profileImageUrl,
    int? followers,
    int? following,
    String? bio,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      age: age ?? this.age,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      bio: bio ?? this.bio,
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
      'profileImageUrl': profileImageUrl,
      'followers': followers,
      'following': following,
      'bio': bio,
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
      profileImageUrl: data['profileImageUrl'] ?? '',
      followers: (data['followers'] ?? 0).toInt(),
      following: (data['following'] ?? 0).toInt(),
      bio: data['bio'] ?? '',
    );
  }
}
