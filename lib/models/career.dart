import 'money.dart';

/// Estrutura de carreira corporativa
class CareerLevel {
  final int id;
  final String title;
  final Money baseIncome; // renda por clique
  final Money requiredMoney; // dinheiro total ganho para subir

  const CareerLevel({
    required this.id,
    required this.title,
    required this.baseIncome,
    required this.requiredMoney,
  });
}

/// Níveis de carreira pré-definidos
final careerLevels = [
  CareerLevel(
    id: 0,
    title: 'Estagiário',
    baseIncome: Money(1),
    requiredMoney: Money(0),
  ),
  CareerLevel(
    id: 1,
    title: 'Funcionário',
    baseIncome: Money(3),
    requiredMoney: Money(100),
  ),
  CareerLevel(
    id: 2,
    title: 'Analista',
    baseIncome: Money(10),
    requiredMoney: Money(5000),
  ),
  CareerLevel(
    id: 3,
    title: 'Gerente',
    baseIncome: Money(50),
    requiredMoney: Money(100000),
  ),
  CareerLevel(
    id: 4,
    title: 'Diretor',
    baseIncome: Money(200),
    requiredMoney: Money(2000000),
  ),
  CareerLevel(
    id: 5,
    title: 'CEO',
    baseIncome: Money(1000),
    requiredMoney: Money(50000000),
  ),
];
