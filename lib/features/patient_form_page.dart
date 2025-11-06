import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insulinmanager/core/models/patient_model.dart';
import 'package:insulinmanager/core/services/patient_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientFormPage extends StatefulWidget {
  final PatientModel? patient;

  const PatientFormPage({
    super.key,
    this.patient,
  });

  @override
  _PatientFormPageState createState() => _PatientFormPageState();
}

class _PatientFormPageState extends State<PatientFormPage> {
  final PatientService _patientService = PatientService();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _diabetesTypeController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  bool _eat = false;

  String _selectedGender = 'M';
  bool _isLoading = false;

  bool get _isEditing => widget.patient != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.patient?.name);
    _ageController =
        TextEditingController(text: widget.patient?.age.toString());
    _diabetesTypeController =
        TextEditingController(text: widget.patient?.diabetesType);

    // Inicializar campos faltantes
    _weightController =
        TextEditingController(text: widget.patient?.weight?.toString());
    _heightController =
        TextEditingController(text: widget.patient?.height?.toString());
    _eat = widget.patient?.eat ?? false;

    _selectedGender = widget.patient?.gender ?? 'M';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _diabetesTypeController.dispose();
    // Dispose dos novos controladores
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  Future<void> _savePatient() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isEditing) {
        final updatedPatient = PatientModel(
          id: widget.patient!.id,
          name: _nameController.text.trim(),
          age: int.parse(_ageController.text),
          gender: _selectedGender,
          diabetesType: _diabetesTypeController.text.trim(),
          createdAt: widget.patient!.createdAt,
          weight: num.parse(_weightController.text.trim().replaceAll(',', '.')),
          height: num.parse(_heightController.text.trim().replaceAll(',', '.')),
          eat: _eat,
        );

        await _patientService.updatePatient(updatedPatient);
      } else {
        final newPatient = PatientModel(
          id: '', 
          name: _nameController.text.trim(),
          age: int.parse(_ageController.text),
          gender: _selectedGender,
          diabetesType: _diabetesTypeController.text.trim(),
          createdAt: Timestamp.now(),
          weight: num.parse(_weightController.text.trim().replaceAll(',', '.')),
          height: num.parse(_heightController.text.trim().replaceAll(',', '.')),
          eat: _eat,
        );

        await _patientService.addPatient(newPatient);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "Paciente salvo${_isEditing ? ' (editado)' : ''} com sucesso!")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao salvar paciente: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? "Editar Paciente" : "Adicionar Paciente"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Nome Completo",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Campo obrigatório" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: "Idade",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => v!.isEmpty ? "Campo obrigatório" : null,
              ),
              const SizedBox(height: 16),

              // CAMPO ADICIONADO: Peso
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(
                  labelText: "Peso (kg) (Ex: 70.5)",
                  border: OutlineInputBorder(),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+[,.]?\d*')),
                ],
                validator: (v) => v!.isEmpty ? "Campo obrigatório" : null,
              ),
              const SizedBox(height: 16),

              // CAMPO ADICIONADO: Altura
              TextFormField(
                controller: _heightController,
                decoration: const InputDecoration(
                  labelText: "Altura (m) (Ex: 1.75)",
                  border: OutlineInputBorder(),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+[,.]?\d*')),
                ],
                validator: (v) => v!.isEmpty ? "Campo obrigatório" : null,
              ),
              const SizedBox(height: 16),

              const Text("Sexo Biológico",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButton<String>(
                value: _selectedGender,
                isExpanded: true,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue!;
                  });
                },
                items: <String>['M', 'F', 'Outro']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _diabetesTypeController,
                decoration: const InputDecoration(
                  labelText: "Tipo de Diabetes (Ex: 1, 2, Gestacional)",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Campo obrigatório" : null,
              ),
              const SizedBox(height: 16),

              SwitchListTile(
                title: const Text("O paciente comeu?"),
                subtitle:
                    const Text("Marque se a medição for após uma refeição."),
                value: _eat,
                onChanged: (bool newValue) {
                  setState(() {
                    _eat = newValue;
                  });
                },
                secondary: Icon(_eat ? Icons.fastfood : Icons.no_food),
                contentPadding: EdgeInsets.zero,
              ),

              const SizedBox(height: 30),
              Center(
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _savePatient,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                        ),
                        child: Text(_isEditing
                            ? "Salvar Alterações"
                            : "Salvar Paciente"),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}