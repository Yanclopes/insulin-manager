import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insulinmanager/core/models/patient_model.dart';
import 'package:insulinmanager/core/services/patient_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientFormPage extends StatefulWidget {
  final PatientModel? patient;
  const PatientFormPage({super.key, this.patient});

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
  late TextEditingController _a1cController;
  String _selectedRenalStatus = 'Normal';
  String _selectedGender      = 'M';
  String currentUserId        = FirebaseAuth.instance.currentUser?.uid ?? '';

  bool _isLoading = false;
  bool get _isEditing => widget.patient != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.patient?.name);
    _ageController = TextEditingController(text: widget.patient?.age.toString());
    _diabetesTypeController = TextEditingController(text: widget.patient?.diabetesType);
    _weightController = TextEditingController(text: widget.patient?.weight?.toString());
    _heightController = TextEditingController(text: widget.patient?.height?.toString());
    _a1cController = TextEditingController(text: widget.patient?.a1c?.toString());
    _selectedRenalStatus = widget.patient?.renalFunctionStatus ?? 'Normal';
    _selectedGender = widget.patient?.gender ?? 'M';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _diabetesTypeController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }
  
  // Função helper de decoração (sem mudança)
  InputDecoration _buildInputDecoration({ required String labelText, required IconData icon }) {
     return InputDecoration(
      labelText: labelText,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder( borderRadius: BorderRadius.circular(12.0) ),
      filled: true,
      fillColor: Colors.grey.shade50,
    );
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
          a1c: num.parse(_a1cController.text.trim().replaceAll(',', '.')),
          renalFunctionStatus: _selectedRenalStatus,
          profissionalUid: currentUserId
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
          a1c: num.parse(_a1cController.text.trim().replaceAll(',', '.')),
          renalFunctionStatus: _selectedRenalStatus,
          profissionalUid: currentUserId
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
        title: Text(_isEditing ? "Editar Paciente" : "Novo Paciente"),
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
                decoration: _buildInputDecoration(
                  labelText: "Nome Completo",
                  icon: Icons.person_outline,
                ),
                validator: (v) => v!.isEmpty ? "Campo obrigatório" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ageController,
                decoration: _buildInputDecoration(
                  labelText: "Idade",
                  icon: Icons.cake_outlined,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => v!.isEmpty ? "Campo obrigatório" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _weightController,
                decoration: _buildInputDecoration(
                  labelText: "Peso (kg) (Ex: 70.5)",
                  icon: Icons.monitor_weight_outlined,
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [ FilteringTextInputFormatter.allow(RegExp(r'^\d+[,.]?\d*')), ],
                validator: (v) => v!.isEmpty ? "Campo obrigatório" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _heightController,
                decoration: _buildInputDecoration(
                  labelText: "Altura (m) (Ex: 1.75)",
                  icon: Icons.height_outlined,
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [ FilteringTextInputFormatter.allow(RegExp(r'^\d+[,.]?\d*')), ],
                validator: (v) => v!.isEmpty ? "Campo obrigatório" : null,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _a1cController,
                decoration: _buildInputDecoration(
                  labelText: "HbA1c (%) (Ex: 8.5)",
                  icon: Icons.bloodtype_outlined,
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [ FilteringTextInputFormatter.allow(RegExp(r'^\d+[,.]?\d*')), ],
                validator: (v) => v!.isEmpty ? "Campo obrigatório" : null,
              ),
              const SizedBox(height: 16),

              const Text("Status Renal", style: TextStyle(fontSize: 12, color: Colors.black54)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.grey.shade50,
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedRenalStatus,
                    isExpanded: true,
                    icon: const Icon(Icons.medical_services_outlined),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRenalStatus = newValue!;
                      });
                    },
                    items: <String>['Normal', 'Alterada/Reduzida']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const SizedBox(height: 16),
              TextFormField(
                controller: _diabetesTypeController,
                decoration: _buildInputDecoration(
                  labelText: "Tipo de Diabetes",
                  icon: Icons.coronavirus_outlined,
                ),
                validator: (v) => v!.isEmpty ? "Campo obrigatório" : null,
              ),
              const SizedBox(height: 30),
              
              Center(
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _savePatient,
                        child: Text(_isEditing
                            ? "Salvar Alterações"
                            : "Salvar"),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}