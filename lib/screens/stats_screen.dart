import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/game_service.dart';
import '../models/career.dart' as career_model;

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: Consumer<GameService>(
        builder: (context, gameService, child) {
          if (!gameService.isInitialized) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF4ADE80)),
            );
          }

          final stats = gameService.analytics.getSessionStats();
          final sessionDuration = gameService.analytics.getSessionDuration();

          return SafeArea(
            child: Column(
              children: [
                _ScreenHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _SessionInfoCard(duration: sessionDuration),
                        const SizedBox(height: 20),
                        _GameStatsCard(gameService: gameService, stats: stats),
                        const SizedBox(height: 20),
                        _CareerInfoCard(gameService: gameService),
                        const SizedBox(height: 20),
                        _UpgradeStatsCard(gameService: gameService),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// SCREEN HEADER
// ─────────────────────────────────────────────────

class _ScreenHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF141418),
        border: Border(bottom: BorderSide(color: Color(0xFF2A2A30), width: 2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text('📊', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Text(
                'ESTATÍSTICAS',
                style: GoogleFonts.silkscreen(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// SESSION INFO CARD
// ─────────────────────────────────────────────────

class _SessionInfoCard extends StatelessWidget {
  final Duration duration;

  const _SessionInfoCard({required this.duration});

  @override
  Widget build(BuildContext context) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;

    return _PixelContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('⏱️', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                'SESSÃO ATUAL',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  color: Colors.white70,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tempo jogando',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 9,
                  color: Colors.white54,
                ),
              ),
              Text(
                '${minutes}m ${seconds}s',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  color: const Color(0xFF4ADE80),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// GAME STATS CARD
// ─────────────────────────────────────────────────

class _GameStatsCard extends StatelessWidget {
  final GameService gameService;
  final Map<String, dynamic> stats;

  const _GameStatsCard({required this.gameService, required this.stats});

  @override
  Widget build(BuildContext context) {
    final totalClicks = stats['total_clicks'] ?? 0;
    final totalUpgrades = stats['total_upgrades_bought'] ?? 0;
    final totalPromos = stats['total_promotions'] ?? 0;

    return _PixelContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('💪', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                'ATIVIDADE',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  color: Colors.white70,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _StatRow(
            emoji: '👆',
            label: 'Cliques totais',
            value: totalClicks.toString(),
          ),
          const SizedBox(height: 12),
          _StatRow(
            emoji: '⭐',
            label: 'Upgrades comprados',
            value: totalUpgrades.toString(),
          ),
          const SizedBox(height: 12),
          _StatRow(
            emoji: '📈',
            label: 'Promoções',
            value: totalPromos.toString(),
          ),
          const SizedBox(height: 12),
          _StatRow(
            emoji: '💰',
            label: 'Total ganho',
            value: '\$${gameService.state.totalMoneyEarned.format()}',
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// CAREER INFO CARD
// ─────────────────────────────────────────────────

class _CareerInfoCard extends StatelessWidget {
  final GameService gameService;

  const _CareerInfoCard({required this.gameService});

  @override
  Widget build(BuildContext context) {
    final career =
        career_model.careerLevels[gameService.state.currentCareerLevel];
    final nextCareerIndex = gameService.state.currentCareerLevel + 1;
    final nextCareer = nextCareerIndex < career_model.careerLevels.length
        ? career_model.careerLevels[nextCareerIndex]
        : null;

    final progress = nextCareer != null
        ? (gameService.state.totalMoneyEarned.amount /
                  nextCareer.requiredMoney.amount)
              .clamp(0.0, 1.0)
        : 1.0;

    final careerEmojis = {
      'Estagiário': '📚',
      'Junior': '👔',
      'Pleno': '📊',
      'Pleno Plus': '👨‍💼',
      'Senior': '🎩',
      'CEO': '👑',
    };

    final emoji = careerEmojis[career.title] ?? '💼';

    return _PixelContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                'CARREIRA',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  color: Colors.white70,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            career.title.toUpperCase(),
            style: GoogleFonts.silkscreen(
              fontSize: 24,
              color: const Color(0xFF4ADE80),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Renda: \$${career.baseIncome.format()}/clique',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 9,
              color: const Color(0xFFEAB308),
              fontWeight: FontWeight.w600,
            ),
          ),
          if (nextCareer != null) ...[
            const SizedBox(height: 16),
            Text(
              'PRÓXIMO: ${nextCareer.title.toUpperCase()}',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 9,
                color: Colors.white54,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            // Progress bar
            Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A30),
                border: Border.all(color: const Color(0xFF2A2A30), width: 1),
              ),
              child: FractionallySizedBox(
                widthFactor: progress,
                alignment: Alignment.centerLeft,
                child: Container(color: const Color(0xFF4ADE80)),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${gameService.state.totalMoneyEarned.format()} / \$${nextCareer.requiredMoney.format()}',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 8,
                color: Colors.white38,
              ),
            ),
          ] else
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                '🏆 VOCÊ É O CEO!',
                style: GoogleFonts.silkscreen(
                  fontSize: 14,
                  color: const Color(0xFFEAB308),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// UPGRADE STATS CARD
// ─────────────────────────────────────────────────

class _UpgradeStatsCard extends StatelessWidget {
  final GameService gameService;

  const _UpgradeStatsCard({required this.gameService});

  @override
  Widget build(BuildContext context) {
    final upgradeStats = gameService.state.purchasedUpgrades.entries
        .where((e) => e.value.level > 1)
        .toList();

    if (upgradeStats.isEmpty) {
      return const SizedBox.shrink();
    }

    return _PixelContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('⭐', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                'UPGRADES',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  color: Colors.white70,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...upgradeStats.map((e) {
            final upgrade = e.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _StatRow(
                emoji: upgrade.upgrade.emoji,
                label: upgrade.upgrade.name,
                value: 'Nível ${upgrade.level}',
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// STAT ROW
// ─────────────────────────────────────────────────

class _StatRow extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;

  const _StatRow({
    required this.emoji,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 9,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 9,
            color: const Color(0xFF4ADE80),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────
// PIXEL CONTAINER (reusable)
// ─────────────────────────────────────────────────

class _PixelContainer extends StatelessWidget {
  final Widget child;

  const _PixelContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141418),
        border: Border.all(color: const Color(0xFF2A2A30), width: 2),
        boxShadow: const [
          BoxShadow(color: Color(0xCC000000), offset: Offset(4, 4)),
        ],
      ),
      child: child,
    );
  }
}
