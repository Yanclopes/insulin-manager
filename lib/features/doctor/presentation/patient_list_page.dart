import 'package:flutter/material.dart';
import 'package:insulinmanager/core/models/patient_model.dart';
import 'package:insulinmanager/core/services/patient_service.dart';

class PatientListPage extends StatefulWidget {
  const PatientListPage({Key? key}) : super(key: key);

  @override
  _PatientListPageState createState() => _PatientListPageState();
}

class _PatientListPageState extends State<PatientListPage> {
  final PatientService _patientService = PatientService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Pacientes"),
      ),
      body: StreamBuilder<List<PatientModel>>(
        stream: _patientService.getAllPatientsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text("Erro ao carregar pacientes: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Nenhum paciente encontrado."));
          }

          final patients = snapshot.data!;

          return ListView.builder(
            itemCount: patients.length,
            itemBuilder: (context, index) {
              final patient = patients[index];
              return ListTile(
                title: Text(patient.name),
                subtitle: Text(
                    "Idade: ${patient.age} | Tipo: ${patient.diabetesType}"),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        },
        child: const Icon(Icons.add),
        tooltip: "Adicionar Paciente",
      ),
    );
  }
}