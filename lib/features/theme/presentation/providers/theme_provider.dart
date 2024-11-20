import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/theme_repository.dart';
import '../../data/repositories/theme_repository_impl.dart';

part 'theme_provider.g.dart';

@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  Future<bool> build() async {
    return ref.watch(themeRepositoryProvider).getThemeMode();
  }

  Future<void> toggleTheme() async {
    final currentMode = await future;
    final newMode = !currentMode;
    await ref.read(themeRepositoryProvider).setThemeMode(newMode);
    state = AsyncValue.data(newMode);
  }
}

// Repository provider
final themeRepositoryProvider = Provider<ThemeRepository>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return ThemeRepositoryImpl(sharedPreferences);
});

// SharedPreferences provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize this in your main.dart');
});
