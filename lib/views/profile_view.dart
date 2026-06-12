import 'package:flutter/material.dart';
import '../services/user_service.dart'; // <--- BURAYI UNUTMA!
import 'package:shared_preferences/shared_preferences.dart'; // Çıkış yapmak için lazım

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // Servisten veriyi çekiyoruz
    final user = UserService().currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0E12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0E12),
        elevation: 0,
        title: const Text("Profil"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 👤 Kullanıcı bilgisi
            Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blueGrey,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // Gerçek veri:
                      user != null ? "${user.firstName} ${user.lastName}" : "Misafir",
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Text(
                      // Gerçek veri:
                      user?.email ?? "Email bulunamadı",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                )
              ],
            ),

            const SizedBox(height: 30),

            // ⚙️ Ayarlar
            const Text("Ayarlar", style: TextStyle(color: Colors.white, fontSize: 16)),
            const SizedBox(height: 10),

            ListTile(
              leading: const Icon(Icons.notifications, color: Colors.white),
              title: const Text("Bildirimler", style: TextStyle(color: Colors.white)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
            ),
            ListTile(
              leading: const Icon(Icons.lock, color: Colors.white),
              title: const Text("Gizlilik", style: TextStyle(color: Colors.white)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
            ),

            // ÇIKIŞ YAP Butonu
            ListTile(
              onTap: () async {
                // Çıkış yaparken hem servisi hem cihaz hafızasını temizle
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                UserService().currentUser = null;
                
                // Kullanıcıyı giriş ekranına geri gönder
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Çıkış Yap", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}