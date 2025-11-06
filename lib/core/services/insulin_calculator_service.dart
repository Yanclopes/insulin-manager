import 'package:insulinmanager/core/models/case_data_model.dart';

class InsulinCalculation {
  final double doseBasal;
  final double doseCorrecao;
  final String recomendacao;

  InsulinCalculation({
    required this.doseBasal,
    required this.doseCorrecao,
    required this.recomendacao,
  });
}

class InsulinCalculatorService {
  InsulinCalculation calculate(CaseDataModel caseData) {
    double basal = 0;
    double correcao = 0;
    String rec = "";

    if (caseData.glicemiaAtual > 180) {
      correcao = (caseData.glicemiaAtual - 100) / 30;
    }

    if (caseData.sensitivity == InsulinSensitivity.resistente) {
      correcao *= 1.5;
    }
    if (caseData.sensitivity == InsulinSensitivity.sensivel) {
      correcao *= 0.5;
    }

    if (caseData.category == ClinicalCategory.gestante) {
      basal = 0.4;
      rec = "Gestante: Ajustar NPH 0.4 UI/kg/dia e corrigir com Regular.";
    } else {
      basal = 0.5;
      rec = "Adulto: Ajustar NPH 0.5 UI/kg/dia e corrigir com Regular.";
    }

    correcao = (correcao * 2).round() / 2;

    return InsulinCalculation(
      doseBasal: basal,
      doseCorrecao: correcao,
      recomendacao:
          "$rec\nCorreção sugerida para ${caseData.glicemiaAtual} mg/dL: ${correcao.toStringAsFixed(1)} UI.",
    );
  }
}