import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insulinmanager/core/models/patient_model.dart';

class PatientService {
  final CollectionReference _patientsCollection =
      FirebaseFirestore.instance.collection('patients');

  Stream<List<PatientModel>> getAllPatientsStream() {
    return _patientsCollection.snapshots().map((snapshot) {
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
}