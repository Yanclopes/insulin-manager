import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final bool active;
  final Timestamp createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.active = true,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'active': active,
      'createdAt': createdAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] as String,
      name: data['name'] as String,
      email: data['email'] as String,
      active: data['active'] as bool,
      createdAt: data['createdAt'] as Timestamp,
    );
  }
}