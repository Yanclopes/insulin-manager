// features/measurement_form_page.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insulinmanager/core/models/measurement_model.dart';
import 'package:insulinmanager/core/services/measurement_service.dart';

class MeasurementFormPage extends StatefulWidget {
  final String patientId;

  const MeasurementFormPage({Key? key, required this.patientId})
      : super(key: key);

  @override
  _MeasurementFormPageState createState() => _MeasurementFormPageState();
}

class _MeasurementFormPageState extends State<MeasurementFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _glucoseController = TextEditingController();
  final _measurementService = MeasurementService();

  bool _isFasting = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _glucoseController.dispose();
    super.dispose();
  }

  Future<void> _saveMeasurement() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final measurement = MeasurementModel(
        id: '',
        patientId: widget.patientId,
        glucoseValue: num.parse(_glucoseController.text.replaceAll(',', '.')),
        isFasting: _isFasting,
        createdAt: Timestamp.now(),
      );

      await _measurementService.addMeasurement(measurement);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Medição salva com sucesso!")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao salvar medição: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrar Medição")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _glucoseController,
                decoration: const InputDecoration(
                  labelText: "Valor da Glicemia (mg/dL)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => v!.isEmpty ? "Campo obrigatório" : null,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text("Medição em Jejum?"),
                subtitle: const Text(
                    "Ativado = Jejum / Desativado = Pós-Refeição"),
                value: _isFasting,
                onChanged: (bool newValue) {
                  setState(() {
                    _isFasting = newValue;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 30),
              Center(
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _saveMeasurement,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                        ),
                        child: const Text("Salvar Medição"),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}