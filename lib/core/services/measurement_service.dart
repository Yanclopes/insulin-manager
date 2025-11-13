import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insulinmanager/core/models/measurement_model.dart';

class MeasurementService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late final CollectionReference<Map<String, dynamic>> _measurementsRef;

  MeasurementService() {
    _measurementsRef = _db.collection('measurements');
  }

  Future<void> addMeasurement(MeasurementModel measurement) async {
    try {
      final docRef = _measurementsRef.doc();
      final newMeasurement = MeasurementModel(
        id: docRef.id,
        patientId: measurement.patientId,
        glucoseValue: measurement.glucoseValue,
        isFasting: measurement.isFasting,
        createdAt: Timestamp.now(),
      );
      await docRef.set(newMeasurement.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<MeasurementModel>> getMeasurementsStreamForPatient(
      String patientId) {
    return _measurementsRef
        .where('patientId', isEqualTo: patientId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MeasurementModel.fromMap(doc.data()))
          .toList();
    });
  }
}