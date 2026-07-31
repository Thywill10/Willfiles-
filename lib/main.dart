import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';
import 'screens/dashboard_page.dart';
import 'screens/files_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/vault_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/search_screen.dart';

void main() {
  runApp(const WillFilesApp());
}

class WillFilesApp extends StatelessWidget {
  const WillFilesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WillFiles',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
        ),
        scaffoldBackgroundColor: const Color(0xFFF6FFF6),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
      ),

      home: const SplashScreen(),

      routes: {
        '/dashboard': (context) => const DashboardPage(),
        '/files': (context) => const FilesScreen(),
        '/favorites': (context) => const FavoritesScreen(),
        '/vault': (context) => const VaultScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/search': (context) => const SearchScreen(),
      },
    );
  }
}
