import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/user.dart';

class AuthLocalStorage {
  final SharedPreferences _prefs;
  static const String _userKey = 'user_data';

  AuthLocalStorage(this._prefs);

  Future<void> saveUser(User user) async {
    final userData = {
      'id': user.id,
      'email': user.email,
      'name': user.name,
      // Add any other user data you want to persist
    };
    await _prefs.setString(_userKey, jsonEncode(userData));
  }

  Future<User?> getUser() async {
    final userString = _prefs.getString(_userKey);
    if (userString == null) return null;

    final userData = jsonDecode(userString) as Map<String, dynamic>;
    return User(
      id: userData['id'] ?? '',  // Provide default empty string if null
      email: userData['email'] ?? '',  // Provide default empty string if null
      name: userData['name'],  // name is already optional in User class
    );
  }

  Future<void> clearUser() async {
    await _prefs.remove(_userKey);
  }
}
