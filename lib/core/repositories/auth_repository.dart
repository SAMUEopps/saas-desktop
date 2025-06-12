// auth_repository.dart
import '../../models/user_model.dart';

abstract class AuthRepository {
  Future<User?> login(String email, String password);
  Future<void> register(User user);
  Future<List<User>> getAllUsers();
  Future<void> updateUser(User user);
  Future<void> deleteUser(String userId);
}