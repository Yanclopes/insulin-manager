import 'package:flutter/material.dart';
import 'package:insulinmanager/core/models/case_data_model.dart';
import 'package:insulinmanager/core/models/patient_model.dart';
import 'package:insulinmanager/core/services/case_service.dart';
import 'package:intl/intl.dart';

class ReportPage extends StatefulWidget {
  final PatientModel patient;
  const ReportPage({Key? key, required this.patient}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final CaseService _caseService = CaseService();
  final DateFormat _timeFormat = DateFormat('HH:mm'); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Relatório de Hoje: ${widget.patient.name}"),
      ),
      body: StreamBuilder<List<CaseDataModel>>(
        stream: _caseService.getCasesForPatientToday(widget.patient.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Erro ao carregar: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Nenhuma medição encontrada hoje."));
          }

          final cases = snapshot.data!;

          return ListView.builder(
            itemCount: cases.length,
            itemBuilder: (context, index) {
              final caseItem = cases[index];
              final time = caseItem.createdAt.toDate();
              
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      _timeFormat.format(time),
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                    "Glicemia: ${caseItem.glicemiaAtual.toStringAsFixed(0)} mg/dL",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Correção: ${caseItem.insulinaCorrecao?.toStringAsFixed(1) ?? 'N/A'} UI\n"
                    "Recomendação: ${caseItem.recomendacao ?? 'Nenhuma'}"
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}