import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/game_service.dart';
import '../models/career.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('📊', style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 12),
            const Text('Estatísticas'),
          ],
        ),
        elevation: 0,
      ),
      body: Consumer<GameService>(
        builder: (context, gameService, child) {
          if (!gameService.isInitialized) {
            return const Center(child: CircularProgressIndicator());
          }

          final stats = gameService.analytics.getSessionStats();
          final sessionDuration = gameService.analytics.getSessionDuration();

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                _buildSessionInfo(context, sessionDuration),
                const SizedBox(height: 16),
                _buildGameStats(context, gameService, stats),
                const SizedBox(height: 16),
                _buildCareerInfo(context, gameService),
                const SizedBox(height: 16),
                _buildUpgradeStats(context, gameService),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSessionInfo(BuildContext context, Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: primaryColor.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('⏱️', style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(width: 12),
                Text(
                  'Sessão Atual',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tempo jogando',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark ? Colors.grey[400] : Colors.grey,
                  ),
                ),
                Text(
                  '${minutes}m ${seconds}s',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameStats(
    BuildContext context,
    GameService gameService,
    Map<String, dynamic> stats,
  ) {
    final totalClicks = stats['total_clicks'] ?? 0;
    final totalUpgrades = stats['total_upgrades_bought'] ?? 0;
    final totalPromos = stats['total_promotions'] ?? 0;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: primaryColor.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('💪', style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(width: 12),
                Text(
                  'Atividade',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildStatRow(
              context,
              '👆',
              'Cliques totais',
              totalClicks.toString(),
            ),
            const SizedBox(height: 8),
            _buildStatRow(
              context,
              '⭐',
              'Upgrades comprados',
              totalUpgrades.toString(),
            ),
            const SizedBox(height: 8),
            _buildStatRow(context, '📈', 'Promoções', totalPromos.toString()),
            const SizedBox(height: 8),
            _buildStatRow(
              context,
              '💰',
              'Total ganho',
              '\$${gameService.state.totalMoneyEarned.format()}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCareerInfo(BuildContext context, GameService gameService) {
    final career = careerLevels[gameService.state.currentCareerLevel];
    final nextCareerIndex = gameService.state.currentCareerLevel + 1;
    final nextCareer = nextCareerIndex < careerLevels.length
        ? careerLevels[nextCareerIndex]
        : null;

    final progress = nextCareer != null
        ? (gameService.state.totalMoneyEarned.amount /
                  nextCareer.requiredMoney.amount)
              .clamp(0.0, 1.0)
        : 1.0;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    // Mapa de emojis para carreiras
    final careerEmojis = {
      'Estagiário': '📚',
      'Funcionário': '👔',
      'Analista': '📊',
      'Gerente': '👨‍💼',
      'Diretor': '🎯',
      'CEO': '👑',
    };

    final emoji = careerEmojis[career.title] ?? '💼';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: primaryColor.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(emoji, style: const TextStyle(fontSize: 18)),
                ),
                const SizedBox(width: 12),
                Text(
                  'Carreira',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              career.title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Renda: \$${career.baseIncome.format()}/clique',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey[400] : Colors.grey[700],
              ),
            ),
            if (nextCareer != null) ...[
              const SizedBox(height: 12),
              Text(
                'Próximo: ${nextCareer.title}',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: primaryColor.withOpacity(0.15),
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ),
              const SizedBox(height: 8),
              Text(
                '\$${gameService.state.totalMoneyEarned.format()} / \$${nextCareer.requiredMoney.format()}',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ] else
              const SizedBox(height: 8),
            Text(
              '🏆 Você é o CEO!',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFFB300),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpgradeStats(BuildContext context, GameService gameService) {
    final upgradeStats = gameService.state.purchasedUpgrades.entries
        .where((e) => e.value.level > 1)
        .toList();

    if (upgradeStats.isEmpty) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: primaryColor.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('⭐', style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(width: 12),
                Text(
                  'Upgrades (Principais)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...upgradeStats.map((e) {
              final upgrade = e.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: _buildStatRow(
                  context,
                  upgrade.upgrade.emoji,
                  upgrade.upgrade.name,
                  'Nível ${upgrade.level}',
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    String emoji,
    String label,
    String value,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.grey[400] : Colors.grey[700],
              ),
            ),
          ],
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
      ],
    );
  }
}
