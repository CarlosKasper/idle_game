import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'services/game_service.dart';
import 'services/purchase_state_service.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // // Inicializar Google Mobile Ads
  // try {
  //   await MobileAds.instance.initialize();
  // } catch (e) {
  //   print('Erro ao inicializar Google Mobile Ads: $e');
  // }

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
  late GameService _gameService;
  late Future<void> _initializationFuture;

  @override
  void initState() {
    super.initState();
    _gameService = GameService();
    _initializationFuture = _gameService.initialize();
  }

  void _setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            title: 'Office Idle',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: _themeMode,
            home: Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              body: const Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (snapshot.hasError) {
          return MaterialApp(
            title: 'Office Idle',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: _themeMode,
            home: Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              body: Center(child: Text('Erro ao carregar: ${snapshot.error}')),
            ),
          );
        }

        return ChangeNotifierProvider.value(
          value: _gameService,
          child: ChangeNotifierProvider.value(
            value: PurchaseStateService(),
            child: MaterialApp(
              title: 'Office Idle',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: _themeMode,
              home: HomeScreen(onThemeChanged: _setThemeMode),
            ),
          ),
        );
      },
    );
  }
}
