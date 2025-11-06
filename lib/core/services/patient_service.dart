import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insulinmanager/core/models/patient_model.dart';

class PatientService {
  final CollectionReference _patientsCollection =
      FirebaseFirestore.instance.collection('patients');

  Stream<List<PatientModel>> getAllPatientsStream() {
    return _patientsCollection
        .snapshots()
        .map((snapshot) {
      try {
        return snapshot.docs
            .map((doc) =>
                PatientModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
      } catch (e) {
        print("Erro no stream de pacientes: $e");
        return [];
      }
    });
  }

  Future<void> addPatient(PatientModel patient) async {
    try {
      DocumentReference docRef = _patientsCollection.doc();
      Map<String, dynamic> patientData = patient.toMap();
      patientData['id'] = docRef.id;
      await docRef.set(patientData);

    } catch (e) {
      print("Erro ao adicionar paciente: $e");
      throw Exception("Falha ao salvar paciente.");
    }
  }

  Future<void> updatePatient(PatientModel patient) async {
    try {
      await _patientsCollection.doc(patient.id).update(patient.toMap());
    } catch (e) {
      print("Erro ao atualizar paciente: $e");
      throw Exception("Falha ao atualizar paciente.");
    }
  }
}