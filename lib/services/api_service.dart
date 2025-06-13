import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/record_model.dart';
import '../models/user_model.dart';

class ApiService {
  //static const String _baseUrl = 'http://localhost:5000/api';
  static const String _baseUrl = 'https://malexoffice.onrender.com/api';
  String? _token;

  Future<void> setToken(String token) {
    _token = token;
    return Future.value();
  }

  Future<void> clearToken() {
    _token = null;
    return Future.value();
  }

  Map<String, String> get _headers {
    return {
      'Content-Type': 'application/json',
      if (_token != null) 'Authorization': 'Bearer $_token',
    };
  }

  Future<User> register({
  required String name,
  required String email,
  required String password,
  required UserRole role,
}) async {
  final response = await http.post(
    Uri.parse('$_baseUrl/users/register'),
    headers: _headers,
    body: jsonEncode({
      'name': name,
      'email': email,
      'password': password,
      'role': role.toString().split('.').last,
    }),
  );

  if (response.statusCode == 201) {
    final data = jsonDecode(response.body);
    await setToken(data['token']);
    final user = User.fromMap(data['user']);
    print('Registration successful: ${user.name} (${user.email})');
    return user;
  } else {
    final error = jsonDecode(response.body)['error'] ?? 'Registration failed';
    print('Registration failed: $error');
    throw Exception(error);
  }
}
Future<User> login(String email, String password) async {
  print('[LOGIN] Sending login request to $_baseUrl/users/login');
  print('[LOGIN] Headers: $_headers');
  print('[LOGIN] Body: ${jsonEncode({
    'email': email,
    'password': password,
  })}');

  try {
    final response = await http.post(
      Uri.parse('$_baseUrl/users/login'),
      headers: _headers,
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    print('[LOGIN] Received response with status code: ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('[LOGIN SUCCESS] Token received: ${data['token'] != null ? 'Yes' : 'No'}');
      print('[LOGIN SUCCESS] User info: ${data['user']}');

      await setToken(data['token']);
      final user = User.fromMap(data['user']);

      print('[LOGIN COMPLETE] User ${user.email} authenticated successfully.');
      return user;
    } else {
      final errorMsg = jsonDecode(response.body)['error'] ?? 'Login failed with unknown error';
      print('[LOGIN FAILED] Server responded with error: $errorMsg');
      throw Exception(errorMsg);
    }
  } catch (e) {
    print('[LOGIN ERROR] An exception occurred during login: $e');
    rethrow;
  }
}


  Future<void> logout() async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users/logout'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      await clearToken();
    } else {
      throw Exception('Logout failed');
    }
  }

  Future<List<Record>> syncRecords(List<Record> records) async {
  final response = await http.post(
    Uri.parse('$_baseUrl/records/sync'),
    headers: _headers,
    body: jsonEncode({
      'records': records.map((r) => r.toMap()).toList(),
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List;
    return data.map((item) => Record.fromMap(item)).toList();
  } else {
    // Add detailed logging 👇
   // print('🔴 Sync failed with status code: ${response.statusCode}');
   // print('🔴 Response body: ${response.body}');
    throw Exception('Sync failed');
  }
}


  Future<List<Record>> getRemoteRecords() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/records'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((item) => Record.fromMap(item)).toList();
    } else {
      throw Exception('Failed to load records');
    }
  }

  Future<User> createUserByAdmin({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users/createByAdmin'),
      headers: _headers,
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'role': role.name, 
        //'role': role.toString().split('.').last,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return User.fromMap(data['user']);
    } else {
      throw Exception(jsonDecode(response.body)['error'] ?? 'User creation failed');
    }
  }

    Future<List<User>> getAllUsers() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/users'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((item) => User.fromMap(item)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

Future<void> updateUser(User user) async {
  try {
    final Map<String, dynamic> allowedFields = {
      'name': user.name,
      'email': user.email,
      'role': user.role.displayName.toLowerCase().replaceAll(' ', ''),
    };

    final response = await http.put(
      Uri.parse('$_baseUrl/users/${user.name}'),
      headers: _headers,
      body: jsonEncode(allowedFields),
    );

    if (response.statusCode == 200) {
      print('User updated successfully on backend: ${user.name}');
    } else {
      print('Failed to update user on backend. Status code: ${response.statusCode}, Response: ${response.body}');
      throw Exception('Failed to update user');
    }
  } catch (e) {
    print('Exception occurred while updating user: $e');
    throw Exception('Failed to update user');
  }
}

  Future<void> deleteUser(String userId) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/users/$userId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        print('User deleted successfully on backend: $userId');
      } else {
        print('Failed to delete user on backend. Status code: ${response.statusCode}, Response: ${response.body}');
        throw Exception('Failed to delete user');
      }
    } catch (e) {
      print('Exception occurred while deleting user: $e');
      throw Exception('Failed to delete user');
    }
  }

  Future<void> updatePassword({
  required String email,
  required String newPassword,
}) async {
  final response = await http.post(
    Uri.parse('$_baseUrl/users/updatePassword'),
    headers: _headers,
    body: jsonEncode({
      'email': email,
      'newPassword': newPassword,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to update password');
  }
}
Future<User> getUserByEmail(String email) async {
  final encodedEmail = Uri.encodeComponent(email);
  final response = await http.get(
    Uri.parse('$_baseUrl/users/email/$encodedEmail'),
    headers: _headers,
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final user = User.fromMap(data['user']);
    print('User fetched: ${user.name} (${user.email})');
    return user;
  } else {
    final error = jsonDecode(response.body)['error'] ?? 'Failed to fetch user';
    print('Fetch user by email failed: $error');
    throw Exception(error);
  }
}

Future<void> updateRecord(Record record) async {
  final response = await http.put(
    Uri.parse('$_baseUrl/records/${record.id}'),
    headers: _headers,
    body: jsonEncode(record.toMap()),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to update record');
  }
}

Future<void> deleteRecord(String recordId) async {
  try {
    final response = await http.delete(
      Uri.parse('$_baseUrl/records/$recordId'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      print('Record deleted successfully on backend: $recordId');
    } else {
      print('Failed to delete record on backend. Status code: ${response.statusCode}, Response: ${response.body}');
      throw Exception('Failed to delete record');
    }
  } catch (e) {
    print('Exception occurred while deleting record: $e');
    throw Exception('Failed to delete record');
  }
}

}