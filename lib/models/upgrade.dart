import 'money.dart';

enum UpgradeType {
  clickBonus, // aumenta dinheiro por clique
  incomeBonus, // aumenta dinheiro por segundo
  multiplier, // aumenta renda em %
}

/// Define um upgrade que pode ser comprado
class Upgrade {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final UpgradeType type;
  final Money baseCost;
  final double value; // valor do bônus
  final bool isInfinite; // pode ser comprado múltiplas vezes

  const Upgrade({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.type,
    required this.baseCost,
    required this.value,
    required this.isInfinite,
  });
}

/// Upgrades pré-definidos (Versão 1 - simples)
final availableUpgrades = [];
