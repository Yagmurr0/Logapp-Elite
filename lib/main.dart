import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/register_screen.dart'; // Kayıt ekranın
import 'views/main_navigation_view.dart'; // Ana ekranın

void main() {
  runApp(const SecurityLogApp());
}

class SecurityLogApp extends StatelessWidget {
  const SecurityLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KOBİ Log Komuta Merkezi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0E12),
        useMaterial3: true,
      ),
      // İşte kontrol mekanizması burada başlıyor:
      home: const AuthCheck(),
    );
  }
}

// Bu widget, uygulama açılır açılmaz kullanıcı kayıtlı mı diye bakar
class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        
        final prefs = snapshot.data!;
        final String? userName = prefs.getString('userName');

        // Eğer kullanıcı adı boşsa kayıt ekranına, doluysa ana ekrana git
        if (userName == null || userName.isEmpty) {
          return const RegisterScreen(); 
        } else {
          return const MainNavigationView();
        }
      },
    );
  }
}