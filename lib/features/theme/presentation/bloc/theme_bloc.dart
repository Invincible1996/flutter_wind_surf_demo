import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/theme_repository.dart';
import 'theme_state.dart';
import 'theme_event.dart';

// Bloc
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final ThemeRepository themeRepository;

  ThemeBloc({required this.themeRepository}) : super(const ThemeState()) {
    on<LoadTheme>(_onInitializeTheme);
    on<ToggleThemeEvent>(_onToggleTheme);
  }

  Future<void> _onInitializeTheme(LoadTheme event, Emitter<ThemeState> emit) async {
    final isDarkMode = await themeRepository.getThemeMode();
    emit(state.copyWith(isDarkMode: isDarkMode));
  }

  Future<void> _onToggleTheme(ToggleThemeEvent event, Emitter<ThemeState> emit) async {
    final newThemeMode = !state.isDarkMode;
    await themeRepository.setThemeMode(newThemeMode);
    emit(state.copyWith(isDarkMode: newThemeMode));
  }
}
