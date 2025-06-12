/*import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/db_service.dart';
import '../services/api_service.dart';

class AuthController with ChangeNotifier {
  User? _currentUser;
  bool _isAuthenticated = false;
  final DbService _db = DbService.instance;
  final ApiService _api = ApiService();

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> login(String email, String password) async {
    try {
      // Try remote login first
      final user = await _api.login(email, password);
      
      // Save to local DB
      final localUser = await _db.getUserByEmail(email);
      if (localUser == null) {
        await _db.addUser(user);
      } else {
        await _db.updateUser(user);
      }
      
      _currentUser = user;
      _isAuthenticated = true;
      notifyListeners();
    } catch (e) {
      // Fallback to local login if remote fails
      final localUser = await _db.authenticateUser(email, password);
      
      if (localUser != null) {
        _currentUser = localUser;
        _isAuthenticated = true;
        notifyListeners();
      } else {
        throw Exception('Invalid credentials');
      }
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    try {
      // Try remote registration first
      final user = await _api.register(
        name: name,
        email: email,
        password: password,
        role: role,
      );
      
      // Save to local DB
      await _db.addUser(user);
      
      _currentUser = user;
      _isAuthenticated = true;
      notifyListeners();
    } catch (e) {
      // Fallback to local registration if remote fails
      final existingUser = await _db.getUserByEmail(email);
      if (existingUser != null) {
        throw Exception('Email already in use');
      }

      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        role: role,
        passwordHash: password, // In real app, hash the password
      );

      await _db.addUser(newUser);
      _currentUser = newUser;
      _isAuthenticated = true;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      await _api.logout();
    } catch (e) {
      // Ignore if logout fails (offline mode)
    }
    
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<List<User>> getAllUsers() async {
    return await _db.getAllUsers();
  }

  Future<void> updateUser(User user) async {
    await _db.updateUser(user);
    notifyListeners();
  }

  Future<void> deleteUser(String userId) async {
    await _db.deleteUser(userId);
    notifyListeners();
  }

  Future<void> createUserByAdmin({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    try {
      // Try remote creation first
      final user = await _api.createUserByAdmin(
        name: name,
        email: email,
        password: password,
        role: role,
      );
      
      // Save to local DB
      await _db.addUser(user);
    } catch (e) {
      // Fallback to local creation if remote fails
      final existingUser = await _db.getUserByEmail(email);
      if (existingUser != null) {
        throw Exception('Email already in use');
      }

      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        role: role,
        passwordHash: password, // In real app, hash the password
      );

      await _db.addUser(newUser);
    }
  }
}*/

import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/db_service.dart';
import '../services/api_service.dart';

class AuthController with ChangeNotifier {
  User? _currentUser;
  bool _isAuthenticated = false;
  final DbService _db = DbService.instance;
  final ApiService _api = ApiService();

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> _syncLocalChanges() async {
    if (_currentUser == null) return;
    
    try {
      // Sync all users to backend
      final localUsers = await _db.getAllUsers();
      for (final user in localUsers) {
        try {
          // Check if user exists in backend
          await _api.createUserByAdmin(
            name: user.name,
            email: user.email,
            password: 'temporaryPassword', // You might need a better approach for passwords
            role: user.role,
          );
        } catch (e) {
          // User might already exist, try updating
          await _api.updateUser(user);
        }
      }
    } catch (e) {
      print('User sync error: $e');
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final user = await _api.login(email, password);
      await _db.addUser(user);
      _currentUser = user;
      _isAuthenticated = true;
      await _syncLocalChanges(); // Sync any local changes after login
      notifyListeners();
    } catch (e) {
      final localUser = await _db.authenticateUser(email, password);
      if (localUser != null) {
        _currentUser = localUser;
        _isAuthenticated = true;
        notifyListeners();
      } else {
        throw Exception('Invalid credentials');
      }
    }
  }
/*Future<void> login(String email, String password) async {
  try {
    // 1. Try backend login first
    final user = await _api.login(email, password);
    print('Backend login successful: ${user.email}');
    
    // 2. Save hashed credentials to local DB
    await _db.addUser(user);
    
    _currentUser = user;
    _isAuthenticated = true;
    notifyListeners();
    
  } catch (e) {
    print('Backend login failed, trying local: $e');
    
    // 3. Fallback to local login
    final localUser = await _db.authenticateUser(email, password);
    if (localUser != null) {
      print('Local login successful: ${localUser.email}');
      
      // 4. Update local user with proper hashing
      await _db.addUser(localUser.copyWith(
        passwordHash: User.hashPassword(password)
      ));
      
      _currentUser = localUser;
      _isAuthenticated = true;
      notifyListeners();
      
      // 5. Try to update backend password
      try {
        await _api.updatePassword(
          email: localUser.email,
          newPassword: password
        );
        print('Password updated on backend');
      } catch (e) {
        print('Failed to update backend password: $e');
      }
    } else {
      throw Exception('Invalid credentials');
    }
  }
}*/
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    try {
      // Try remote registration first
      final user = await _api.register(
        name: name,
        email: email,
        password: password,
        role: role,
      );
      
      // Save to local DB
      await _db.addUser(user);
      
      _currentUser = user;
      _isAuthenticated = true;
      notifyListeners();
    } catch (e) {
      // Fallback to local registration if remote fails
      final existingUser = await _db.getUserByEmail(email);
      if (existingUser != null) {
        throw Exception('Email already in use');
      }

      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        role: role,
        password: password, // In real app, hash the password
      );

      await _db.addUser(newUser);
      _currentUser = newUser;
      _isAuthenticated = true;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      await _api.logout();
    } catch (e) {
      // Ignore if logout fails (offline mode)
    }
    
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<List<User>> getAllUsers() async {
    try {
      // Try to get from backend first
      final users = await _api.getAllUsers();
      // Update local DB
      for (final user in users) {
        await _db.updateUser(user);
      }
      return users;
    } catch (e) {
      // Fallback to local DB
      return await _db.getAllUsers();
    }
  }

  /*Future<void> updateUser(User user) async {
    try {
      await _api.updateUser(user);
    } catch (e) {
      // If backend update fails, we'll sync later
    }
    await _db.updateUser(user);
    notifyListeners();
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _api.deleteUser(userId);
    } catch (e) {
      // If backend delete fails, we'll sync later
    }
    await _db.deleteUser(userId);
    notifyListeners();
  }*/

  Future<void> updateUser(User user) async {
  try {
    await _api.updateUser(user);
    print('User updated successfully on backend: $user');
  } catch (e) {
    print('Failed to update user on backend: $e');
    // If backend update fails, we'll sync later
  }
  try {
    await _db.updateUser(user);
    print('User updated successfully in local DB: $user');
  } catch (e) {
    print('Failed to update user in local DB: $e');
  }
  notifyListeners();
}

Future<void> deleteUser(String userId) async {
  try {
    await _api.deleteUser(userId);
    print('User deleted successfully on backend: $userId');
  } catch (e) {
    print('Failed to delete user on backend: $e');
    // If backend delete fails, we'll sync later
  }
  try {
    await _db.deleteUser(userId);
    print('User deleted successfully in local DB: $userId');
  } catch (e) {
    print('Failed to delete user in local DB: $e');
  }
  notifyListeners();
}

  /*Future<void> createUserByAdmin({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    try {
      final user = await _api.createUserByAdmin(
        name: name,
        email: email,
        password: password,
        role: role,
      );
      await _db.addUser(user);
    } catch (e) {
      // Fallback to local creation
      final existingUser = await _db.getUserByEmail(email);
      if (existingUser != null) {
        throw Exception('Email already in use');
      }

      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        role: role,
        passwordHash: password,
      );

      await _db.addUser(newUser);
    }
    await _syncLocalChanges(); // Try to sync immediately
  }*/
  Future<void> createUserByAdmin({
  required String name,
  required String email,
  required String password,
  required UserRole role,
}) async {
  try {
    final user = await _api.createUserByAdmin(
      name: name,
      email: email,
      password: password,
      role: role,
    );
    await _db.addUser(user);
    print('User created successfully on backend and added to local DB: $user');
  } catch (e) {
    print('Failed to create user on backend: $e');
    // Fallback to local creation
    final existingUser = await _db.getUserByEmail(email);
    if (existingUser != null) {
      throw Exception('Email already in use');
    }

    final newUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      role: role,
      password: password,
    );

    await _db.addUser(newUser);
    print('User created successfully in local DB: $newUser');
  }
  try {
    await _syncLocalChanges(); // Try to sync immediately
    print('Local changes synced successfully with backend.');
  } catch (e) {
    print('Failed to sync local changes with backend: $e');
  }
}
}