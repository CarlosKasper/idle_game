import 'package:flutter/material.dart';
import '../models/game_state.dart';
import 'save_service.dart';
import 'analytics_service.dart';

/// Serviço principal que gerencia a lógica do jogo
class GameService extends ChangeNotifier {
  late GameState _state;
  late SaveService _saveService;
  late AnalyticsService _analytics;

  GameState get state => _state;
  AnalyticsService get analytics => _analytics;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  late Stopwatch _passiveIncomeStopwatch;

  GameService() {
    _saveService = SaveService();
    _analytics = AnalyticsService();
    _passiveIncomeStopwatch = Stopwatch();
  }

  /// Inicializa o jogo
  Future<void> initialize() async {
    await _saveService.initialize();
    _state = await _saveService.loadGame();
    _state.initializePurchasedUpgrades();
    _passiveIncomeStopwatch.start();
    _analytics.startSession();
    _isInitialized = true;
    notifyListeners();
  }

  /// Executa um clique de trabalho
  void click() {
    _state.earnMoneyFromClick();
    _analytics.trackClick();
    _saveGame();
    notifyListeners();
  }

  /// Atualiza renda passiva (chamado regularmente, ex: 60fps)
  void updatePassiveIncome() {
    if (_passiveIncomeStopwatch.elapsedMilliseconds > 500) {
      // Atualiza a cada 500ms para não ser muito frequente
      final elapsed = _passiveIncomeStopwatch.elapsed;
      _state.earnPassiveIncome(elapsed);
      _passiveIncomeStopwatch.reset();
      notifyListeners();
    }
  }

  /// Compra um upgrade
  void buyUpgrade(String upgradeId) {
    final success = _state.buyUpgrade(upgradeId);
    if (success) {
      _analytics.trackUpgradePurchase(upgradeId);
      _saveGame();
      notifyListeners();
    }
  }

  /// Salva o progresso
  Future<void> _saveGame() async {
    await _saveService.saveGame(_state);
  }

  /// Reseta o jogo
  Future<void> resetGame() async {
    await _saveService.deleteGame();
    _state = GameState();
    _state.initializePurchasedUpgrades();
    notifyListeners();
  }
}
