import 'package:flutter/material.dart';
import 'package:insulinmanager/core/models/patient_model.dart';
import 'package:insulinmanager/core/services/patient_service.dart';
import 'package:insulinmanager/features/patient_form_page.dart';
import 'package:insulinmanager/features/measurement_form_page.dart';
import 'package:insulinmanager/features/report_page.dart';

class PatientListPage extends StatefulWidget {
  const PatientListPage({Key? key}) : super(key: key);

  @override
  _PatientListPageState createState() => _PatientListPageState();
}

class _PatientListPageState extends State<PatientListPage> {
  final PatientService _patientService = PatientService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // --- FUNÇÃO COM TEXTO CLÍNICO ATUALIZADO ---
  void _showInitialAssessment(PatientModel patient) {
    String doseSugerida = "N/A";
    String status = "N/A";
    Color statusColor = Colors.grey;
    const String medNome = "Metformina";

    if (patient.renalFunctionStatus == "Alterada/Reduzida") {
      doseSugerida = "Contraindicado";
      status = "Função renal alterada. Metformina contraindicada.";
      statusColor = Colors.red.shade700;
    } else if (patient.a1c >= 6.5 && patient.a1c < 8.0) {
      doseSugerida = "500 mg, 2x/dia (Total 1000 mg)";
      status = "HbA1c Levemente Elevada.";
      statusColor = Colors.blue.shade700;
    } else if (patient.a1c >= 8.0 && patient.a1c < 10.0) {
      doseSugerida = "850 mg, 2x/dia (Total 1700 mg)";
      status = "HbA1c Moderadamente Elevada.";
      statusColor = Colors.orange.shade700;
    } else if (patient.a1c >= 10.0) {
      doseSugerida = "850 mg, 2x/dia (Total 1700 mg)";
      status = "HbA1c > 10%. Considerar insulinoterapia associada.";
      statusColor = Colors.deepOrange.shade700;
    } else {
      doseSugerida = "Não indicada";
      status = "HbA1c dentro da meta (< 6.5%).";
      statusColor = Colors.green.shade700;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        // Título ajustado
        title: const Row(
          children: [
            Icon(Icons.recommend_outlined),
            SizedBox(width: 8),
            Text("Sugestão de Dose Inicial"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Paciente: ${patient.name}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Divider(height: 20, thickness: 1),
            
            Text("Parâmetros Clínicos:", style: Theme.of(context).textTheme.titleSmall),
            Text(" • HbA1c: ${patient.a1c}%"),
            Text(" • Status Renal: ${patient.renalFunctionStatus}"),
            const SizedBox(height: 16),

            Text("Recomendação (Protocolo Metformina):", style: Theme.of(context).textTheme.titleSmall),
            Text(" • Medicação: $medNome"),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: statusColor, width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: statusColor),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "DOSE INICIAL SUGERIDA:",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    doseSugerida,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Fechar"),
          )
        ],
      ),
    );
  }

  void _handleMenuSelection(String value, PatientModel patient) {
    switch (value) {
      case 'edit':
        Navigator.push(context, MaterialPageRoute(builder: (_) => PatientFormPage(patient: patient)));
        break;
      case 'assess':
        _showInitialAssessment(patient);
        break;
      case 'report':
        Navigator.push(context, MaterialPageRoute(builder: (_) => ReportPage(patient: patient)));
        break;
      case 'measure':
        Navigator.push(context, MaterialPageRoute(builder: (_) => MeasurementFormPage(patientId: patient.id)));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pacientes"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Buscar paciente",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<PatientModel>>(
              stream: _patientService.getAllPatientsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final allPatients = snapshot.data!;
                final filteredPatients = allPatients.where((patient) {
                  final nameLower = (patient.name ?? '').toLowerCase();
                  final queryLower = _searchQuery.toLowerCase();
                  return nameLower.contains(queryLower);
                }).toList();

                if (filteredPatients.isEmpty) {
                  return const Center(child: Text("Nenhum paciente encontrado."));
                }

                return ListView.builder(
                  itemCount: filteredPatients.length,
                  itemBuilder: (context, index) {
                    final patient = filteredPatients[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                      child: Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.person_outline),
                          ),
                          title: Text(
                            (patient.name ?? 'Paciente sem nome'), 
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                              "Idade: ${patient.age} | HbA1c: ${patient.a1c}%"),
                          trailing: PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert),
                            onSelected: (String value) {
                              _handleMenuSelection(value, patient);
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: 'measure',
                                child: ListTile(
                                    leading: Icon(Icons.add_chart),
                                    title: Text('Lançar Glicemia')),
                              ),
                              const PopupMenuItem<String>(
                                value: 'report',
                                child: ListTile(
                                    leading: Icon(Icons.assessment_outlined),
                                    title: Text('Relatório de Titulação')),
                              ),
                              const PopupMenuItem<String>(
                                value: 'assess',
                                child: ListTile(
                                    leading: Icon(Icons.recommend_outlined),
                                    title: Text('Sugestão de Dose Inicial')),
                              ),
                              const PopupMenuItem<String>(
                                value: 'edit',
                                child: ListTile(
                                    leading: Icon(Icons.edit_outlined),
                                    title: Text('Editar Cadastro')),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
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