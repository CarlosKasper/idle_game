import 'package:flutter_test/flutter_test.dart';
import 'package:idle_game/models/game_state.dart';
import 'package:idle_game/models/money.dart';

void main() {
  group('Money', () {
    test('format small numbers', () {
      expect(Money(10).format(), '10');
      expect(Money(100).format(), '100');
      expect(Money(999).format(), '999');
    });

    test('format thousands', () {
      expect(Money(1000).format(), '1.0K');
      expect(Money(10500).format(), '10.5K');
      expect(Money(999999).format(), '1000.0K');
    });

    test('format millions', () {
      expect(Money(1000000).format(), '1.0M');
      expect(Money(50000000).format(), '50.0M');
    });

    test('format billions', () {
      expect(Money(1000000000).format(), '1.0B');
      expect(Money(999000000000).format(), '999.0B');
    });

    test('format trillions', () {
      expect(Money(1000000000000).format(), '1.0T');
      expect(Money(1000000000000000).format(), '1000.0T');
    });

    test('arithmetic operations', () {
      final a = Money(100);
      final b = Money(50);

      expect((a + b).amount, 150);
      expect((a - b).amount, 50);
      expect((a * 2).amount, 200);
      expect((a / 2).amount, 50);
    });

    test('comparisons', () {
      final a = Money(100);
      final b = Money(50);

      expect(a > b, true);
      expect(a < b, false);
      expect(a >= Money(100), true);
      expect(a <= Money(100), true);
      expect(a == Money(100), true);
    });
  });

  group('GameState - Career System', () {
    late GameState state;

    setUp(() {
      state = GameState();
      state.initializePurchasedUpgrades();
    });

    test('starts at Estagiário', () {
      expect(state.currentCareerLevel, 0);
      expect(state.baseIncomePerClick, 1);
    });

    test('promotes to Funcionario when reaching 100', () {
      state.totalMoneyEarned = Money(100);
      state.checkCareerPromotion();
      expect(state.currentCareerLevel, 1);
      expect(state.baseIncomePerClick, 3);
    });

    test('promotes to Analista when reaching 5000', () {
      state.totalMoneyEarned = Money(5000);
      state.checkCareerPromotion();
      expect(state.currentCareerLevel, 2);
      expect(state.baseIncomePerClick, 10);
    });

    test('multiple promotions', () {
      state.totalMoneyEarned = Money(100000);
      state.checkCareerPromotion();
      expect(state.currentCareerLevel, 3); // Gerente
    });

    test('cannot promote beyond CEO', () {
      state.currentCareerLevel = 10;
      state.totalMoneyEarned = Money(100000000000);
      state.checkCareerPromotion();
      expect(state.currentCareerLevel, 10); // Still CEO (highest level)
    });
  });

  group('GameState - Income Calculation', () {
    late GameState state;

    setUp(() {
      state = GameState();
      state.initializePurchasedUpgrades();
    });

    test('initial click income equals base', () {
      final income = state.getClickIncome();
      expect(income.amount, 1);
    });

    test('click bonus increases income', () {
      state.clickBonusTotal = 5;
      final income = state.getClickIncome();
      expect(income.amount, 6); // 1 base + 5 bonus
    });

    test('multiplier affects click income', () {
      state.clickBonusTotal = 1;
      state.multiplierTotal = 2.0;
      final income = state.getClickIncome();
      expect(income.amount, 4); // (1 + 1) * 2
    });

    test('passive income starts at zero', () {
      final income = state.getIncomePerSecond();
      expect(income.amount, 0);
    });

    test('passive income bonus increases income per second', () {
      state.incomePerSecondTotal = 5.5;
      final income = state.getIncomePerSecond();
      expect(income.amount, 5.5);
    });

    test('multiplier affects passive income', () {
      state.incomePerSecondTotal = 10;
      state.multiplierTotal = 1.5;
      final income = state.getIncomePerSecond();
      expect(income.amount, 15); // 10 * 1.5
    });
  });

  group('GameState - Upgrades', () {
    late GameState state;

    setUp(() {
      state = GameState();
      state.initializePurchasedUpgrades();
    });

    test('can buy upgrade if has enough money', () {
      state.money = Money(100);
      final success = state.buyUpgrade('coffee');
      expect(success, true);
      expect(state.money.amount, 90); // 100 - 10
    });

    test('cannot buy upgrade if insufficient money', () {
      state.money = Money(5);
      final success = state.buyUpgrade('coffee');
      expect(success, false);
      expect(state.money.amount, 5); // Unchanged
    });

    test('click bonus upgrade increases click damage', () {
      state.money = Money(100);
      state.buyUpgrade('coffee');
      final income = state.getClickIncome();
      expect(income.amount, 2); // 1 base + 1 bonus
    });

    test('passive upgrade increases income per second', () {
      state.money = Money(100);
      state.buyUpgrade('chair');
      final income = state.getIncomePerSecond();
      expect(income.amount, 0.5);
    });

    test('multiplier upgrade can be bought once', () {
      state.money = Money(1000);
      final success = state.buyUpgrade('course'); // +10%
      expect(success, true);
      expect(state.multiplierTotal, 1.1); // Aumentou 10%

      // Tentar comprar novamente deve falhar
      final successAgain = state.buyUpgrade('course');
      expect(successAgain, false); // Não pode comprar novamente
      expect(state.multiplierTotal, 1.1); // Continua 1.1
    });

    test('infinite upgrades increase in level', () {
      state.money = Money(1000);
      state.buyUpgrade('coffee'); // Level 1 -> 2
      expect(state.purchasedUpgrades['coffee']!.level, 2);
    });

    test('cost increases for infinite upgrades', () {
      state.money = Money(1000);
      final first = state.purchasedUpgrades['coffee']!.getCurrentCost();
      expect(first.amount, 10);

      state.buyUpgrade('coffee');
      final second = state.purchasedUpgrades['coffee']!.getCurrentCost();
      expect(second.amount, 11.5); // 10 * 1.15
    });

    test('non-infinite upgrades can only be bought once', () {
      state.money = Money(10000);
      state.buyUpgrade('course');
      expect(state.purchasedUpgrades['course']!.level, 1);

      // Tentar comprar novamente
      final success = state.buyUpgrade('course');
      expect(success, false); // Falha na segunda compra
      expect(state.purchasedUpgrades['course']!.level, 1); // Level não muda
    });
  });

  group('GameState - Money Earning', () {
    late GameState state;

    setUp(() {
      state = GameState();
      state.initializePurchasedUpgrades();
    });

    test('earnMoneyFromClick increases money and total', () {
      state.earnMoneyFromClick();
      expect(state.money.amount, 1);
      expect(state.totalMoneyEarned.amount, 1);
    });

    test('earnMoneyFromClick triggers promotion', () {
      for (int i = 0; i < 100; i++) {
        state.earnMoneyFromClick();
      }
      expect(state.currentCareerLevel, 1); // Promoted to Funcionário
    });

    test('earnPassiveIncome calculates correctly', () {
      state.incomePerSecondTotal = 10;
      final duration = Duration(seconds: 5);
      state.earnPassiveIncome(duration);
      expect(state.money.amount, 50); // 10 * 5
    });

    test('earnPassiveIncome with half seconds', () {
      state.incomePerSecondTotal = 10;
      final duration = Duration(milliseconds: 500);
      state.earnPassiveIncome(duration);
      expect(state.money.amount, 5); // 10 * 0.5
    });
  });

  group('GameState - Save/Load', () {
    late GameState state;

    setUp(() {
      state = GameState();
      state.initializePurchasedUpgrades();
    });

    test('toJson serializes state', () {
      state.money = Money(1000);
      state.totalMoneyEarned = Money(5000);
      state.currentCareerLevel = 2;
      state.clickBonusTotal = 10;

      final json = state.toJson();
      expect(json['money'], '1000'); // Inteiros sem .0
      expect(json['totalMoneyEarned'], '5000');
      expect(json['currentCareerLevel'], 2);
      expect(json['clickBonusTotal'], '10'); // Inteiro sem .0
    });

    test('fromJson deserializes state', () {
      final json = {
        'money': '1000.0', // Strings para preservar precisão
        'totalMoneyEarned': '5000.0',
        'currentCareerLevel': 2,
        'clickBonusTotal': '10.0',
        'incomePerSecondTotal': '5.0',
        'multiplierTotal': '1.15',
        'purchasedUpgrades': {
          'coffee': {'level': 3},
        },
        'lastSaveTime': DateTime.now().toIso8601String(),
      };

      final loaded = GameState.fromJson(json);
      expect(loaded.money.amount, 1000);
      expect(loaded.totalMoneyEarned.amount, 5000);
      expect(loaded.currentCareerLevel, 2);
      expect(loaded.clickBonusTotal, 10);
      expect(loaded.purchasedUpgrades['coffee']!.level, 3);
    });

    test('round-trip serialization', () {
      state.money = Money(50000);
      state.totalMoneyEarned = Money(67890);
      state.clickBonusTotal = 3.5;

      // Compra upgrades (subtraí dinheiro)
      state.buyUpgrade('coffee');
      state.buyUpgrade('coffee');

      final moneyBefore = state.money.amount;

      final json = state.toJson();
      final loaded = GameState.fromJson(json);

      expect(
        loaded.money.amount,
        moneyBefore,
      ); // Mesmo valor que antes de serializar
      expect(loaded.totalMoneyEarned.amount, 67890);
      expect(
        loaded.clickBonusTotal,
        greaterThan(3.5),
      ); // Aumentado pelas compras
      expect(loaded.purchasedUpgrades['coffee']!.level, 3);
    });
  });
}
