import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource _dataSource;

  AuthRepositoryImpl({
    FirebaseAuthDataSource? dataSource,
}) : _dataSource = dataSource ?? 
        FirebaseAuthDataSource(FirebaseAuth.instance);

  @override
  Future<UserEntity?> signIn(String email, String password) async {
    try {
      return await _dataSource.signIn(email, password);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity?> signUp(String email, String password) async {
    try {
      return await _dataSource.signUp(email, password);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _dataSource.signOut();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<UserEntity?> get user => _dataSource.user;

  @override
  UserEntity? getCurrentUser() => _dataSource.getCurrentUser();
}

