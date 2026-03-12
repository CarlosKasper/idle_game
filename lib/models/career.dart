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
    title: 'Junior',
    baseIncome: Money(3),
    requiredMoney: Money(100),
  ),
  CareerLevel(
    id: 2,
    title: 'Pleno',
    baseIncome: Money(10),
    requiredMoney: Money(5000),
  ),
  CareerLevel(
    id: 3,
    title: 'Pleno Plus',
    baseIncome: Money(25),
    requiredMoney: Money(50000),
  ),
  CareerLevel(
    id: 4,
    title: 'Senior',
    baseIncome: Money(60),
    requiredMoney: Money(500000),
  ),
  CareerLevel(
    id: 5,
    title: 'Líder de Engenharia',
    baseIncome: Money(150),
    requiredMoney: Money(5000000),
  ),
  CareerLevel(
    id: 6,
    title: 'Arquiteto de Software',
    baseIncome: Money(300),
    requiredMoney: Money(25000000),
  ),
  CareerLevel(
    id: 7,
    title: 'Gestor de Projetos',
    baseIncome: Money(400),
    requiredMoney: Money(100000000),
  ),
  CareerLevel(
    id: 8,
    title: 'Gerente de Departamento',
    baseIncome: Money(600),
    requiredMoney: Money(500000000),
  ),
  CareerLevel(
    id: 9,
    title: 'Diretor Executivo',
    baseIncome: Money(1000),
    requiredMoney: Money(2000000000),
  ),
  CareerLevel(
    id: 10,
    title: 'CEO',
    baseIncome: Money(2000),
    requiredMoney: Money(10000000000),
  ),
];
