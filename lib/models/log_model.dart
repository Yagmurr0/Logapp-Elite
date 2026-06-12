enum LogSeverity { 
  info, 
  warning, 
  critical, 
  error, 
  fatal,    // Hata veren 'fatal' buraya eklendi
  debug     // Hata veren 'debug' buraya eklendi
}

enum LogCategory { 
  dev, 
  security, 
  server,   // Hata veren 'server' buraya eklendi
  database, // Hata veren 'database' buraya eklendi
  network,  // Hata veren 'network' buraya eklendi
  ui        // Hata veren 'ui' buraya eklendi
}
class LogModel {
  final String id;
  final DateTime timestamp;
  final String title;
  final String details;
  final String ipAddress;
  final LogSeverity severity;
  final LogCategory category;
  bool isBlocked;

  LogModel({
    required this.id,
    required this.timestamp,
    required this.title,
    required this.details,
    required this.ipAddress,
    required this.severity,
    required this.category,
    this.isBlocked = false,
  });
}

// Türkçe karşılıklarını getiren yardımcı extension'lar
extension LogSeverityExtension on LogSeverity {
  String get displayName {
    switch (this) {
      case LogSeverity.info: return "Bilgi";
      case LogSeverity.warning: return "Uyarı";
      case LogSeverity.critical: return "Kritik";
      case LogSeverity.error: return "Hata";
      case LogSeverity.fatal: return "Ölümcül";
      case LogSeverity.debug: return "Hata Ayıklama";
    }
  }
}

extension LogCategoryExtension on LogCategory {
  String get displayName {
    switch (this) {
      case LogCategory.dev: return "Geliştirici";
      case LogCategory.security: return "Güvenlik";
      case LogCategory.server: return "Sunucu";
      case LogCategory.database: return "Veritabanı";
      case LogCategory.network: return "Ağ";
      case LogCategory.ui: return "Arayüz";
    }
  }
}