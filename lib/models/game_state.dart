import 'dart:math' as Math;
import 'money.dart';
import 'upgrade.dart';
import 'career.dart';
import 'career_upgrade.dart';
import 'active_bonus.dart';

/// Estado de um upgrade comprado
class PurchasedUpgrade {
  final Upgrade upgrade;
  int level; // quantas vezes foi comprado
  bool purchased; // flag para upgrades non-infinite

  PurchasedUpgrade({
    required this.upgrade,
    this.level = 1,
    this.purchased = false,
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

  // Notebook evolution
  int notebookLevel = 0; // 0 a 9 (índice na lista de 10 evoluções)

  // Bônus adquiridos
  double clickBonusTotal = 0; // bônus extra por clique
  double incomePerSecondTotal = 0; // bônus extra por segundo
  double multiplierTotal = 1.0; // multiplicador de renda (começa em 1.0 = 100%)

  // Upgrades comprados
  Map<String, PurchasedUpgrade> purchasedUpgrades = {};
  Map<String, PurchasedUpgrade> purchasedCareerUpgrades = {};

  // Bônus ativos (temporários)
  List<ActiveBonus> activeBonuses = [];

  // Status premium
  bool isCEO = false; // Se o jogador comprou "Me torne CEO"

  DateTime lastSaveTime = DateTime.now();

  /// Inicializa os upgrades comprados (do save ou zero)
  void initializePurchasedUpgrades() {
    for (var upgrade in availableUpgrades) {
      if (!purchasedUpgrades.containsKey(upgrade.id)) {
        purchasedUpgrades[upgrade.id] = PurchasedUpgrade(upgrade: upgrade);
      }
    }
  }

  /// Inicializa os upgrades de carreira (do save ou zero)
  void initializeCareerUpgrades() {
    for (var upgrade in careerUpgrades) {
      if (!purchasedCareerUpgrades.containsKey(upgrade.id)) {
        purchasedCareerUpgrades[upgrade.id] = PurchasedUpgrade(
          upgrade: Upgrade(
            id: upgrade.id,
            name: upgrade.name,
            description: upgrade.description,
            emoji: upgrade.emoji,
            type: upgrade.type,
            baseCost: upgrade.baseCost,
            value: upgrade.value,
            isInfinite: upgrade.isInfinite,
          ),
        );
      }
    }
  }

  /// Calcula renda por clique (carreira + bônus + multiplicadores)
  Money getClickIncome() {
    final baseIncome = Money(baseIncomePerClick + clickBonusTotal);
    final totalMultiplier = multiplierTotal * getClickMultiplierBonus();
    return baseIncome * totalMultiplier;
  }

  /// Calcula renda por segundo (carreira + bônus + multiplicadores)
  Money getIncomePerSecond() {
    final baseIncome = Money(baseIncomePerSecond + incomePerSecondTotal);
    final totalMultiplier = multiplierTotal * getIncomeMultiplierBonus();
    return baseIncome * totalMultiplier;
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

  /// Tenta fazer upgrade de carreira (pode promover múltiplos níveis)
  void checkCareerPromotion() {
    // Verifica todos os níveis para encontrar o máximo alcançável
    for (int i = 0; i < careerLevels.length; i++) {
      if (totalMoneyEarned >= careerLevels[i].requiredMoney) {
        currentCareerLevel = i;
      } else {
        break;
      }
    }
  }

  /// Compra um upgrade
  bool buyUpgrade(String upgradeId) {
    final purchased = purchasedUpgrades[upgradeId];
    if (purchased == null) return false;

    // Se não é infinito e já foi comprado, não pode comprar novamente
    if (!purchased.upgrade.isInfinite && purchased.purchased) {
      return false;
    }

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

    // Se não é infinito, marca como comprado
    if (!purchased.upgrade.isInfinite) {
      purchased.purchased = true;
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
  /// Usa Strings para evitar perda de precisão com doubles
  /// Remove .0 de números inteiros para simplicidade
  Map<String, dynamic> toJson() {
    final moneyStr = money.amount % 1 == 0
        ? money.amount.toInt().toString()
        : money.amount.toString();
    final totalStr = totalMoneyEarned.amount % 1 == 0
        ? totalMoneyEarned.amount.toInt().toString()
        : totalMoneyEarned.amount.toString();
    final clickStr = clickBonusTotal % 1 == 0
        ? clickBonusTotal.toInt().toString()
        : clickBonusTotal.toString();
    final incomeStr = incomePerSecondTotal % 1 == 0
        ? incomePerSecondTotal.toInt().toString()
        : incomePerSecondTotal.toString();
    final multStr = multiplierTotal % 1 == 0
        ? multiplierTotal.toInt().toString()
        : multiplierTotal.toString();

    return {
      'money': moneyStr,
      'totalMoneyEarned': totalStr,
      'currentCareerLevel': currentCareerLevel,
      'clickBonusTotal': clickStr,
      'incomePerSecondTotal': incomeStr,
      'multiplierTotal': multStr,
      'purchasedUpgrades': purchasedUpgrades.map(
        (key, value) => MapEntry(key, {'level': value.level}),
      ),
      'lastSaveTime': lastSaveTime.toIso8601String(),
      'isCEO': isCEO,
    };
  }

  /// Carrega o estado (para implementar com shared_preferences)
  /// Converte Strings/doubles de volta para doubles com precisão
  /// Suporta ambos formatos para backward compatibility
  static GameState fromJson(Map<String, dynamic> json) {
    final state = GameState();

    // Helper para converter double ou string para double
    double parseDoubleValue(dynamic value) {
      if (value == null) return 0;
      if (value is String) return double.parse(value);
      if (value is int) return value.toDouble();
      if (value is double) return value;
      return 0;
    }

    state.money = Money(parseDoubleValue(json['money']));
    state.totalMoneyEarned = Money(parseDoubleValue(json['totalMoneyEarned']));
    state.currentCareerLevel = json['currentCareerLevel'] as int? ?? 0;
    state.clickBonusTotal = parseDoubleValue(json['clickBonusTotal']);
    state.incomePerSecondTotal = parseDoubleValue(json['incomePerSecondTotal']);
    final mult = parseDoubleValue(json['multiplierTotal']);
    state.multiplierTotal = mult > 0 ? mult : 1.0;
    state.lastSaveTime = DateTime.parse(
      json['lastSaveTime'] as String? ?? DateTime.now().toIso8601String(),
    );
    state.isCEO = json['isCEO'] as bool? ?? false;

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

  /// Adiciona um bônus ativo
  void addActiveBonus(ActiveBonus bonus) {
    activeBonuses.add(bonus);
  }

  /// Remove bônus expirados e retorna true se houve mudanças
  bool cleanExpiredBonuses() {
    final beforeLength = activeBonuses.length;
    activeBonuses = activeBonuses.where((bonus) {
      if (bonus.type == BonusType.instantMoney) {
        return false; // Remover bônus instantâneos
      }
      return bonus.isActive;
    }).toList();
    return activeBonuses.length != beforeLength;
  }

  /// Calcula o multiplicador total de renda baseado em bônus ativos
  double getIncomeMultiplierBonus() {
    cleanExpiredBonuses();
    double multiplier = 1.0;
    for (final bonus in activeBonuses) {
      if (bonus.type == BonusType.incomeMultiplier && bonus.isActive) {
        multiplier += bonus.value; // valor já vem como 1.0 para 2x (100% extra)
      }
    }
    return multiplier;
  }

  /// Calcula o multiplicador total de cliques baseado em bônus ativos
  double getClickMultiplierBonus() {
    cleanExpiredBonuses();
    double multiplier = 1.0;
    for (final bonus in activeBonuses) {
      if (bonus.type == BonusType.clickMultiplier && bonus.isActive) {
        multiplier += bonus.value;
      }
    }
    return multiplier;
  }

  /// Retorna lista de bônus ativos e válidos
  List<ActiveBonus> getActiveBonuses() {
    cleanExpiredBonuses();
    return activeBonuses.where((b) => b.isActive).toList();
  }
}
