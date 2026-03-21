import 'money.dart';
import 'upgrade.dart';

/// Define um upgrade de carreira que desbloqueia em um nível específico
class CareerUpgrade {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final UpgradeType type;
  final Money baseCost;
  final double value; // valor do bônus
  final int unlocksAtCareerLevel; // Em qual nível de carreira desbloqueia
  final bool
  isInfinite; // se pode ser comprado múltiplas vezes (padrão: false para multiplicadores)

  const CareerUpgrade({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.type,
    required this.baseCost,
    required this.value,
    required this.unlocksAtCareerLevel,
    this.isInfinite = false,
  });
}

/// Upgrades de carreira pré-definidos
final careerUpgrades = [
  // Estagiário (Level 0)
  CareerUpgrade(
    id: 'course',
    name: 'Curso Online 📚',
    description: '+1 dinheiro por clique',
    emoji: '📚',
    type: UpgradeType.clickBonus,
    baseCost: Money(50),
    value: 1,
    unlocksAtCareerLevel: 0,
    isInfinite: true,
  ),
  CareerUpgrade(
    id: 'monitor',
    name: 'Monitor Extra 🖥️',
    description: '+1 dinheiro por segundo',
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
    name: 'Café Premium ☕',
    description: '+2 por clique',
    emoji: '☕',
    type: UpgradeType.clickBonus,
    baseCost: Money(300),
    value: 2,
    unlocksAtCareerLevel: 1,
    isInfinite: true,
  ),
  CareerUpgrade(
    id: 'desk_lamp',
    name: 'Luminária para Mesa 💡',
    description: '+1 por segundo',
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
    name: 'Segundo Monitor 🖥️',
    description: '+2 por segundo',
    emoji: '🖥️',
    type: UpgradeType.incomeBonus,
    baseCost: Money(500),
    value: 2,
    unlocksAtCareerLevel: 2,
    isInfinite: true,
  ),
  CareerUpgrade(
    id: 'productivity_app',
    name: 'App de Produtividade 📱',
    description: '+10% renda',
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
    name: 'Mesa em Pé 🏢',
    description: '+5 por segundo',
    emoji: '🏢',
    type: UpgradeType.incomeBonus,
    baseCost: Money(5000),
    value: 5,
    unlocksAtCareerLevel: 3,
    isInfinite: true,
  ),
  CareerUpgrade(
    id: 'mentorship',
    name: 'Programa de Mentoria 🎓',
    description: '+20% renda',
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
    name: 'Escritório Particular 🏛️',
    description: '+10 por segundo',
    emoji: '🏛️',
    type: UpgradeType.incomeBonus,
    baseCost: Money(50000),
    value: 10,
    unlocksAtCareerLevel: 4,
    isInfinite: true,
  ),
  CareerUpgrade(
    id: 'stock_options',
    name: 'Opções de Ações 📈',
    description: '+35% renda',
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
    name: 'Desenvolvimento de Time 👥',
    description: '+20 por segundo',
    emoji: '👥',
    type: UpgradeType.incomeBonus,
    baseCost: Money(300000),
    value: 20,
    unlocksAtCareerLevel: 5,
    isInfinite: true,
  ),
  CareerUpgrade(
    id: 'innovation_lab',
    name: 'Lab de Inovação 🔬',
    description: '+50% renda',
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
    name: 'Firma de Consultoria 💼',
    description: '+50 por segundo',
    emoji: '💼',
    type: UpgradeType.incomeBonus,
    baseCost: Money(2000000),
    value: 50,
    unlocksAtCareerLevel: 6,
    isInfinite: true,
  ),
  CareerUpgrade(
    id: 'patent_portfolio',
    name: 'Portfólio de Patentes 🎯',
    description: '+75% renda',
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
    name: 'Automação de Projetos 🤖',
    description: '+100 por segundo',
    emoji: '🤖',
    type: UpgradeType.incomeBonus,
    baseCost: Money(10000000),
    value: 100,
    unlocksAtCareerLevel: 7,
    isInfinite: true,
  ),
  CareerUpgrade(
    id: 'executive_network',
    name: 'Rede Executiva 🌐',
    description: '+100% renda',
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
    name: 'Jato Corporativo ✈️',
    description: '+200 por segundo',
    emoji: '✈️',
    type: UpgradeType.incomeBonus,
    baseCost: Money(50000000),
    value: 200,
    unlocksAtCareerLevel: 8,
    isInfinite: true,
  ),
  CareerUpgrade(
    id: 'market_dominance',
    name: 'Dominação de Mercado 👑',
    description: '+150% renda',
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
    name: 'Expansão Global 🌍',
    description: '+500 por segundo',
    emoji: '🌍',
    type: UpgradeType.incomeBonus,
    baseCost: Money(500000000),
    value: 500,
    unlocksAtCareerLevel: 9,
    isInfinite: true,
  ),
  CareerUpgrade(
    id: 'financial_empire',
    name: 'Império Financeiro 💰',
    description: '+250% renda',
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
    name: 'Máquina de Dinheiro 🏭',
    description: '+1000 por segundo',
    emoji: '🏭',
    type: UpgradeType.incomeBonus,
    baseCost: Money(250000000),
    value: 1000,
    unlocksAtCareerLevel: 10,
    isInfinite: true,
  ),
  CareerUpgrade(
    id: 'world_domination',
    name: 'Domínio Mundial 🚀',
    description: '+500% renda',
    emoji: '🚀',
    type: UpgradeType.multiplier,
    baseCost: Money(5000000000),
    value: 5.0,
    unlocksAtCareerLevel: 10,
    isInfinite: false,
  ),
];
