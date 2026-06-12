import 'package:flutter/material.dart';
import '../services/mock_data_service.dart';
import 'security_pulse_view.dart';
import 'live_stream_view.dart';
import 'dev_logs_view.dart';
import 'server_health_view.dart';
import 'profile_view.dart';

class MainNavigationView extends StatefulWidget {
  const MainNavigationView({super.key});

  @override
  State<MainNavigationView> createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends State<MainNavigationView> {
  int _currentIndex = 0;
  final MockDataService _dataService = MockDataService();
  late final List<Widget> _views;

  @override
  void initState() {
    super.initState();
    _dataService.startSimulating();
    _views = [
      const SecurityPulseView(),
      const LiveStreamView(),
      const DevLogsView(),
      const ServerHealthView(),
      ProfileView(), // Hata düzeldi: const kaldırıldı
    ];
  }

  @override
  void dispose() {
    _dataService.stopSimulating();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0E12),
      body: IndexedStack(
        index: _currentIndex,
        children: _views,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05), width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: const Color(0xFF0D0E12),
          selectedItemColor: const Color(0xFF00E5FF),
          unselectedItemColor: Colors.grey.withOpacity(0.6),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.shield_outlined), activeIcon: Icon(Icons.shield), label: 'Pulse'),
            BottomNavigationBarItem(icon: Icon(Icons.terminal_outlined), activeIcon: Icon(Icons.terminal), label: 'Stream'),
            BottomNavigationBarItem(icon: Icon(Icons.bug_report_outlined), activeIcon: Icon(Icons.bug_report), label: 'DevLogs'),
            BottomNavigationBarItem(icon: Icon(Icons.dns_outlined), activeIcon: Icon(Icons.dns), label: 'Server'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}