import 'package:flutter/material.dart';
import 'package:insulinmanager/core/models/case_data_model.dart';
import 'package:insulinmanager/core/models/patient_model.dart';
import 'package:insulinmanager/core/services/insulin_calculator_service.dart';


class InsulinCalculatorPage extends StatefulWidget {
  final PatientModel patient;
  final String doctorUid;  
  
  const InsulinCalculatorPage({
    Key? key, 
    required this.patient, 
    required this.doctorUid
  }) : super(key: key);

  @override
  _InsulinCalculatorPageState createState() => _InsulinCalculatorPageState();
}


class _InsulinCalculatorPageState extends State<InsulinCalculatorPage> {
  final _formKey = GlobalKey<FormState>();
  final _glicemiaController = TextEditingController();
  ClinicalCategory _selectedCategory = ClinicalCategory.outro;
  InsulinSensitivity _selectedSensitivity = InsulinSensitivity.usual;

  final InsulinCalculatorService _calculatorService = InsulinCalculatorService();
  InsulinCalculation? _calculationResult;

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final caseData = CaseDataModel.startCase(
        patientId: widget.patient.id,
        doctorId: widget.doctorUid,    
        glicemiaAtual: double.parse(_glicemiaController.text),
        category: _selectedCategory,
        sensitivity: _selectedSensitivity,
      );

      final result = _calculatorService.calculate(caseData);

      setState(() {
        _calculationResult = result;
      });
    }
  }

  void _saveCase() {
    if (_calculationResult == null) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Medição salva com sucesso!"))
    );
    Navigator.pop(context); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cálculo para: ${widget.patient.name}"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _glicemiaController,
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _calculate,
                  child: const Text("Calcular Doses"),
                ),
              ),

              if (_calculationResult != null)
                _buildResultCard(_calculationResult!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(InsulinCalculation result) {
    return Card(
      margin: const EdgeInsets.only(top: 30.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: ElevatedButton(
                onPressed: _saveCase,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text("Salvar Medição"),
              ),
            )
          ],
        ),
      ),
    );
  }
}