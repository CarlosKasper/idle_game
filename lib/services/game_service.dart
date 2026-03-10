import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../models/money.dart';
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

  /// Compra upgrades até gastar todo o dinheiro
  /// Continua comprando upgrades até não ter dinheiro para nenhum
  /// Aplica bonus de 20% no dinheiro gasto
  void buyMaxUpgrades() {
    Money moneySpent = Money(0); // Rastreia quanto foi gasto
    bool madeAPurchase = true;
    int purchaseCount = 0;

    // Loop enquanto conseguir comprar algo
    while (madeAPurchase && purchaseCount < 1000) {
      madeAPurchase = false;
      purchaseCount++;

      // Tenta comprar cada upgrade em ordem
      for (final upgradeId in _state.purchasedUpgrades.keys) {
        final purchased = _state.purchasedUpgrades[upgradeId]!;
        final cost = purchased.getCurrentCost();

        if (_state.money >= cost) {
          // Registra quanto vai gastar
          moneySpent = moneySpent + cost;

          final success = _state.buyUpgrade(upgradeId);
          if (success) {
            _analytics.trackUpgradePurchase(upgradeId);
            madeAPurchase = true;
            break; // Começa novamente a verificar todos
          }
        }
      }
    }

    // Aplica bonus de 20% no dinheiro gasto
    if (moneySpent.amount > 0) {
      final bonusAmount = (moneySpent.amount * 0.2);
      final bonus = Money(bonusAmount);
      _state.money = _state.money + bonus;
      _state.totalMoneyEarned = _state.totalMoneyEarned + bonus;
      _analytics.trackClick(); // Registra como atividade
    }

    _saveGame();
    notifyListeners();
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
