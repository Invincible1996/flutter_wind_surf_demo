import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

abstract class StorageService {
  String get storageKey;
  
  Future<void> saveData(dynamic data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(storageKey, jsonEncode(data));
  }

  Future<T?> getData<T>() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString(storageKey);
    if (dataString != null) {
      return jsonDecode(dataString) as T;
    }
    return null;
  }

  Future<void> removeData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(storageKey);
  }

  static Future<Set<String>> getAllKeys() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getKeys();
  }
}

class UserStorageService extends StorageService {
  static final UserStorageService _instance = UserStorageService._internal();
  
  factory UserStorageService() {
    return _instance;
  }
  
  UserStorageService._internal();
  
  @override
  String get storageKey => 'user_data';
  
  Future<void> saveUserData({
    required String email,
    required String displayName,
    required String avatarUrl,
  }) async {
    final userData = {
      'email': email,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
    };
    await saveData(userData);
  }

  Future<Map<String, dynamic>?> getUserData() async {
    return getData<Map<String, dynamic>>();
  }

  Future<void> clearUserData() async {
    await removeData();
  }
}
