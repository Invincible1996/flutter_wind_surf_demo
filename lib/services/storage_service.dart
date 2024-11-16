import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyUser = 'user_data';
  
  static Future<void> saveUserData({
    required String email,
    required String displayName,
    required String avatarUrl,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = {
      'email': email,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
    };
    await prefs.setString(_keyUser, jsonEncode(userData));
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    // Check if user data exists
    final userDataString = prefs.getString(_keyUser);
    if (userDataString != null) {
      return jsonDecode(userDataString) as Map<String, dynamic>;
    }
    return null;
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUser);
  }
}
