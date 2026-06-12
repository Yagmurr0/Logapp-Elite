import 'package:uuid/uuid.dart';
import 'dart:async';
import 'dart:math';
import '../models/log_model.dart';

class MockDataService {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal();

  final _random = Random();
  Timer? _timer;

  final _logStreamController = StreamController<List<LogModel>>.broadcast();
  final _metricsStreamController = StreamController<List<ServerMetric>>.broadcast();

  List<LogModel> _allLogs = [];
  List<ServerMetric> _metricsHistory = [];

  Stream<List<LogModel>> get logStream => _logStreamController.stream;
  Stream<List<ServerMetric>> get metricsStream => _metricsStreamController.stream;

  final List<Map<String, dynamic>> _eliteLogs = [
    {"t": "Brute Force Saldırısı", "d": "Admin paneline deneme-yanılma saldırısı tespit edildi.", "s": LogSeverity.critical},
    {"t": "Veritabanı Kilitlenmesi", "d": "İşlemler birbirini kilitledi, erişim yok.", "s": LogSeverity.critical},
    {"t": "Yetkisiz Erişim Girişimi", "d": "Root dosyalarına sızmaya çalışan bir ID saptandı.", "s": LogSeverity.critical},
    {"t": "RAM Bellek Sınırı", "d": "Uygulama hafızası doldu, çökme riski var.", "s": LogSeverity.critical},
    {"t": "DDoS Saldırı Dalgası", "d": "Sunucuya saniyede 500 bin sahte istek atılıyor.", "s": LogSeverity.critical},
    {"t": "Veri Sızdırma Girişimi", "d": "Gece yarısı güvenli alandan veri çalınmaya çalışıldı.", "s": LogSeverity.critical},
    {"t": "SSL Sertifika İhlali", "d": "Ortadaki adam (MitM) saldırısı şüphesi var.", "s": LogSeverity.critical},
    {"t": "Güvenlik Duvarı Aşıldı", "d": "Çekirdek seviyesinde kurallar değiştirilmeye çalışıldı.", "s": LogSeverity.critical},
    {"t": "Fidye Yazılımı Tespit Edildi", "d": "Dosyalar şifrelenmeye çalışılıyor, işlem durduruldu.", "s": LogSeverity.critical},
    {"t": "Soğutma Sistemi Hatası", "d": "Sunucu odası kritik sıcaklığa ulaştı, acil durum modu.", "s": LogSeverity.critical},
    {"t": "Şüpheli Konumdan Giriş", "d": "Yönetici hesabı beklenmedik bir VPN ile bağlanıyor.", "s": LogSeverity.warning},
    {"t": "İşlemci Aşırı Isındı", "d": "CPU sıcaklığı 78 dereceye ulaştı, sistem yavaşlatıldı.", "s": LogSeverity.warning},
    {"t": "Hatalı Şifre Girişi", "d": "3 kez üst üste yanlış şifre girildi, hesap kitleniyor.", "s": LogSeverity.warning},
    {"t": "Eski API Sürümü", "d": "Sistem eski bir sürümle bağlanıyor, güncelleme lazım.", "s": LogSeverity.warning},
    {"t": "Büyük Dosya Yüklemesi", "d": "Misafir kullanıcı şüpheli büyüklükte dosya gönderiyor.", "s": LogSeverity.warning},
    {"t": "Yavaş Veritabanı Sorgusu", "d": "Bir sorgu 1.5 saniyeden uzun sürdü, indeksleme şart.", "s": LogSeverity.warning},
    {"t": "Oturum Zaman Aşımı", "d": "Kullanıcı 25 dakikadır hareketsiz, oturum sonlanacak.", "s": LogSeverity.warning},
    {"t": "Paket Kaybı Saptandı", "d": "Uluslararası hatta veri paketleri kayboluyor.", "s": LogSeverity.warning},
    {"t": "API Limit Uyarısı", "d": "Kullanıcı saatlik limitinin %90'ına ulaştı.", "s": LogSeverity.warning},
    {"t": "Sertifika Süresi Doluyor", "d": "SSL sertifikasının bitmesine 7 gün kaldı.", "s": LogSeverity.warning},
    {"t": "Veritabanı Çöktü", "d": "Ana sunucuyla bağlantı koptu, yeniden bağlanılıyor.", "s": LogSeverity.error},
    {"t": "Ödeme API Hatası", "d": "Ödeme sistemi yanıt vermiyor, işlemler durdu.", "s": LogSeverity.error},
    {"t": "Disk Yazma İzni Reddi", "d": "Sistem log dosyasına kayıt yazamıyor, yetki hatası.", "s": LogSeverity.error},
    {"t": "Kullanıcı Kayıt Çakışması", "d": "Bu e-posta adresi sistemde zaten kayıtlı.", "s": LogSeverity.error},
    {"t": "Kütüphane Hatası", "d": "Şifreleme kütüphanesi yüklenemedi, işlem koptu.", "s": LogSeverity.error},
    {"t": "Sunucu Zaman Aşımı", "d": "Doğrulama sunucusu 10 saniye boyunca hiç yanıt vermedi.", "s": LogSeverity.error},
    {"t": "Sonsuz Döngü Hatası", "d": "Akış sunucusu sürekli çöküyor, resetlenemiyor.", "s": LogSeverity.error},
    {"t": "Mail Gönderim Hatası", "d": "E-posta sunucusu bağlantıyı reddetti.", "s": LogSeverity.error},
    {"t": "Veri Okuma Hatası", "d": "Sunucudan gelen bilgi bozuk çıktı, parse edilemedi.", "s": LogSeverity.error},
    {"t": "Önbellek Doldu", "d": "Hızlı önbellek alanı tamamen kilitlendi.", "s": LogSeverity.error},
    {"t": "Ayar Dosyası Bozuk", "d": "Ayarlar dosyası okunamıyor, varsayılana dönüldü.", "s": LogSeverity.error},
    {"t": "Kamera Modülü Hatası", "d": "Kamera şu an başka bir uygulama tarafından kullanılıyor.", "s": LogSeverity.error},
    {"t": "DNS Çözümleme Hatası", "d": "Sunucu adresi bulunamadı, internet ayarını kontrol et.", "s": LogSeverity.error},
    {"t": "Arayüz Taşıma Hatası", "d": "Ekrandaki yazılar kutunun dışına taştı.", "s": LogSeverity.error},
    {"t": "Güvenli Giriş Onaylandı", "d": "İki aşamalı doğrulama başarıyla geçildi.", "s": LogSeverity.info},
    {"t": "Yedekleme Tamam", "d": "Gece yarısı yedeği buluta başarıyla yüklendi.", "s": LogSeverity.info},
    {"t": "Güvenlik Duvarı Güncellendi", "d": "1420 yeni zararlı IP kara listeye eklendi.", "s": LogSeverity.info},
    {"t": "TLS Şifreleme Aktif", "d": "En güncel şifreleme protokolü devrede.", "s": LogSeverity.info},
    {"t": "DDoS Kalkanı Başarılı", "d": "50 bin sahte istek başarıyla emildi.", "s": LogSeverity.info},
    {"t": "Analist Yetki Güncellemesi", "d": "Analist yetkileri kısıtlandı, sistem güvende.", "s": LogSeverity.info},
    {"t": "Yapay Zeka Taraması", "d": "1 milyon paket tarandı, hiçbir tehdit yok.", "s": LogSeverity.info},
    {"t": "Veritabanı Temizlendi", "d": "Süresi dolmuş 50 bin eski oturum silindi.", "s": LogSeverity.info},
    {"t": "Güvenlik Yaması Yüklendi", "d": "Sistem kesintisiz olarak güncellendi.", "s": LogSeverity.info},
    {"t": "Log Arşivi Sıkıştırıldı", "d": "30 günden eski loglar arşivlendi, yer açıldı.", "s": LogSeverity.info},
    {"t": "Güvenli Çıkış", "d": "Analist sistemden güvenli bir şekilde ayrıldı.", "s": LogSeverity.info},
    {"t": "Senkronizasyon Başarılı", "d": "Yerel loglar sunucuyla hatasız birleşti.", "s": LogSeverity.info},
    {"t": "Sistem Sağlığı Tam", "d": "Tüm servisler tıkır tıkır çalışıyor.", "s": LogSeverity.info},
    {"t": "Lisans Yenilendi", "d": "Kurumsal lisans süresi başarıyla uzatıldı.", "s": LogSeverity.info},
  ];

  void startSimulating() {
    _generateInitialData();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _generateNewLog();
      _generateNewMetrics();
    });
  }

  void stopSimulating() {
    _timer?.cancel();
  }

  void _generateInitialData() {
    for (int i = 0; i < 20; i++) {
      _allLogs.insert(0, _createRandomLog(DateTime.now().subtract(Duration(seconds: i * 5))));
    }
    _logStreamController.add(List.from(_allLogs));

    for (int i = 10; i >= 0; i--) {
      _metricsHistory.add(ServerMetric(
        time: DateTime.now().subtract(Duration(seconds: i)),
        cpuUsage: 20.0 + _random.nextDouble() * 40.0,
        ramUsage: 45.0 + _random.nextDouble() * 20.0,
      ));
    }
    _metricsStreamController.add(List.from(_metricsHistory));
  }

  void _generateNewLog() {
    final newLog = _createRandomLog(DateTime.now());
    _allLogs.insert(0, newLog);
    if (_allLogs.length > 100) _allLogs.removeLast();
    _logStreamController.add(List.from(_allLogs));
  }

  void _generateNewMetrics() {
    final lastMetric = _metricsHistory.last;
    double nextCpu = lastMetric.cpuUsage + (_random.nextDouble() * 10 - 5);
    double nextRam = lastMetric.ramUsage + (_random.nextDouble() * 6 - 3);

    nextCpu = nextCpu.clamp(5.0, 98.0);
    nextRam = nextRam.clamp(10.0, 95.0);

    _metricsHistory.add(ServerMetric(
      time: DateTime.now(),
      cpuUsage: nextCpu,
      ramUsage: nextRam,
    ));

    if (_metricsHistory.length > 15) _metricsHistory.removeAt(0);
    _metricsStreamController.add(List.from(_metricsHistory));
  }

  LogModel _createRandomLog(DateTime time) {
    final randomEntry = _eliteLogs[_random.nextInt(_eliteLogs.length)];
    return LogModel(
      id: "${time.millisecondsSinceEpoch}_${_random.nextInt(1000)}",
      timestamp: time,
      title: randomEntry["t"],
      details: randomEntry["d"],
      ipAddress: "192.168.1.${_random.nextInt(254)}",
      severity: randomEntry["s"],
      category: LogCategory.values[_random.nextInt(LogCategory.values.length)],
    );
  }

  void blockIp(String logId) {
    final index = _allLogs.indexWhere((l) => l.id == logId);
    if (index != -1) {
      _allLogs[index].isBlocked = true;
      _logStreamController.add(List.from(_allLogs));
    }
  }
} // <--- MockDataService sınıfı burada biter.

class ServerMetric {
  final DateTime time;
  final double cpuUsage;
  final double ramUsage;

  ServerMetric({
    required this.time,
    required this.cpuUsage,
    required this.ramUsage,
  });
}