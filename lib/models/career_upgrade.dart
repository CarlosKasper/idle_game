import 'money.dart';
import 'upgrade.dart';

/// Define um upgrade de carreira que desbloqueia em um nível específico
class CareerUpgrade {
  final String id;
  final String nameKey;
  final String descriptionKey;
  final String emoji;
  final UpgradeType type;
  final Money baseCost;
  final double value; // valor do bônus
  final int unlocksAtCareerLevel; // Em qual nível de carreira desbloqueia
  final bool
  isInfinite; // se pode ser comprado múltiplas vezes (padrão: false para multiplicadores)

  const CareerUpgrade({
    required this.id,
    required this.nameKey,
    required this.descriptionKey,
    required this.emoji,
    required this.type,
    required this.baseCost,
    required this.value,
    required this.unlocksAtCareerLevel,
    this.isInfinite = false,
  });

  // Getters para manter compatibilidade com Upgrade
  String get name => nameKey; // Retorna a chave como fallback
  String get description => descriptionKey; // Retorna a chave como fallback
}

/// Upgrades de carreira pré-definidos
final careerUpgrades = [
  // Estagiário (Level 0)
  CareerUpgrade(
    id: 'course',
    nameKey: 'careerCourseName',
    descriptionKey: 'careerCourseDesc',
    emoji: '📚',
    type: UpgradeType.clickBonus,
    baseCost: Money(50),
    value: 1,
    unlocksAtCareerLevel: 0,
    isInfinite: true,
  ),
  CareerUpgrade(
    id: 'monitor',
    nameKey: 'careerMonitorName',
    descriptionKey: 'careerMonitorDesc',
    emoji: '🖥️',
    type: UpgradeType.incomeBonus,
    baseCost: Money(100),
    value: 1,
    unlocksAtCareerLevel: 0,
    isInfinite: true,
  ),

  // Junior (Level 1)
  CareerUpgrade(
    id: 'coffee_premium',
    nameKey: 'careerCoffeeName',
    descriptionKey: 'careerCoffeeDesc',
    emoji: '☕',
    type: UpgradeType.clickBonus,
    baseCost: Money(300),
    value: 2,
    unlocksAtCareerLevel: 1,
    isInfinite: true,
  ),
  CareerUpgrade(
    id: 'desk_lamp',
    nameKey: 'careerLampName',
    descriptionKey: 'careerLampDesc',
    emoji: '💡',
    type: UpgradeType.incomeBonus,
    baseCost: Money(400),
    value: 1,
    unlocksAtCareerLevel: 1,
    isInfinite: true,
  ),

  // Pleno (Level 2)
  CareerUpgrade(
    id: 'second_monitor',
    nameKey: 'careerSecondMonitorName',
    descriptionKey: 'careerSecondMonitorDesc',
    emoji: '🖥️',
    type: UpgradeType.incomeBonus,
    baseCost: Money(500),
    value: 2,
    unlocksAtCareerLevel: 2,
    isInfinite: true,
  ),
  CareerUpgrade(
    id: 'productivity_app',
    nameKey: 'careerAppName',
    descriptionKey: 'careerAppDesc',
    emoji: '📱',
    type: UpgradeType.multiplier,
    baseCost: Money(50000),
    value: 0.10,
    unlocksAtCareerLevel: 2,
    isInfinite: false,
  ),

  // Pleno Plus (Level 3)
  CareerUpgrade(
    id: 'standing_desk',
    nameKey: 'careerDeskName',
    descriptionKey: 'careerDeskDesc',
    emoji: '🏢',
    type: UpgradeType.incomeBonus,
    baseCost: Money(5000),
    value: 5,
    unlocksAtCareerLevel: 3,
    isInfinite: true,
  ),
  CareerUpgrade(
    id: 'mentorship',
    nameKey: 'careerMentorshipName',
    descriptionKey: 'careerMentorshipDesc',
    emoji: '🎓',
    type: UpgradeType.multiplier,
    baseCost: Money(2000000),
    value: 0.20,
    unlocksAtCareerLevel: 3,
    isInfinite: false,
  ),

  // Senior (Level 4)
  CareerUpgrade(
    id: 'private_office',
    nameKey: 'careerOfficeName',
    descriptionKey: 'careerOfficeDesc',
    emoji: '🏛️',
    type: UpgradeType.incomeBonus,
    baseCost: Money(50000),
    value: 10,
    unlocksAtCareerLevel: 4,
    isInfinite: true,
  ),
  CareerUpgrade(
    id: 'stock_options',
    nameKey: 'careerStockName',
    descriptionKey: 'careerStockDesc',
    emoji: '📈',
    type: UpgradeType.multiplier,
    baseCost: Money(75000000),
    value: 0.35,
    unlocksAtCareerLevel: 4,
    isInfinite: false,
  ),

  // Líder de Engenharia (Level 5)
  CareerUpgrade(
    id: 'team_building',
    nameKey: 'careerTeamName',
    descriptionKey: 'careerTeamDesc',
    emoji: '👥',
    type: UpgradeType.incomeBonus,
    baseCost: Money(300000),
    value: 20,
    unlocksAtCareerLevel: 5,
    isInfinite: true,
  ),
  CareerUpgrade(
    id: 'innovation_lab',
    nameKey: 'careerLabName',
    descriptionKey: 'careerLabDesc',
    emoji: '🔬',
    type: UpgradeType.multiplier,
    baseCost: Money(500000000),
    value: 0.50,
    unlocksAtCareerLevel: 5,
    isInfinite: false,
  ),

  // Arquiteto de Software (Level 6)
  CareerUpgrade(
    id: 'consulting_firm',
    nameKey: 'careerConsultingName',
    descriptionKey: 'careerConsultingDesc',
    emoji: '💼',
    type: UpgradeType.incomeBonus,
    baseCost: Money(2000000),
    value: 50,
    unlocksAtCareerLevel: 6,
    isInfinite: true,
  ),
  CareerUpgrade(
    id: 'patent_portfolio',
    nameKey: 'careerPatentName',
    descriptionKey: 'careerPatentDesc',
    emoji: '🎯',
    type: UpgradeType.multiplier,
    baseCost: Money(2500000000),
    value: 0.75,
    unlocksAtCareerLevel: 6,
    isInfinite: false,
  ),

  // Gestor de Projetos (Level 7)
  CareerUpgrade(
    id: 'project_automation',
    nameKey: 'careerAutomationName',
    descriptionKey: 'careerAutomationDesc',
    emoji: '🤖',
    type: UpgradeType.incomeBonus,
    baseCost: Money(10000000),
    value: 100,
    unlocksAtCareerLevel: 7,
    isInfinite: true,
  ),
  CareerUpgrade(
    id: 'executive_network',
    nameKey: 'careerNetworkName',
    descriptionKey: 'careerNetworkDesc',
    emoji: '🌐',
    type: UpgradeType.multiplier,
    baseCost: Money(800000000),
    value: 1.0,
    unlocksAtCareerLevel: 7,
    isInfinite: false,
  ),

  // Gerente de Departamento (Level 8)
  CareerUpgrade(
    id: 'corporate_jet',
    nameKey: 'careerJetName',
    descriptionKey: 'careerJetDesc',
    emoji: '✈️',
    type: UpgradeType.incomeBonus,
    baseCost: Money(50000000),
    value: 200,
    unlocksAtCareerLevel: 8,
    isInfinite: true,
  ),
  CareerUpgrade(
    id: 'market_dominance',
    nameKey: 'careerMarketName',
    descriptionKey: 'careerMarketDesc',
    emoji: '👑',
    type: UpgradeType.multiplier,
    baseCost: Money(1000000000),
    value: 1.5,
    unlocksAtCareerLevel: 8,
    isInfinite: false,
  ),

  // Diretor Executivo (Level 9)
  CareerUpgrade(
    id: 'global_expansion',
    nameKey: 'careerGlobalName',
    descriptionKey: 'careerGlobalDesc',
    emoji: '🌍',
    type: UpgradeType.incomeBonus,
    baseCost: Money(500000000),
    value: 500,
    unlocksAtCareerLevel: 9,
    isInfinite: true,
  ),
  CareerUpgrade(
    id: 'financial_empire',
    nameKey: 'careerEmpireName',
    descriptionKey: 'careerEmpireDesc',
    emoji: '💰',
    type: UpgradeType.multiplier,
    baseCost: Money(1500000000),
    value: 2.5,
    unlocksAtCareerLevel: 9,
    isInfinite: false,
  ),

  // CEO (Level 10)
  CareerUpgrade(
    id: 'money_printer',
    nameKey: 'careerPrinterName',
    descriptionKey: 'careerPrinterDesc',
    emoji: '🏭',
    type: UpgradeType.incomeBonus,
    baseCost: Money(250000000),
    value: 1000,
    unlocksAtCareerLevel: 10,
    isInfinite: true,
  ),
  CareerUpgrade(
    id: 'world_domination',
    nameKey: 'careerDominationName',
    descriptionKey: 'careerDominationDesc',
    emoji: '🚀',
    type: UpgradeType.multiplier,
    baseCost: Money(5000000000),
    value: 5.0,
    unlocksAtCareerLevel: 10,
    isInfinite: false,
  ),
];
