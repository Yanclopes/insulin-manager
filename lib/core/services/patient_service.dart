import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insulinmanager/core/models/patient_model.dart';

class PatientService {
  final CollectionReference _patientsCollection =
      FirebaseFirestore.instance.collection('patients');

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  Stream<List<PatientModel>> getAllPatientsStream() {
    final userId = currentUserId;

    return _patientsCollection
        .where('profissionalUid', isEqualTo: userId) 
        .snapshots()
        .map((snapshot) {
      try {
        return snapshot.docs
            .map((doc) =>
                PatientModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      } catch (e){
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
      throw Exception("Falha ao salvar paciente.");
    }
  }

  Future<void> updatePatient(PatientModel patient) async {
    try {
      await _patientsCollection.doc(patient.id).update(patient.toMap());
    } catch (e) {
      throw Exception("Falha ao atualizar paciente.");
    }
  }
}