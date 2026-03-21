import 'money.dart';

/// Define uma evolução de notebook
class NotebookEvolution {
  final int level; // 1 a 10
  final String nameKey; // Chave de localização para o nome
  final String descriptionKey; // Chave de localização para a descrição
  final String emoji;
  final Money cost;
  final int clickBonusValue; // bônus por clique
  final double incomePerSecondValue; // bônus por segundo

  const NotebookEvolution({
    required this.level,
    required this.nameKey,
    required this.descriptionKey,
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
    nameKey: 'notebookBasicName',
    descriptionKey: 'notebookBasicDesc',
    emoji: '💻',
    cost: Money(50),
    clickBonusValue: 1,
    incomePerSecondValue: 0.5,
  ),
  NotebookEvolution(
    level: 2,
    nameKey: 'notebookUpdatedName',
    descriptionKey: 'notebookUpdatedDesc',
    emoji: '💻',
    cost: Money(500),
    clickBonusValue: 2,
    incomePerSecondValue: 1,
  ),
  NotebookEvolution(
    level: 3,
    nameKey: 'notebookProfessionalName',
    descriptionKey: 'notebookProfessionalDesc',
    emoji: '💼',
    cost: Money(5000),
    clickBonusValue: 5,
    incomePerSecondValue: 2,
  ),
  NotebookEvolution(
    level: 4,
    nameKey: 'workstationName',
    descriptionKey: 'workstationDesc',
    emoji: '🖥️',
    cost: Money(50000),
    clickBonusValue: 10,
    incomePerSecondValue: 5,
  ),
  NotebookEvolution(
    level: 5,
    nameKey: 'superWorkstationName',
    descriptionKey: 'superWorkstationDesc',
    emoji: '⚡',
    cost: Money(500000),
    clickBonusValue: 25,
    incomePerSecondValue: 10,
  ),
  NotebookEvolution(
    level: 6,
    nameKey: 'gamingRigName',
    descriptionKey: 'gamingRigDesc',
    emoji: '🎮',
    cost: Money(5000000),
    clickBonusValue: 50,
    incomePerSecondValue: 25,
  ),
  NotebookEvolution(
    level: 7,
    nameKey: 'serverRoomName',
    descriptionKey: 'serverRoomDesc',
    emoji: '🖧',
    cost: Money(50000000),
    clickBonusValue: 100,
    incomePerSecondValue: 50,
  ),
  NotebookEvolution(
    level: 8,
    nameKey: 'dataCenterName',
    descriptionKey: 'dataCenterDesc',
    emoji: '🏢',
    cost: Money(500000000),
    clickBonusValue: 250,
    incomePerSecondValue: 100,
  ),
  NotebookEvolution(
    level: 9,
    nameKey: 'quantumComputerName',
    descriptionKey: 'quantumComputerDesc',
    emoji: '🌌',
    cost: Money(5000000000),
    clickBonusValue: 500,
    incomePerSecondValue: 250,
  ),
  NotebookEvolution(
    level: 10,
    nameKey: 'superintelligenceName',
    descriptionKey: 'superintelligenceDesc',
    emoji: '🤖',
    cost: Money(50000000000),
    clickBonusValue: 1000,
    incomePerSecondValue: 500,
  ),
];
