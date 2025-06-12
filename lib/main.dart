/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'controllers/auth_controller.dart';
import 'controllers/record_controller.dart';
import 'views/dashboard_view.dart';
import 'views/login_view.dart';
import 'views/registration_view.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

Future<void> checkForUpdate(BuildContext context) async {
  const currentVersion = "1.0.0";
  const versionUrl = "https://raw.githubusercontent.com/SAMUEopps/my_windows_app/main/version.json";

  try {
    final response = await http.get(Uri.parse(versionUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final latestVersion = data['latest_version'];
      final downloadUrl = data['download_url'];

      if (latestVersion != currentVersion) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            title: const Text("Update Available"),
            content: Text("A new version ($latestVersion) is available. Do you want to update now?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Later"),
              ),
              ElevatedButton(
                onPressed: () {
                  launchUrl(Uri.parse(downloadUrl), mode: LaunchMode.externalApplication);
                  Navigator.pop(context);
                },
                child: const Text("Update Now"),
              ),
            ],
          ),
        );
      }
    }
  } catch (e) {
    debugPrint("Update check failed: $e");
  }
}


void main() {
  // Initialize FFI (only necessary for desktop or Dart CLI)
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => RecordController()),
      ],
      child: const MyApp(),
    ),
  );
}

/*class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Malex Management System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
        ),
      ),
      routes: {
        '/register': (context) => const RegistrationView(),
      },
      home: Consumer<AuthController>(
        builder: (context, auth, _) {
          return auth.isAuthenticated ? const DashboardView() : const LoginView();
        },
      ),
    );
  }
}*/

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Schedule update check after first build
    Future.microtask(() => checkForUpdate(context));

    return MaterialApp(
      title: 'Malex Management System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
        ),
      ),
      routes: {
        '/register': (context) => const RegistrationView(),
      },
      home: Consumer<AuthController>(
        builder: (context, auth, _) {
          return auth.isAuthenticated ? const DashboardView() : const LoginView();
        },
      ),
    );
  }
}*/


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'controllers/auth_controller.dart';
import 'controllers/record_controller.dart';
import 'views/dashboard_view.dart';
import 'views/login_view.dart';
import 'views/registration_view.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => RecordController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Malex Management System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
        ),
      ),
      routes: {
        '/register': (context) => const RegistrationView(),
      },
      home: Consumer<AuthController>(
        builder: (context, auth, _) {
          return auth.isAuthenticated
              ? const DashboardView()
              : const LoginView();
        },
      ),
    );
  }
}
