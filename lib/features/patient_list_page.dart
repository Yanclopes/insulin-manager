import 'package:flutter/material.dart';
import 'package:insulinmanager/core/models/patient_model.dart';
import 'package:insulinmanager/core/services/patient_service.dart';
import 'package:insulinmanager/features/patient_form_page.dart';

class PatientListPage extends StatefulWidget {
  const PatientListPage({Key? key}) : super(key: key);

  @override
  _PatientListPageState createState() => _PatientListPageState();
}

class _PatientListPageState extends State<PatientListPage> {
  final PatientService _patientService = PatientService();

  void _handleMenuSelection(String value, PatientModel patient) {
    switch (value) {
      case 'edit':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PatientFormPage(patient: patient)),
        );
        break;
      case 'assess':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Ação 'Avaliação Inicial' para ${patient.name}")),
        );
        break;
      case 'report':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Ação 'Gerar Relatório' para ${patient.name}")),
        );
        break;
      case 'measure':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Ação 'Registrar Medição' para ${patient.name}")),
        );
        break;
    }
  }

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
                trailing: PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (String value) {
                    _handleMenuSelection(value, patient);
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Text('Editar'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'assess',
                      child: Text('Avaliação Inicial'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'report',
                      child: Text('Gerar Relatório'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'measure',
                      child: Text('Registrar Medição'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PatientFormPage()),
          );
        },
        child: const Icon(Icons.add),
        tooltip: "Adicionar Paciente",
      ),
    );
  }
}