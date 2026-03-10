import 'dart:math' as Math;
import 'money.dart';
import 'upgrade.dart';
import 'career.dart';

/// Estado de um upgrade comprado
class PurchasedUpgrade {
  final Upgrade upgrade;
  int level; // quantas vezes foi comprado

  PurchasedUpgrade({
    required this.upgrade,
    this.level = 1,
  });

  /// Calcula o custo atual baseado no nível
  /// custo = base * 1.15^(nivel-1)
  Money getCurrentCost() {
    final multiplier = Math.pow(1.15, level - 1).toDouble();
    return upgrade.baseCost * multiplier;
  }
}

/// Estado completo do jogo
class GameState {
  Money money = Money(0);
  Money totalMoneyEarned = Money(0); // para progressão de carreira
  int currentCareerLevel = 0;

  // Bônus adquiridos
  double clickBonusTotal = 0; // bônus extra por clique
  double incomePerSecondTotal = 0; // bônus extra por segundo
  double multiplierTotal = 1.0; // multiplicador de renda (começa em 1.0 = 100%)

  // Upgrades comprados
  Map<String, PurchasedUpgrade> purchasedUpgrades = {};

  DateTime lastSaveTime = DateTime.now();

  /// Inicializa os upgrades comprados (do save ou zero)
  void initializePurchasedUpgrades() {
    for (var upgrade in availableUpgrades) {
      if (!purchasedUpgrades.containsKey(upgrade.id)) {
        purchasedUpgrades[upgrade.id] = PurchasedUpgrade(upgrade: upgrade);
      }
    }
  }

  /// Calcula renda por clique (carreira + bônus)
  Money getClickIncome() {
    return Money(baseIncomePerClick + clickBonusTotal) * multiplierTotal;
  }

  /// Calcula renda por segundo (carreira + bônus)
  Money getIncomePerSecond() {
    return Money(baseIncomePerSecond + incomePerSecondTotal) * multiplierTotal;
  }

  /// Renda base do cargo atual
  double get baseIncomePerClick {
    // Na versão 1, carreira afeta clique
    // Pode ser modificado depois
    return careerLevels[currentCareerLevel].baseIncome.amount;
  }

  double get baseIncomePerSecond {
    // Na versão 1, carreira não afeta renda por segundo
    return 0;
  }

  /// Tenta fazer upgrade de carreira
  void checkCareerPromotion() {
    if (currentCareerLevel >= careerLevels.length - 1) return;

    final nextLevel = careerLevels[currentCareerLevel + 1];
    if (totalMoneyEarned >= nextLevel.requiredMoney) {
      currentCareerLevel++;
    }
  }

  /// Compra um upgrade
  bool buyUpgrade(String upgradeId) {
    final purchased = purchasedUpgrades[upgradeId];
    if (purchased == null) return false;

    final cost = purchased.getCurrentCost();
    if (money < cost) return false;

    money = money - cost;

    // Aplica o bônus
    switch (purchased.upgrade.type) {
      case UpgradeType.clickBonus:
        clickBonusTotal += purchased.upgrade.value;
        break;
      case UpgradeType.incomeBonus:
        incomePerSecondTotal += purchased.upgrade.value;
        break;
      case UpgradeType.multiplier:
        multiplierTotal += purchased.upgrade.value;
        break;
    }

    // Aumenta o level do upgrade
    if (purchased.upgrade.isInfinite) {
      purchased.level++;
    }

    return true;
  }

  /// Simula ganho de dinheiro (por clique)
  void earnMoneyFromClick() {
    final earned = getClickIncome();
    money = money + earned;
    totalMoneyEarned = totalMoneyEarned + earned;
    checkCareerPromotion();
  }

  /// Simula ganho passivo de dinheiro
  void earnPassiveIncome(Duration elapsed) {
    final secondsElapsed = elapsed.inMilliseconds / 1000;
    final earned = getIncomePerSecond() * secondsElapsed;
    money = money + earned;
    totalMoneyEarned = totalMoneyEarned + earned;
    checkCareerPromotion();
  }

  /// Salva o estado (para implementar com shared_preferences)
  Map<String, dynamic> toJson() {
    return {
      'money': money.amount,
      'totalMoneyEarned': totalMoneyEarned.amount,
      'currentCareerLevel': currentCareerLevel,
      'clickBonusTotal': clickBonusTotal,
      'incomePerSecondTotal': incomePerSecondTotal,
      'multiplierTotal': multiplierTotal,
      'purchasedUpgrades': purchasedUpgrades.map(
        (key, value) => MapEntry(key, {
          'level': value.level,
        }),
      ),
      'lastSaveTime': lastSaveTime.toIso8601String(),
    };
  }

  /// Carrega o estado (para implementar com shared_preferences)
  static GameState fromJson(Map<String, dynamic> json) {
    final state = GameState();
    state.money = Money(json['money'] as double? ?? 0);
    state.totalMoneyEarned =
        Money(json['totalMoneyEarned'] as double? ?? 0);
    state.currentCareerLevel = json['currentCareerLevel'] as int? ?? 0;
    state.clickBonusTotal = json['clickBonusTotal'] as double? ?? 0;
    state.incomePerSecondTotal =
        json['incomePerSecondTotal'] as double? ?? 0;
    state.multiplierTotal = json['multiplierTotal'] as double? ?? 1.0;
    state.lastSaveTime =
        DateTime.parse(json['lastSaveTime'] as String? ?? DateTime.now().toIso8601String());

    state.initializePurchasedUpgrades();

    // Restaura níveis dos upgrades
    final purchasedUpgradesJson =
        json['purchasedUpgrades'] as Map<String, dynamic>? ?? {};
    purchasedUpgradesJson.forEach((key, value) {
      if (state.purchasedUpgrades.containsKey(key)) {
        state.purchasedUpgrades[key]!.level =
            (value as Map<String, dynamic>)['level'] as int? ?? 1;
      }
    });

    return state;
  }
}
