import 'package:flutter/material.dart';
import 'package:insulinmanager/core/models/measurement_model.dart';
import 'package:insulinmanager/core/models/patient_model.dart';
import 'package:insulinmanager/core/services/measurement_service.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ReportPage extends StatefulWidget {
  final PatientModel patient;
  const ReportPage({Key? key, required this.patient}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final MeasurementService _measurementService = MeasurementService();

  Widget _buildReport(List<MeasurementModel> allMeasurements) {
    // ... (Lógica de cálculo é a mesma)
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    final recentFastingMeasurements = allMeasurements.where((m) {
      return m.isFasting && m.createdAt.toDate().isAfter(sevenDaysAgo);
    }).toList();

    if (recentFastingMeasurements.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "Não há registros de Glicemia de Jejum (GJ) nos últimos 7 dias.",
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final sum = recentFastingMeasurements.fold(
        0.0, (prev, m) => prev + m.glucoseValue);
    final average = sum / recentFastingMeasurements.length;

    // --- LÓGICA DE TEXTO CLÍNICO ---
    String recomendacao = "";
    Color recomendacaoColor = Colors.blue.shade800;
    IconData recomendacaoIcon = Icons.info_outline;
    
    const double metaMin = 80.0;
    const double metaMax = 130.0;
    const double hipoAlert = 70.0;

    bool hasHipo =
        recentFastingMeasurements.any((m) => m.glucoseValue < hipoAlert);

    if (hasHipo) {
      recomendacao =
          "ALERTA: Episódio de Hipoglicemia (< $hipoAlert) detectado. Recomenda-se redução de dose imediata e reavaliação do paciente.";
      recomendacaoColor = Colors.red.shade800;
      recomendacaoIcon = Icons.warning_amber_rounded;
    } else if (average > metaMax) {
      recomendacao =
          "Média GJ acima da meta (${average.toStringAsFixed(1)}). Recomenda-se titular (aumentar) dose conforme protocolo.";
      recomendacaoColor = Colors.orange.shade800;
      recomendacaoIcon = Icons.trending_up;
    } else if (average >= metaMin && average <= metaMax) {
      recomendacao =
          "Controle Glicêmico na Meta (${average.toStringAsFixed(1)} mg/dL). Manter posologia atual.";
      recomendacaoColor = Colors.green.shade800;
      recomendacaoIcon = Icons.check_circle_outline;
    } else if (average < metaMin) {
      recomendacao =
          "Média GJ abaixo da meta (${average.toStringAsFixed(1)}). Risco de hipoglicemia. Recomenda-se considerar redução de dose.";
      recomendacaoColor = Colors.amber.shade800;
      recomendacaoIcon = Icons.trending_down;
    }
    // --- FIM DA LÓGICA DE TEXTO ---

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Relatório de Titulação: ${widget.patient.name}",
              style: Theme.of(context).textTheme.headlineSmall),
          Text("Média de Glicemia de Jejum (GJ) - Últimos 7 dias."),
          const SizedBox(height: 24),

          Center(
            child: SizedBox(
              height: 300,
              child: SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                    minimum: 40,
                    maximum: 250,
                    ranges: <GaugeRange>[
                      GaugeRange(startValue: 40, endValue: hipoAlert, color: Colors.red.shade400),
                      GaugeRange(startValue: hipoAlert, endValue: metaMin, color: Colors.amber.shade400),
                      GaugeRange(startValue: metaMin, endValue: metaMax, color: Colors.green.shade400),
                      GaugeRange(startValue: metaMax, endValue: 180, color: Colors.orange.shade400),
                      GaugeRange(startValue: 180, endValue: 250, color: Colors.red.shade400),
                    ],
                    pointers: <GaugePointer>[
                      NeedlePointer(
                        value: average,
                        enableAnimation: true,
                        animationDuration: 1000,
                        needleStartWidth: 1,
                        needleEndWidth: 5,
                        knobStyle: KnobStyle(knobRadius: 0.08),
                      )
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                        widget: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              average.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: recomendacaoColor,
                              ),
                            ),
                            const Text(
                              "Média GJ", // Texto atualizado
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            )
                          ],
                        ),
                        angle: 90,
                        positionFactor: 0.5,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),

          Wrap(
            spacing: 12.0,
            runSpacing: 12.0,
            alignment: WrapAlignment.center,
            children: [
              _InfoCard(
                title: "HbA1c de Base", // Texto atualizado
                value: "${widget.patient.a1c}%",
                icon: Icons.bloodtype_outlined,
                iconColor: Colors.red,
              ),
              _InfoCard(
                title: "Registros GJ (7d)", // Texto atualizado
                value: recentFastingMeasurements.length.toString(),
                icon: Icons.add_chart_outlined,
                iconColor: Colors.blue,
              ),
            ],
          ),

          const SizedBox(height: 24),

          Text(
            "Recomendação de Ajuste:", // Texto atualizado
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: recomendacaoColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: recomendacaoColor, width: 2),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(recomendacaoIcon, color: recomendacaoColor, size: 30),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    recomendacao, // Texto atualizado
                    style: TextStyle(
                      color: recomendacaoColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ... (O StreamBuilder não muda, só o _buildReport)
    return Scaffold(
      appBar: AppBar(title: const Text("Relatório de Titulação")),
      body: StreamBuilder<List<MeasurementModel>>(
        stream: _measurementService.getMeasurementsStreamForPatient(widget.patient.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Erro ao carregar medições: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Nenhum registro de GJ encontrado."));
          }
          final measurements = snapshot.data!;
          return _buildReport(measurements);
        },
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _InfoCard({
    required this.title,
    required this.value,
    required this.icon,
    this.iconColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 32, color: iconColor),
              const SizedBox(height: 12),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}