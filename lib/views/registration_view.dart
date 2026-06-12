import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/user_model.dart' show UserProfile;
import 'package:shared_preferences/shared_preferences.dart';
// Dosya yolların farklıysa buradaki importları düzeltmeyi unutma:
import '../services/user_service.dart'; 
import '../views/main_navigation_view.dart';

class RegistrationView extends StatelessWidget {
  // Kullanıcıdan bilgi alacak controller'lar
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _companyController = TextEditingController();
  final _positionController = TextEditingController();

  RegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kayıt Ol")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: _nameController, decoration: const InputDecoration(labelText: "İsim")),
              TextField(controller: _surnameController, decoration: const InputDecoration(labelText: "Soyisim")),
              TextField(controller: _emailController, decoration: const InputDecoration(labelText: "Email")),
              TextField(controller: _companyController, decoration: const InputDecoration(labelText: "Şirket")),
              TextField(controller: _positionController, decoration: const InputDecoration(labelText: "Pozisyon")),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  // 1. Kullanıcının girdiği verilerle modeli oluştur
                  final newUser = UserProfile(
                    email: _emailController.text,
                    firstName: _nameController.text,
                    lastName: _surnameController.text,
                    birthDate: DateTime.now(), // İstersen tarih seçici ekleyebilirsin
                    gender: "Belirtilmedi",
                    companyName: _companyController.text,
                    position: _positionController.text,
                  );

                  // 2. Veriyi anlık kullanım için servisimize kaydet
                  UserService().login(newUser);

                  // 3. Uygulama kapansa bile giriş yapmış sayılman için kaydet
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('userName', _nameController.text);

                  // 4. Ana sayfaya yönlendir
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MainNavigationView()),
                  );
                },
                child: const Text("Kaydet ve Giriş Yap"),
              )
            ],
          ),
        ),
      ),
    );
  }
}