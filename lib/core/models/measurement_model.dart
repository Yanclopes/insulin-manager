import 'package:cloud_firestore/cloud_firestore.dart';

class MeasurementModel {
  final String id;
  final String patientId;
  final num glucoseValue;
  final bool isFasting;
  final Timestamp createdAt;

  MeasurementModel({
    required this.id,
    required this.patientId,
    required this.glucoseValue,
    required this.isFasting,
    required this.createdAt,
  });

  factory MeasurementModel.fromMap(Map<String, dynamic> data) {
    return MeasurementModel(
      id: data['id'] as String,
      patientId: data['patientId'] as String,
      glucoseValue: data['glucoseValue'] as num,
      isFasting: data['isFasting'] ?? true,
      createdAt: data['createdAt'] as Timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patientId': patientId,
      'glucoseValue': glucoseValue,
      'isFasting': isFasting,
      'createdAt': createdAt,
    };
  }
}