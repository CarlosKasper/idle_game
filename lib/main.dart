import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/game_service.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  ThemeMode _themeMode =
      ThemeMode.system; // Sistema define tema automaticamente

  void _setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameService()..initialize(),
      child: MaterialApp(
        title: 'Office Idle',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: _themeMode,
        home: HomeScreen(onThemeChanged: _setThemeMode),
      ),
    );
  }
}
