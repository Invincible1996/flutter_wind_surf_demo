import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/repositories/theme_repository.dart';

// Events
abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class ToggleThemeEvent extends ThemeEvent {}

class InitializeThemeEvent extends ThemeEvent {}

// State
class ThemeState extends Equatable {
  final bool isDarkMode;

  const ThemeState({this.isDarkMode = false});

  ThemeState copyWith({bool? isDarkMode}) {
    return ThemeState(isDarkMode: isDarkMode ?? this.isDarkMode);
  }

  @override
  List<Object> get props => [isDarkMode];
}

// Bloc
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final ThemeRepository themeRepository;

  ThemeBloc({required this.themeRepository}) : super(const ThemeState()) {
    on<InitializeThemeEvent>(_onInitializeTheme);
    on<ToggleThemeEvent>(_onToggleTheme);
  }

  Future<void> _onInitializeTheme(InitializeThemeEvent event, Emitter<ThemeState> emit) async {
    final isDarkMode = await themeRepository.getThemeMode();
    emit(state.copyWith(isDarkMode: isDarkMode));
  }

  Future<void> _onToggleTheme(ToggleThemeEvent event, Emitter<ThemeState> emit) async {
    final newThemeMode = !state.isDarkMode;
    await themeRepository.setThemeMode(newThemeMode);
    emit(state.copyWith(isDarkMode: newThemeMode));
  }
}
