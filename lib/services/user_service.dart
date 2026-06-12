import 'package:flutter_application_1/models/user_model.dart' show UserProfile;

class UserService {
  // Singleton yapısı: Her yerden tek bir instance'a erişim sağlar
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  UserProfile? currentUser;

  void login(UserProfile user) {
    currentUser = user;
  }
}