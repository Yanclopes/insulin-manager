import 'package:cloud_firestore/cloud_firestore.dart';

class PatientModel {
  final String id;
  final String name;
  final int age;
  final String gender;
  final num weight;
  final num height;
  final String diabetesType;
  final Timestamp createdAt;

  final num a1c;
  final String renalFunctionStatus;

  PatientModel({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    required this.diabetesType,
    required this.createdAt,
    required this.a1c,
    required this.renalFunctionStatus,
  });

  factory PatientModel.fromMap(Map<String, dynamic> data) {
    return PatientModel(
      id: data['id'] as String,
      name: data['name'] as String,
      age: data['age'] as int,
      weight: data['weight'] as num,
      height: data['height'] as num,
      gender: data['gender'] as String,
      diabetesType: data['diabetesType'] as String,
      createdAt: data['createdAt'] as Timestamp,
      a1c: data['a1c'] as num,
      renalFunctionStatus: data['renalFunctionStatus'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'height': height,
      'weight': weight,
      'diabetesType': diabetesType,
      'createdAt': createdAt,
      'a1c': a1c,
      'renalFunctionStatus': renalFunctionStatus,
    };
  }
}