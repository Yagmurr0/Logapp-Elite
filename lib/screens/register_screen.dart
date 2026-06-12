import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../views/main_navigation_view.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _dobController = TextEditingController();
  final _positionController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _dobController.dispose();
    _positionController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> saveUser() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('name', _nameController.text);
    await prefs.setString('surname', _surnameController.text);
    await prefs.setString('dob', _dobController.text);
    await prefs.setString('position', _positionController.text);
    await prefs.setString('email', _emailController.text);
  }

  void handleRegister() async {
    if (_formKey.currentState!.validate()) {
      await saveUser();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainNavigationView(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0E12),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Icon(
                  Icons.shield_moon_outlined,
                  size: 80,
                  color: Color(0xFF00E5FF),
                ),
                const SizedBox(height: 20),

                const Text(
                  "OPERATÖR KAYIT",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                _buildTextField(_nameController, "İsim"),
                const SizedBox(height: 12),

                _buildTextField(_surnameController, "Soyisim"),
                const SizedBox(height: 12),

                _buildTextField(_dobController, "Doğum Tarihi"),
                const SizedBox(height: 12),

                _buildTextField(_positionController, "Pozisyon"),
                const SizedBox(height: 12),

                _buildTextField(_emailController, "Email", isEmail: true),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00E5FF),
                      foregroundColor: Colors.black,
                    ),
                    child: const Text("KOMUTA MERKEZİNİ BAŞLAT"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool isEmail = false,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white24),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF00E5FF)),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Bu alan zorunludur";
        }

        if (isEmail && !value.contains("@")) {
          return "Geçerli email gir";
        }

        return null;
      },
    );
  }
}