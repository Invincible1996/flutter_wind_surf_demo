import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_storage.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalStorage localDataSource;

  AuthRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final user = User(
        id: '1',
        email: email,
        name: 'Test User',
      );
      await localDataSource.saveUser(user);
      return Right(user);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearUser();
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final user = await localDataSource.getUser();
      return user != null ? Right(user) : const Left(ServerFailure());
    } catch (e) {
      return const Left(ServerFailure());
    }
  }
}
