import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/game_service.dart';
import '../models/career.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Estatísticas'),
        backgroundColor: const Color(0xFF1565C0),
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
                _buildSessionInfo(sessionDuration),
                const SizedBox(height: 16),
                _buildGameStats(gameService, stats),
                const SizedBox(height: 16),
                _buildCareerInfo(gameService),
                const SizedBox(height: 16),
                _buildUpgradeStats(gameService),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSessionInfo(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sessão Atual',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tempo jogando'),
                Text(
                  '${minutes}m ${seconds}s',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameStats(GameService gameService, Map<String, dynamic> stats) {
    final totalClicks = stats['total_clicks'] ?? 0;
    final totalUpgrades = stats['total_upgrades_bought'] ?? 0;
    final totalPromos = stats['total_promotions'] ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Atividade',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildStatRow('Cliques totais', totalClicks.toString()),
            const SizedBox(height: 8),
            _buildStatRow('Upgrades comprados', totalUpgrades.toString()),
            const SizedBox(height: 8),
            _buildStatRow('Promoções', totalPromos.toString()),
            const SizedBox(height: 8),
            _buildStatRow(
              'Total ganho',
              '\$${gameService.state.totalMoneyEarned.format()}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCareerInfo(GameService gameService) {
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Carreira',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              career.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1565C0),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Renda: \$${career.baseIncome.format()}/clique',
              style: const TextStyle(fontSize: 14),
            ),
            if (nextCareer != null) ...[
              const SizedBox(height: 12),
              Text(
                'Próximo: ${nextCareer.title}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF4CAF50),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '\$${gameService.state.totalMoneyEarned.format()} / \$${nextCareer.requiredMoney.format()}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ] else
              const SizedBox(height: 8),
            const Text(
              '🏆 Você é o CEO!',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFB300),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpgradeStats(GameService gameService) {
    final upgradeStats = gameService.state.purchasedUpgrades.entries
        .where((e) => e.value.level > 1)
        .toList();

    if (upgradeStats.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Upgrades (Principais)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...upgradeStats.map((e) {
              final upgrade = e.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: _buildStatRow(
                  '${upgrade.upgrade.emoji} ${upgrade.upgrade.name}',
                  'Nível ${upgrade.level}',
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1565C0),
          ),
        ),
      ],
    );
  }
}
