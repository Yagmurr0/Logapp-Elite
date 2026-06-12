import 'package:flutter/material.dart';
import '../models/log_model.dart';
import '../services/mock_data_service.dart';
import '../widgets/glass_card.dart';

class SecurityPulseView extends StatelessWidget {
  const SecurityPulseView({super.key});

  Color _getSeverityColor(LogSeverity severity) {
    switch (severity) {
      case LogSeverity.critical: return const Color(0xFFFF1744); // Neon Kırmızı
      case LogSeverity.warning: return const Color(0xFFFFEA00); // Neon Sarı
      case LogSeverity.info: return const Color(0xFF00E5FF);    // Neon Cyan
      case LogSeverity.error: return const Color(0xFFFF4081);   // Neon Pembe
      case LogSeverity.fatal: return const Color(0xFF9C27B0); // Neon Mor
      case LogSeverity.debug: return const Color(0xFF9E9E9E); // Neon Gri
   }
  }

  @override
  Widget build(BuildContext context) {
    final service = MockDataService();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('SECURITY PULSE', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            const SizedBox(height: 4),
            Text('KOBİ Aktif Tehdit Avcılığı Merkezi', style: TextStyle(color: Colors.grey[500], fontSize: 13)),
            const SizedBox(height: 20),
            
            // Risk Skoru Kartı
            StreamBuilder<List<LogModel>>(
              stream: service.logStream,
              builder: (context, snapshot) {
                int riskScore = 100;
                if (snapshot.hasData) {
                  final recent = snapshot.data!.take(10);
                  final criticalCount = recent.where((l) => l.severity == LogSeverity.critical && !l.isBlocked).length;
                  final warningCount = recent.where((l) => l.severity == LogSeverity.warning && !l.isBlocked).length;
                  riskScore = (100 - (criticalCount * 15) - (warningCount * 5)).clamp(10, 100);
                }

                Color scoreColor = riskScore > 75 ? const Color(0xFF00FF88) : (riskScore > 45 ? const Color(0xFFFFEA00) : const Color(0xFFFF1744));

                return GlassCard(
                  borderColor: scoreColor.withOpacity(0.2),
                  child: Row(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 70,
                            height: 70,
                            child: CircularProgressIndicator(
                              value: riskScore / 100,
                              strokeWidth: 6,
                              valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                              backgroundColor: Colors.white.withOpacity(0.05),
                            ),
                          ),
                          Text('%$riskScore', style: TextStyle(color: scoreColor, fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Sistem Sağlık Durumu', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(
                              riskScore > 75 ? 'Tehdit Yok. Sistem tamamen güvenli.' : (riskScore > 45 ? 'Yüksek Risk! İnceleme Gerekli.' : 'KRİTİK DURUM: Aktif Saldırı Saptandı!'),
                              style: TextStyle(color: Colors.grey[400], fontSize: 12),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }
            ),
            
            const SizedBox(height: 24),
            const Text('Aktif Tehdit Matrisi', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            
            // Tehdit Avcılığı Listesi
            Expanded(
              child: StreamBuilder<List<LogModel>>(
                stream: service.logStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Color(0xFF00E5FF)));
                  
                  final securityLogs = snapshot.data!.where((l) => l.category == LogCategory.security).toList();

                  if (securityLogs.isEmpty) return const Center(child: Text('Temiz Sunucu Akışı...', style: TextStyle(color: Colors.grey)));

                  return ListView.builder(
                    itemCount: securityLogs.length,
                    itemBuilder: (context, index) {
                      final log = securityLogs[index];
                      final color = _getSeverityColor(log.severity);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Opacity(
                          opacity: log.isBlocked ? 0.4 : 1.0,
                          child: GlassCard(
                            borderColor: color.withOpacity(0.15),
                            padding: const EdgeInsets.all(12),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(Icons.gpp_bad, color: color, size: 28),
                              title: Text(log.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(log.details, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                                  const SizedBox(height: 6),
                                  Text('Kaynak IP: ${log.ipAddress}', style: const TextStyle(color: Color(0xFF00E5FF), fontSize: 11, fontFamily: 'monospace')),
                                ],
                              ),
                              trailing: log.isBlocked
                                  ? const Icon(Icons.check_circle, color: Color(0xFF00FF88))
                                  : ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: color.withOpacity(0.1),
                                        side: BorderSide(color: color, width: 1),
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        minimumSize: Size.zero,
                                      ),
                                      onPressed: () {
                                        service.blockIp(log.id);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            backgroundColor: const Color(0xFF1A1D26),
                                            content: Text('${log.ipAddress} ağ geçidinde engellendi!', style: const TextStyle(color: Color(0xFF00FF88))),
                                          ),
                                        );
                                      },
                                      child: const Text('Karantina', style: TextStyle(color: Colors.white, fontSize: 11)),
                                    ),
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
      ),
    );
  }
}