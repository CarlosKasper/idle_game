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
final availableUpgrades = [
  Upgrade(
    id: 'coffee',
    name: 'Café ☕',
    description: '+1 dinheiro por clique',
    emoji: '☕',
    type: UpgradeType.clickBonus,
    baseCost: Money(10),
    value: 1,
    isInfinite: true,
  ),
  Upgrade(
    id: 'notebook',
    name: 'Notebook Melhor 💻',
    description: '+2 dinheiro por clique',
    emoji: '💻',
    type: UpgradeType.clickBonus,
    baseCost: Money(100),
    value: 2,
    isInfinite: true,
  ),
  Upgrade(
    id: 'chair',
    name: 'Cadeira Ergonômica 🪑',
    description: '+0.5 dinheiro por segundo',
    emoji: '🪑',
    type: UpgradeType.incomeBonus,
    baseCost: Money(50),
    value: 0.5,
    isInfinite: true,
  ),
  Upgrade(
    id: 'course',
    name: 'Curso Online 📚',
    description: '+10% renda',
    emoji: '📚',
    type: UpgradeType.multiplier,
    baseCost: Money(500),
    value: 0.10, // 10%
    isInfinite: false, // apenas uma vez
  ),
  Upgrade(
    id: 'monitor',
    name: 'Monitor Extra 🖥️',
    description: '+5% renda',
    emoji: '🖥️',
    type: UpgradeType.multiplier,
    baseCost: Money(200),
    value: 0.05, // 5%
    isInfinite: false,
  ),
];
