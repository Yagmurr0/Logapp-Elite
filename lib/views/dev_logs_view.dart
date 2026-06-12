import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/log_model.dart';
import '../services/mock_data_service.dart';
import '../widgets/glass_card.dart';

class DevLogsView extends StatefulWidget {
  const DevLogsView({super.key});

  @override
  State<DevLogsView> createState() => _DevLogsViewState();
}

class _DevLogsViewState extends State<DevLogsView> {
  final service = MockDataService();
  LogSeverity? _filterSeverity;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('SİSTEM ÇÖKME ANALİZ MERKEZİ', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1)),
            Text('Operasyonel Hata ve Donanım Analizi', style: TextStyle(color: Colors.grey[500], fontSize: 13)),
            const SizedBox(height: 20),
            
            Row(
              children: [
                _buildFilterButton(null, "Tümü"),
                const SizedBox(width: 8),
                _buildFilterButton(LogSeverity.critical, "Kritik"),
              ],
            ),
            const SizedBox(height: 10),

            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Risk Altındaki Cihaz Envanteri', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 150,
                    child: BarChart(
                      BarChartData(
                        borderData: FlBorderData(show: false),
                        gridData: const FlGridData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                const style = TextStyle(color: Colors.grey, fontSize: 10, fontFamily: 'monospace');
                                switch (value.toInt()) {
                                  case 0: return const Text('Pixel 5', style: style);
                                  case 1: return const Text('iPhone15', style: style);
                                  case 2: return const Text('GalaxyS24', style: style);
                                  default: return const Text('');
                                }
                              },
                            ),
                          ),
                        ),
                        barGroups: [
                          BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 8, color: const Color(0xFF00E5FF), width: 16, borderRadius: BorderRadius.circular(4))]),
                          BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 3, color: const Color(0xFFFFEA00), width: 16, borderRadius: BorderRadius.circular(4))]),
                          BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 5, color: const Color(0xFFFF1744), width: 16, borderRadius: BorderRadius.circular(4))]),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            const Text('Sistem Günlük Akışı', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            
            Expanded(
              child: StreamBuilder<List<LogModel>>(
                stream: service.logStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  
                  var devLogs = snapshot.data!.where((l) => l.category == LogCategory.dev).toList();
                  if (_filterSeverity != null) {
                    devLogs = devLogs.where((l) => l.severity == _filterSeverity).toList();
                  }

                  return ListView.builder(
                    itemCount: devLogs.length,
                    itemBuilder: (context, index) {
                      final log = devLogs[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: GlassCard(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          child: Row(
                            children: [
                              Icon(
                                log.severity == LogSeverity.critical ? Icons.dangerous : Icons.warning_amber_rounded,
                                color: log.severity == LogSeverity.critical ? const Color(0xFFFF1744) : const Color(0xFFFFEA00),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(log.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                    Text(log.details, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.share_rounded, color: Colors.white54, size: 20),
                                onPressed: () {},
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

  Widget _buildFilterButton(LogSeverity? severity, String label) {
    final isSelected = _filterSeverity == severity;
    return GestureDetector(
      onTap: () => setState(() => _filterSeverity = severity),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00E5FF) : Colors.white10,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label, style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}