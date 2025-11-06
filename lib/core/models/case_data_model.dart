import 'package:cloud_firestore/cloud_firestore.dart';

enum ClinicalCategory { critico, perioperatorio, gestante, outro }
enum InsulinSensitivity { usual, sensivel, resistente }

class CaseDataModel {
  final String id;
  final String patientId;
  final String doctorId;
  final ClinicalCategory category;
  final InsulinSensitivity sensitivity;
  final double glicemiaAtual;
  final double? insulinaBasal;
  final double? insulinaCorrecao;
  final String? recomendacao;
  final Timestamp createdAt;
  final bool approved;

  CaseDataModel({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.category,
    required this.sensitivity,
    required this.glicemiaAtual,
    this.insulinaBasal,
    this.insulinaCorrecao,
    this.recomendacao,
    required this.createdAt,
    this.approved = false,
  });

  CaseDataModel.startCase({
    required this.patientId,
    required this.doctorId,
    required this.glicemiaAtual,
    required this.category,
    required this.sensitivity,
  })  : id = '',
        insulinaBasal = null,
        insulinaCorrecao = null,
        recomendacao = null,
        createdAt = Timestamp.now(),
        approved = false;

  factory CaseDataModel.fromMap(Map<String, dynamic> data) {
    return CaseDataModel(
      id: data['id'] as String,
      patientId: data['patientId'] as String,
      doctorId: data['doctorId'] as String,
      category: ClinicalCategory.values.byName(data['category'] as String),
      sensitivity:
          InsulinSensitivity.values.byName(data['sensitivity'] as String),
      glicemiaAtual: (data['glicemiaAtual'] as num).toDouble(),
      insulinaBasal: (data['insulinaBasal'] as num?)?.toDouble(),
      insulinaCorrecao: (data['insulinaCorrecao'] as num?)?.toDouble(),
      recomendacao: data['recomendacao'] as String?,
      createdAt: data['createdAt'] as Timestamp,
      approved: data['approved'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patientId': patientId,
      'doctorId': doctorId,
      'category': category.name,
      'sensitivity': sensitivity.name,
      'glicemiaAtual': glicemiaAtual,
      'insulinaBasal': insulinaBasal,
      'insulinaCorrecao': insulinaCorrecao,
      'recomendacao': recomendacao,
      'createdAt': createdAt,
      'approved': approved,
    };
  }
}