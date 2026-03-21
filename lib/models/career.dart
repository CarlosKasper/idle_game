import 'money.dart';

/// Estrutura de carreira corporativa
class CareerLevel {
  final int id;
  final String titleKey;
  final Money baseIncome; // renda por clique
  final Money requiredMoney; // dinheiro total ganho para subir

  const CareerLevel({
    required this.id,
    required this.titleKey,
    required this.baseIncome,
    required this.requiredMoney,
  });

  // Getter para manter compatibilidade com código existente
  String get title => titleKey; // Retorna a chave como fallback
}

/// Níveis de carreira pré-definidos
final careerLevels = [
  CareerLevel(
    id: 0,
    titleKey: 'careerLevelIntern',
    baseIncome: Money(1),
    requiredMoney: Money(0),
  ),
  CareerLevel(
    id: 1,
    titleKey: 'careerLevelJunior',
    baseIncome: Money(3),
    requiredMoney: Money(100),
  ),
  CareerLevel(
    id: 2,
    titleKey: 'careerLevelPleno',
    baseIncome: Money(10),
    requiredMoney: Money(5000),
  ),
  CareerLevel(
    id: 3,
    titleKey: 'careerLevelPlenoPlus',
    baseIncome: Money(25),
    requiredMoney: Money(50000),
  ),
  CareerLevel(
    id: 4,
    titleKey: 'careerLevelSenior',
    baseIncome: Money(60),
    requiredMoney: Money(500000),
  ),
  CareerLevel(
    id: 5,
    titleKey: 'careerLevelEngineeringLead',
    baseIncome: Money(150),
    requiredMoney: Money(5000000),
  ),
  CareerLevel(
    id: 6,
    titleKey: 'careerLevelArchitect',
    baseIncome: Money(300),
    requiredMoney: Money(25000000),
  ),
  CareerLevel(
    id: 7,
    titleKey: 'careerLevelProjectManager',
    baseIncome: Money(400),
    requiredMoney: Money(100000000),
  ),
  CareerLevel(
    id: 8,
    titleKey: 'careerLevelDirector',
    baseIncome: Money(600),
    requiredMoney: Money(500000000),
  ),
  CareerLevel(
    id: 9,
    titleKey: 'careerLevelExecutive',
    baseIncome: Money(1000),
    requiredMoney: Money(2000000000),
  ),
  CareerLevel(
    id: 10,
    titleKey: 'careerLevelCEO',
    baseIncome: Money(2000),
    requiredMoney: Money(10000000000),
  ),
];
