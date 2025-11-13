import 'package:cloud_firestore/cloud_firestore.dart';

class PatientModel {
  final String id;
  final String name;
  final int age;
  final String gender;
  final num weight;
  final num height;
  final bool eat;
  final String diabetesType;
  final Timestamp createdAt;

  PatientModel({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    required this.eat,
    required this.diabetesType,
    required this.createdAt,
  });

  factory PatientModel.fromMap(Map<String, dynamic> data) {
    return PatientModel(
      id: data['id'] as String,
      name: data['name'] as String,
      age: data['age'] as int,
      weight: data['weight'] as num,
      height: data['height'] as num,
      eat: data['eat'] as bool,
      gender: data['gender'] as String,
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
      'eat': eat,
      'height': height,
      'weight': weight,
      'diabetesType': diabetesType,
      'createdAt': createdAt,
    };
  }
}