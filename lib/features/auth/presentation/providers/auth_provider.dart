import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/theme/presentation/providers/theme_provider.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/datasources/auth_local_storage.dart';
import '../../domain/usecases/login.dart';

// Check login status provider
final checkLoginProvider = FutureProvider.autoDispose<bool>((ref) async {
  final repository = ref.watch(authRepositoryProvider);
  final result = await repository.getCurrentUser();
  return result.fold(
    (failure) => false,
    (user) => true,
  );
});

final authLocalStorageProvider = Provider<AuthLocalStorage>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return AuthLocalStorage(prefs);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final localStorage = ref.watch(authLocalStorageProvider);
  return AuthRepositoryImpl(localDataSource: localStorage);
});

final loginUseCaseProvider = Provider<Login>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return Login(repository);
});

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AsyncValue<bool>>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  final loginUseCase = ref.watch(loginUseCaseProvider);
  return AuthNotifier(repository, loginUseCase);
});

class AuthNotifier extends StateNotifier<AsyncValue<bool>> {
  final AuthRepository _repository;
  final Login _loginUseCase;

  AuthNotifier(this._repository, this._loginUseCase) : super(const AsyncValue.loading()) {
    _initializeAuthState();
  }

  Future<void> _initializeAuthState() async {
    state = const AsyncValue.loading();
    try {
      final result = await _repository.getCurrentUser();
      result.fold(
        (failure) => state = const AsyncValue.data(false),
        (user) => state = const AsyncValue.data(true),
      );
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<bool> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final result = await _loginUseCase(LoginParams(email: email, password: password));
      return result.fold(
        (failure) {
          state = const AsyncValue.data(false);
          return false;
        },
        (user) {
          state = const AsyncValue.data(true);
          return true;
        },
      );
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      final result = await _repository.logout();
      result.fold(
        (failure) => state = AsyncValue.error(failure, StackTrace.current),
        (_) => state = const AsyncValue.data(false),
      );
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
