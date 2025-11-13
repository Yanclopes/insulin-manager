import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insulinmanager/core/models/case_data_model.dart';

class CaseService {
  final CollectionReference _casesCollection =
      FirebaseFirestore.instance.collection('cases');

  Stream<List<CaseDataModel>> getCasesForPatientToday(String patientId) {
    final now = DateTime.now();
    final startOfToday = Timestamp.fromDate(DateTime(now.year, now.month, now.day));
    final endOfToday = Timestamp.fromDate(DateTime(now.year, now.month, now.day + 1));

    return _casesCollection
        .where('patientId', isEqualTo: patientId)
        .where('createdAt', isGreaterThanOrEqualTo: startOfToday)
        .where('createdAt', isLessThan: endOfToday)
        .snapshots()
        .map((snapshot) {
      try {
        final cases = snapshot.docs
            .map((doc) =>
                CaseDataModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
        cases.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return cases;
      } catch (e) {
        print("Erro no stream de casos: $e");
        return [];
      }
    });
  }

  // TODO: Função para salvar o caso (chamada pela InsulinCalculatorPage)
  Future<void> saveCase(CaseDataModel caseDataWithResult) async {
    try {
      DocumentReference docRef = _casesCollection.doc();
      CaseDataModel finalCase = CaseDataModel.fromMap({
        ...caseDataWithResult.toMap(),
        'id': docRef.id,
      });

      await docRef.set(finalCase.toMap());
            
    } catch (e) {
      print("Erro ao salvar caso: $e");
    }
  }
}