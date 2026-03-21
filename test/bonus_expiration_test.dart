import 'package:flutter_test/flutter_test.dart';
import 'package:idle_game/models/active_bonus.dart';
import 'package:idle_game/models/game_state.dart';

void main() {
  group('Bonus Expiration Tests', () {
    test('Bonus should be active when just created', () {
      final bonus = ActiveBonus(
        id: 'test_bonus',
        name: 'Test Bonus',
        type: BonusType.incomeMultiplier,
        value: 1.0,
        activatedAt: DateTime.now(),
        duration: const Duration(hours: 1),
        emoji: '⚡',
      );

      expect(bonus.isActive, isTrue);
      expect(bonus.remainingSeconds, greaterThan(3599));
    });

    test('Bonus should expire after duration', () async {
      final pastTime = DateTime.now().subtract(
        const Duration(hours: 1, minutes: 1),
      );
      final bonus = ActiveBonus(
        id: 'test_bonus',
        name: 'Test Bonus',
        type: BonusType.incomeMultiplier,
        value: 1.0,
        activatedAt: pastTime,
        duration: const Duration(hours: 1),
        emoji: '⚡',
      );

      expect(bonus.isActive, isFalse);
      expect(bonus.remainingSeconds, equals(0));
    });

    test('Remaining time should be formatted correctly', () {
      final bonus = ActiveBonus(
        id: 'test_bonus',
        name: 'Test Bonus',
        type: BonusType.incomeMultiplier,
        value: 1.0,
        activatedAt: DateTime.now().subtract(const Duration(minutes: 30)),
        duration: const Duration(hours: 1),
        emoji: '⚡',
      );

      // Should show approximately 30 minutes remaining
      final formatted = bonus.remainingTimeFormatted;
      expect(formatted.contains(':'), isTrue);
      // Format is MM:SS, so should start with "30:"
      expect(
        formatted.startsWith('29:') || formatted.startsWith('30:'),
        isTrue,
      );
    });

    test('GameState should clean expired bonuses', () {
      final gameState = GameState();

      // Add a bonus that's already expired
      final expiredBonus = ActiveBonus(
        id: 'expired',
        name: 'Expired Bonus',
        type: BonusType.incomeMultiplier,
        value: 1.0,
        activatedAt: DateTime.now().subtract(const Duration(hours: 2)),
        duration: const Duration(hours: 1),
        emoji: '⚡',
      );

      // Add an active bonus
      final activeBonus = ActiveBonus(
        id: 'active',
        name: 'Active Bonus',
        type: BonusType.clickMultiplier,
        value: 1.0,
        activatedAt: DateTime.now(),
        duration: const Duration(hours: 1),
        emoji: '📱',
      );

      gameState.addActiveBonus(expiredBonus);
      gameState.addActiveBonus(activeBonus);

      expect(gameState.activeBonuses.length, equals(2));

      // Clean expired bonuses
      gameState.cleanExpiredBonuses();

      expect(gameState.activeBonuses.length, equals(1));
      expect(gameState.activeBonuses.first.id, equals('active'));
    });

    test('Income multiplier should apply correctly', () {
      final gameState = GameState();

      // Add income multiplier bonus (2x = 1.0 bonus)
      final incomeBonus = ActiveBonus(
        id: 'income_mult',
        name: 'Income 2x',
        type: BonusType.incomeMultiplier,
        value: 1.0,
        activatedAt: DateTime.now(),
        duration: const Duration(hours: 1),
        emoji: '⚡',
      );

      gameState.addActiveBonus(incomeBonus);

      final multiplier = gameState.getIncomeMultiplierBonus();
      expect(multiplier, equals(2.0)); // 1.0 base + 1.0 bonus = 2.0
    });

    test('Click multiplier should apply correctly', () {
      final gameState = GameState();

      // Add click multiplier bonus (2x = 1.0 bonus)
      final clickBonus = ActiveBonus(
        id: 'click_mult',
        name: 'Click 2x',
        type: BonusType.clickMultiplier,
        value: 1.0,
        activatedAt: DateTime.now(),
        duration: const Duration(minutes: 30),
        emoji: '📱',
      );

      gameState.addActiveBonus(clickBonus);

      final multiplier = gameState.getClickMultiplierBonus();
      expect(multiplier, equals(2.0)); // 1.0 base + 1.0 bonus = 2.0
    });

    test('Multiple bonuses should stack', () {
      final gameState = GameState();

      // Add two income bonuses
      final bonus1 = ActiveBonus(
        id: 'bonus1',
        name: 'Bonus 1',
        type: BonusType.incomeMultiplier,
        value: 1.0, // 2x
        activatedAt: DateTime.now(),
        duration: const Duration(hours: 1),
        emoji: '⚡',
      );

      final bonus2 = ActiveBonus(
        id: 'bonus2',
        name: 'Bonus 2',
        type: BonusType.incomeMultiplier,
        value: 2.0, // 3x
        activatedAt: DateTime.now(),
        duration: const Duration(hours: 1),
        emoji: '⚡⚡',
      );

      gameState.addActiveBonus(bonus1);
      gameState.addActiveBonus(bonus2);

      final multiplier = gameState.getIncomeMultiplierBonus();
      expect(multiplier, equals(4.0)); // 1.0 base + 1.0 + 2.0 = 4.0x
    });

    test('Instant money bonus should not appear in active list', () {
      final gameState = GameState();

      final instantBonus = ActiveBonus(
        id: 'instant',
        name: 'Instant Money',
        type: BonusType.instantMoney,
        value: 500,
        activatedAt: DateTime.now(),
        duration: Duration.zero,
        emoji: '💰',
      );

      gameState.addActiveBonus(instantBonus);

      final activeBonuses = gameState.getActiveBonuses();
      expect(activeBonuses.isEmpty, isTrue);
    });
  });
}
