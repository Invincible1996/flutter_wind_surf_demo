import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<bool> {
  final SharedPreferences prefs;
  static const String _darkModeKey = 'dark_mode';

  ThemeCubit(this.prefs) : super(prefs.getBool(_darkModeKey) ?? false);

  void toggleTheme() {
    final isDark = !state;
    emit(isDark);
    prefs.setBool(_darkModeKey, isDark);
  }
}
