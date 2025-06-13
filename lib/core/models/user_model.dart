// models/user_model.dart
/*enum UserRole { admin, storeManager, facilitator }

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.storeManager:
        return 'Store Manager';
      case UserRole.facilitator:
        return 'Facilitator';
    }
  }
}

class User {
  final String id;
  final String name;
  final UserRole role;
  final String email;
  final String? passwordHash;

  User({
    required this.id,
    required this.name,
    required this.role,
    required this.email,
    this.passwordHash,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      role: UserRole.values.firstWhere(
        (e) => e.toString() == map['role'],
        orElse: () => UserRole.facilitator,
      ),
      email: map['email'],
      passwordHash: map['passwordHash'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role.toString(),
      'email': email,
      'passwordHash': passwordHash,
    };
  }
}*/

import 'package:bcrypt/bcrypt.dart';

enum UserRole { admin, storeManager, facilitator }

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.storeManager:
        return 'Store Manager';
      case UserRole.facilitator:
        return 'Facilitator';
    }
  }
}

class User {
  final String id;
  final String name;
  final UserRole role;
  final String email;
  final String? password;

  User({
    required this.id,
    required this.name,
    required this.role,
    required this.email,
    this.password,
  });

  /*factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      role: UserRole.values.firstWhere(
        (e) => e.toString() == map['role'],
        orElse: () => UserRole.facilitator,
      ),
      email: map['email'],
      password: map['password'],
    );
  }*/

  factory User.fromMap(Map<String, dynamic> map) {
  return User(
    id: map['_id'] ?? '', // changed from 'id' to '_id'
    name: map['name'] ?? '',
    role: UserRole.values.firstWhere(
      (e) => e.toString().split('.').last == map['role'], // safer comparison
      orElse: () => UserRole.facilitator,
    ),
    email: map['email'] ?? '',
    password: map['password'],
  );
}


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role.toString(),
      'email': email,
      'password': password,
    };
  }

  static Future<String> hashPassword(String plainPassword) async {
    return BCrypt.hashpw(plainPassword, BCrypt.gensalt());
  }

  static Future<bool> verifyPassword(String input, String storedHash) async {
    return BCrypt.checkpw(input, storedHash);
  }
}