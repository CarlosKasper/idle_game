import 'money.dart';

/// Define uma evolução de notebook
class NotebookEvolution {
  final int level; // 1 a 10
  final String name;
  final String description;
  final String emoji;
  final Money cost;
  final int clickBonusValue; // bônus por clique
  final double incomePerSecondValue; // bônus por segundo

  const NotebookEvolution({
    required this.level,
    required this.name,
    required this.description,
    required this.emoji,
    required this.cost,
    required this.clickBonusValue,
    required this.incomePerSecondValue,
  });
}

/// Evoluções de notebook pré-definidas
final notebookEvolutions = [
  NotebookEvolution(
    level: 1,
    name: 'Notebook Básico 💻',
    description: '+1 por clique, +0.5/s',
    emoji: '💻',
    cost: Money(50),
    clickBonusValue: 1,
    incomePerSecondValue: 0.5,
  ),
  NotebookEvolution(
    level: 2,
    name: 'Notebook Atualizado 💻',
    description: '+2 por clique, +1/s',
    emoji: '💻',
    cost: Money(500),
    clickBonusValue: 2,
    incomePerSecondValue: 1,
  ),
  NotebookEvolution(
    level: 3,
    name: 'Notebook Profissional 💼',
    description: '+5 por clique, +2/s',
    emoji: '💼',
    cost: Money(5000),
    clickBonusValue: 5,
    incomePerSecondValue: 2,
  ),
  NotebookEvolution(
    level: 4,
    name: 'Workstation 🖥️',
    description: '+10 por clique, +5/s',
    emoji: '🖥️',
    cost: Money(50000),
    clickBonusValue: 10,
    incomePerSecondValue: 5,
  ),
  NotebookEvolution(
    level: 5,
    name: 'Super Workstation ⚡',
    description: '+25 por clique, +10/s',
    emoji: '⚡',
    cost: Money(500000),
    clickBonusValue: 25,
    incomePerSecondValue: 10,
  ),
  NotebookEvolution(
    level: 6,
    name: 'Gaming Rig 🎮',
    description: '+50 por clique, +25/s',
    emoji: '🎮',
    cost: Money(5000000),
    clickBonusValue: 50,
    incomePerSecondValue: 25,
  ),
  NotebookEvolution(
    level: 7,
    name: 'Server Room 🖧',
    description: '+100 por clique, +50/s',
    emoji: '🖧',
    cost: Money(50000000),
    clickBonusValue: 100,
    incomePerSecondValue: 50,
  ),
  NotebookEvolution(
    level: 8,
    name: 'Data Center 🏢',
    description: '+250 por clique, +100/s',
    emoji: '🏢',
    cost: Money(500000000),
    clickBonusValue: 250,
    incomePerSecondValue: 100,
  ),
  NotebookEvolution(
    level: 9,
    name: 'Quantum Computer 🌌',
    description: '+500 por clique, +250/s',
    emoji: '🌌',
    cost: Money(5000000000),
    clickBonusValue: 500,
    incomePerSecondValue: 250,
  ),
  NotebookEvolution(
    level: 10,
    name: 'Superinteligência 🤖',
    description: '+1000 por clique, +500/s',
    emoji: '🤖',
    cost: Money(50000000000),
    clickBonusValue: 1000,
    incomePerSecondValue: 500,
  ),
];
