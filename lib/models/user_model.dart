import 'package:crypto/crypto.dart';
import 'dart:convert';

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

  // Add this copyWith method
  User copyWith({
    String? id,
    String? name,
    UserRole? role,
    String? email,
    String? password,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

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
    'role': role.name, 
    'email': email,
    'password': password,
  };
}


  static String hashPassword(String plainPassword) {
    // Note: This is a simple SHA-256 hash for demo
    // In production, use package:bcrypt (see below)
    final bytes = utf8.encode(plainPassword);
    return sha256.convert(bytes).toString();
  }

  static bool verifyPassword(String input, String storedHash) {
    return hashPassword(input) == storedHash;
  }
}