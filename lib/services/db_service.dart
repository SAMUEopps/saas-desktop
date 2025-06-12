// services/db_service.dart
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/record_model.dart';
import '../models/user_model.dart';
import 'package:path_provider/path_provider.dart';

class DbService {
  static final DbService instance = DbService._init();
  static Database? _database;

  DbService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('malex_management.db');
    return _database!;
  }
  Future<void> migrateDatabase(Database db) async {
  // Check if we need to migrate the records table
  final records = await db.query('records');
  if (records.isNotEmpty) {
    // Check if any record has empty strings for document numbers
    for (final record in records) {
      if (record['invoiceNo'] == '' || 
          record['cashSaleNo'] == '' || 
          record['quotationNo'] == '') {
        
        await db.update(
          'records',
          {
            'invoiceNo': record['invoiceNo'] == '' ? null : record['invoiceNo'],
            'cashSaleNo': record['cashSaleNo'] == '' ? null : record['cashSaleNo'],
            'quotationNo': record['quotationNo'] == '' ? null : record['quotationNo'],
          },
          where: 'id = ?',
          whereArgs: [record['id']],
        );
      }
    }
  }
}
    Future<Database> _initDB(String filePath) async {
  try {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    
    // Ensure the directory exists
    try {
      await Directory(dbPath).create(recursive: true);
    } catch (e) {
     // print('Error creating database directory: $e');
      // Fallback to documents directory if default path fails
      final documentsDir = await getApplicationDocumentsDirectory();
      final fallbackPath = join(documentsDir.path, filePath);
      return await openDatabase(
        fallbackPath,
        version: 2,
        onCreate: _createDB,
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            // Your existing upgrade logic
          }
        }
      );
    }
    
    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Your existing upgrade logic
        }
      }
    );
  } catch (e) {
    print('Error initializing database: $e');
    rethrow;
  }
}
  Future<void> _createDB(Database db, int version) async {
  await db.execute('''
    CREATE TABLE users (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      role TEXT NOT NULL,
      email TEXT UNIQUE NOT NULL,
      password TEXT
    )
  ''');

  await db.execute('''
    CREATE TABLE records (
      id TEXT PRIMARY KEY,
      date TEXT NOT NULL,
      time TEXT NOT NULL,
      customerName TEXT NOT NULL,
      invoiceNo TEXT,  -- Changed to nullable
      cashSaleNo TEXT, -- Changed to nullable
      quotationNo TEXT, -- Changed to nullable
      facilitator TEXT NOT NULL,
      amount REAL NOT NULL,
      createdBy TEXT NOT NULL,
      createdAt TEXT NOT NULL
    )
  ''');

  // Insert default admin user
  await db.insert('users', {
    'id': '1',
    'name': 'Admin',
    'role': 'UserRole.admin',
    'email': 'admin@example.com',
    'password': 'hashed_password_here'
  });
}

  Future<User?> authenticateUser(String email, String password) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password], 
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }
/*Future<User?> authenticateUser(String email, String password) async {
  final db = await instance.database;
  final List<Map<String, dynamic>> maps = await db.query(
    'users',
    where: 'email = ?',
    whereArgs: [email],
  );

  if (maps.isNotEmpty) {
    final user = User.fromMap(maps.first);
    if (User.verifyPassword(password, user.password ?? '')) {
      return user;
    }
  }
  return null;
}*/

Future<bool> _comparePasswords(String plainPassword, String hashedPassword) async {
  // Implement proper password comparison
  // For now using simple comparison (in production use bcrypt)
  return plainPassword == hashedPassword;
}

  Future<List<Record>> getRecords() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('records');
    return List.generate(maps.length, (i) => Record.fromMap(maps[i]));
  }

  Future<void> addRecord(Record record) async {
    final db = await instance.database;
    await db.insert('records', record.toMap());
  }

  Future<void> updateRecord(Record record) async {
    final db = await instance.database;
    await db.update(
      'records',
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<void> deleteRecord(String id) async {
    final db = await instance.database;
    await db.delete(
      'records',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

Future<User?> getUserByEmail(String email) async {
  final db = await instance.database;
  final List<Map<String, dynamic>> maps = await db.query(
    'users',
    where: 'email = ?',
    whereArgs: [email],
    limit: 1,
  );

  if (maps.isNotEmpty) {
    return User.fromMap(maps.first);
  }
  return null;
}

/*Future<void> addUser(User user) async {
  final db = await instance.database;
  await db.insert('users', user.toMap());
}*/
Future<void> addUser(User user) async {
  try {
    final db = await instance.database;
    await db.insert('users', user.toMap());
    print('User added successfully: ${user.name} (${user.email})');
  } catch (e) {
    print('Failed to add user: ${e.toString()}');
    rethrow; // Re-throw the exception to allow the caller to handle it
  }
}


String _hashPassword(String plainPassword) {
  // In production, use proper hashing like bcrypt
  // This is just for demonstration
  return plainPassword; // Replace with actual hashing
}

Future<List<User>> getAllUsers() async {
  final db = await instance.database;
  final List<Map<String, dynamic>> maps = await db.query('users');
  return List.generate(maps.length, (i) => User.fromMap(maps[i]));
}

Future<void> updateUser(User user) async {
  final db = await instance.database;
  await db.update(
    'users',
    user.toMap(),
    where: 'id = ?',
    whereArgs: [user.id],
  );
}

Future<void> deleteUser(String userId) async {
  final db = await instance.database;
  await db.delete(
    'users',
    where: 'id = ?',
    whereArgs: [userId],
  );
}

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }
}