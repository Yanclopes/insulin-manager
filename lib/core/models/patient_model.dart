import 'package:cloud_firestore/cloud_firestore.dart';

class PatientModel {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String responsibleDoctorId;
  final String hospitalId;
  final String diabetesType;
  final Timestamp createdAt;

  PatientModel({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.responsibleDoctorId,
    required this.hospitalId,
    required this.diabetesType,
    required this.createdAt,
  });

  factory PatientModel.fromMap(Map<String, dynamic> data) {
    return PatientModel(
      id: data['id'] as String,
      name: data['name'] as String,
      age: data['age'] as int,
      gender: data['gender'] as String,
      responsibleDoctorId: data['responsibleDoctorId'] as String,
      hospitalId: data['hospitalId'] as String,
      diabetesType: data['diabetesType'] as String,
      createdAt: data['createdAt'] as Timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'responsibleDoctorId': responsibleDoctorId,
      'hospitalId': hospitalId,
      'diabetesType': diabetesType,
      'createdAt': createdAt,
    };
  }
}