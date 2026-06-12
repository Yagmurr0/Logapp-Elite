import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/log_model.dart';
import '../services/mock_data_service.dart';
import '../widgets/glass_card.dart';

class ServerHealthView extends StatelessWidget {
  const ServerHealthView({super.key});

  @override
  Widget build(BuildContext context) {
    final service = MockDataService();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('INFRASTRUCTURE MONITOR', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1)),
            Text('Merkezi Sunucu Donanım Sağlığı (Real-Time)', style: TextStyle(color: Colors.grey[500], fontSize: 13)),
            const SizedBox(height: 20),
            
            // Canlı Dalgalanan Çizgi Grafik (LineChart Entegrasyonu)
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Donanım Kaynak Tüketim Grafiği', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(width: 10, height: 10, color: const Color(0xFF00E5FF)),
                      const SizedBox(width: 4),
                      const Text('CPU %', style: TextStyle(color: Colors.grey, fontSize: 11)),
                      const SizedBox(width: 16),
                      Container(width: 10, height: 10, color: const Color(0xFFFF1744)),
                      const SizedBox(width: 4),
                      const Text('RAM %', style: TextStyle(color: Colors.grey, fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 180,
                    child: StreamBuilder<List<ServerMetric>>(
                      stream: service.metricsStream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        final metrics = snapshot.data!;
                        List<FlSpot> cpuSpots = [];
                        List<FlSpot> ramSpots = [];

                        for (int i = 0; i < metrics.length; i++) {
                          cpuSpots.add(FlSpot(i.toDouble(), metrics[i].cpuUsage));
                          ramSpots.add(FlSpot(i.toDouble(), metrics[i].ramUsage));
                        }

                        return LineChart(
                          LineChartData(
                            lineTouchData: const LineTouchData(enabled: false),
                            gridData: const FlGridData(show: false),
                            borderData: FlBorderData(show: false),
                            titlesData: const FlTitlesData(
                              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                            lineBarsData: [
                              LineChartBarData(spots: cpuSpots, isCurved: true, color: const Color(0xFF00E5FF), barWidth: 3, dotData: const FlDotData(show: false)),
                              LineChartBarData(spots: ramSpots, isCurved: true, color: const Color(0xFFFF1744), barWidth: 3, dotData: const FlDotData(show: false)),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            const Text('Sistem Kritik Alarmları', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            
            // Sistem Alarmları Listesi
            Expanded(
              child: StreamBuilder<List<LogModel>>(
                stream: service.logStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  
                  final serverLogs = snapshot.data!.where((l) => l.category == LogCategory.server).toList();

                  return ListView.builder(
                    itemCount: serverLogs.length,
                    itemBuilder: (context, index) {
                      final log = serverLogs[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: GlassCard(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(log.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                  const SizedBox(height: 2),
                                  Text(log.details, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                                ],
                              ),
                              Icon(
                                log.severity == LogSeverity.info ? Icons.check_circle_outline : Icons.report_problem_outlined,
                                color: log.severity == LogSeverity.info ? const Color(0xFF00FF88) : const Color(0xFFFF1744),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}