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

  print('[SYNC] Syncing current user to backend: ${_currentUser!.email}');

  try {
    try {
      // Attempt to create the user on the backend
      await _api.createUserByAdmin(
        name: _currentUser!.name,
        email: _currentUser!.email,
        password: 'temporaryPassword', // Replace with secure password handling
        role: _currentUser!.role,
      );
      print('[SYNC SUCCESS] User created: ${_currentUser!.email}');
    } catch (e) {
      print('[SYNC WARNING] User may already exist, attempting update...');
      try {
        await _api.updateUser(_currentUser!);
        print('[SYNC SUCCESS] User updated: ${_currentUser!.email}');
      } catch (updateError) {
        print('[SYNC FAILED] Could not update user: $updateError');
      }
    }
  } catch (e) {
    print('[SYNC ERROR] Syncing current user failed: $e');
  }
}


Future<void> login(String email, String password) async {
  bool success = false;

  // 1st attempt: Online login
  try {
    print('[LOGIN] Attempting online login...');
    final user = await _api.login(email, password);
    final existingUser = await _db.getUserByEmail(email);

if (existingUser == null) {
  await _db.addUser(user);
  print('[DB] New user added to local DB:');
} else {
  await _db.updateUser(user); // ✅ This ensures the local data stays in sync
  print('[DB] Existing user updated in local DB:');
}

// Log the user's properties
print('''
  [USER]
  ID: ${user.id}
  Name: ${user.name}
  Role: ${user.role}
  Email: ${user.email}
  Password: ${user.password}
''');



    _currentUser = user;
    _isAuthenticated = true;
    await _syncLocalChanges();
    notifyListeners();
    print('[LOGIN SUCCESS] Logged in via online API.');
    success = true;
    return;
  } catch (e) {
    print('[LOGIN FAILED] Online login failed: $e');
  }

  // 2nd attempt: Local login
  try {
    print('[LOGIN] Attempting local (offline) login...');
    final localUser = await _db.authenticateUser(email, password);
    if (localUser != null) {
      _currentUser = localUser;
      _isAuthenticated = true;
      notifyListeners();
      print('[LOGIN SUCCESS] Logged in using local credentials.');
      success = true;
      return;
    } else {
      print('[LOGIN FAILED] No matching local credentials found.');
    }
  } catch (e) {
    print('[LOGIN ERROR] Local login error: $e');
  }

  // 3rd attempt: Retry online login
  if (!success) {
    try {
      print('[LOGIN] Retrying online login as final fallback...');
      final user = await _api.login(email, password);

      // 👇 Check again before adding
      final existingUser = await _db.getUserByEmail(email);
      if (existingUser == null) {
        await _db.addUser(user);
        print('[DB] User added during retry.');
      } else {
        print('[DB] User already exists during retry. Skipping insert.');
      }

      _currentUser = user;
      _isAuthenticated = true;
      await _syncLocalChanges();
      notifyListeners();
      print('[LOGIN SUCCESS] Logged in via online API on retry.');
      return;
    } catch (e) {
      print('[LOGIN FAILED] Final online login retry failed.');
      print('Error type: ${e.runtimeType}');
      print('Error message: $e');
      throw Exception('Invalid credentials. Please check your email and password.');
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

  /*Future<List<User>> getAllUsers() async {
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
  }*/

  Future<List<User>> getAllUsers() async {
  try {
    print('[INFO] Fetching users from backend...');
    
    // Try to get from backend first
    final users = await _api.getAllUsers();

    print('[SUCCESS] Successfully fetched ${users.length} users from backend.');
    
    // Update local DB
    for (final user in users) {
      await _db.updateUser(user);
    }

    return users;
  } catch (e) {
    print('[ERROR] Failed to fetch users from backend: $e');
    print('[INFO] Falling back to local database...');

    final localUsers = await _db.getAllUsers();

    print('[SUCCESS] Loaded ${localUsers.length} users from local database.');
    
    return localUsers;
  }
}


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