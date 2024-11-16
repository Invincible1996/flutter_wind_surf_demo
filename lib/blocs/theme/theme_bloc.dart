import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final SharedPreferences _prefs;
  static const _themeKey = 'isDarkMode';

  ThemeBloc(this._prefs) : super(ThemeState(
    isDarkMode: _prefs.getBool(_themeKey) ?? false,
  )) {
    on<ToggleTheme>(_onToggleTheme);
    on<LoadTheme>(_onLoadTheme);
  }

  void _onToggleTheme(ToggleTheme event, Emitter<ThemeState> emit) {
    final newIsDarkMode = !state.isDarkMode;
    _prefs.setBool(_themeKey, newIsDarkMode);
    emit(state.copyWith(isDarkMode: newIsDarkMode));
  }

  void _onLoadTheme(LoadTheme event, Emitter<ThemeState> emit) {
    final isDarkMode = _prefs.getBool(_themeKey) ?? false;
    emit(state.copyWith(isDarkMode: isDarkMode));
  }
}
