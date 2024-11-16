import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/theme_repository.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final SharedPreferences sharedPreferences;
  static const String _themeKey = 'theme_mode';

  ThemeRepositoryImpl(this.sharedPreferences);

  @override
  Future<bool> getThemeMode() async {
    return sharedPreferences.getBool(_themeKey) ?? false;
  }

  @override
  Future<void> setThemeMode(bool isDarkMode) async {
    await sharedPreferences.setBool(_themeKey, isDarkMode);
  }
}
