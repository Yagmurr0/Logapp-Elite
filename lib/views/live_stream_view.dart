import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/log_model.dart';
import '../services/mock_data_service.dart';

class LiveStreamView extends StatelessWidget {
  const LiveStreamView({super.key});

String _getCategoryPrefix(LogCategory category) {
  switch (category) { 
    case LogCategory.security:
      return '[SEC_ENG]';
    case LogCategory.dev:
      return '[DEV_CRASH]';
    case LogCategory.server:
      return '[SYS_ALRT]';
    case LogCategory.database:
      return '[DB_LOG]';
    case LogCategory.network:
      return '[NET_LOG]';
    case LogCategory.ui:
      return '[UI_LOG]';
  }
}

  Color _getSeverityColor(LogSeverity severity) {
    switch (severity) {
      case LogSeverity.critical:
        return const Color(0xFFFF1744);
      case LogSeverity.warning:
        return const Color(0xFFFFEA00);
      case LogSeverity.info:
        return const Color(0xFF00FF88);
      case LogSeverity.error:
        return const Color(0xFFFF5252);
       case LogSeverity.fatal:
        return const Color(0xFF9C27B0);
      case LogSeverity.debug: 
        return const Color(0xFF9E9E9E);
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = MockDataService();

    return SafeArea(
      child: Container(
        color: const Color(0xFF050608), // Obsidian black
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.terminal, color: Color(0xFF00E5FF), size: 20),
                const SizedBox(width: 8),
                const Text(
                  'CENTRAL_LOG_STREAM.sh',
                  style: TextStyle(
                      color: Color(0xFF00E5FF),
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                const Spacer(),
                Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                        color: Color(0xFF00FF88), shape: BoxShape.circle)),
                const SizedBox(width: 4),
                const Text('LIVE',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                        fontFamily: 'monospace')),
              ],
            ),
            const Divider(color: Colors.white12, height: 16),
            Expanded(
              child: StreamBuilder<List<LogModel>>(
                stream: service.logStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                        child: CircularProgressIndicator(
                            color: Color(0xFF00E5FF)));
                  }

                  return ListView.builder(
                    reverse: false,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final log = snapshot.data![index];
                      final timeStr = DateFormat('HH:mm:ss').format(log.timestamp);
                      final prefix = _getCategoryPrefix(log.category);
                      final color = _getSeverityColor(log.severity);

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Text(
                          '$timeStr $prefix ${log.title} -> ${log.details} [IP: ${log.ipAddress}]',
                          style: TextStyle(
                            color: color.withOpacity(log.isBlocked ? 0.3 : 1.0),
                            fontFamily: 'monospace',
                            fontSize: 12,
                            decoration: log.isBlocked
                                ? TextDecoration.lineThrough
                                : null,
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