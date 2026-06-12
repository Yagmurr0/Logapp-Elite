// lib/services/user_service.dart

// 1. Model sınıfın (Zaten dosyanın içindeydi)
class UserProfile {
  final String email;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final String gender;
  final String companyName;
  final String position;

  UserProfile({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.gender,
    required this.companyName,
    required this.position,
  });
}

// 2. Servis sınıfın (Bunu da aynı dosyanın altına ekle)
class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  UserProfile? currentUser;

  void login(UserProfile user) {
    currentUser = user;
  }
}