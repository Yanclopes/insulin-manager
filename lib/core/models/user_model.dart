import 'package:cloud_firestore/cloud_firestore.dart';

enum UserType { doctor, patient }

class UserModel {
  final String uid;
  final String name;
  final String email;
  final UserType type;
  final bool active;
  final String? hospitalId;
  final Timestamp createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.type,
    this.active = true,
    this.hospitalId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'type': type.name,
      'active': active,
      'hospitalId': hospitalId,
      'createdAt': createdAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] as String,
      name: data['name'] as String,
      email: data['email'] as String,
      type: (data['type'] == 'doctor') ? UserType.doctor : UserType.patient,
      active: data['active'] as bool,
      hospitalId: data['hospitalId'] as String?,
      createdAt: data['createdAt'] as Timestamp,
    );
  }
}