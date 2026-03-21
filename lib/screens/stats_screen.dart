import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../services/game_service.dart';
import '../models/career.dart' as career_model;

// ─────────────────────────────────────────────────
// HELPER FUNCTION FOR LOCALIZED CAREER LEVEL NAMES
// ─────────────────────────────────────────────────

String getLocalizedCareerLevelName(
  BuildContext context,
  career_model.CareerLevel career,
) {
  final l10n = AppLocalizations.of(context);

  switch (career.titleKey) {
    case 'careerLevelIntern':
      return l10n.careerLevelIntern;
    case 'careerLevelJunior':
      return l10n.careerLevelJunior;
    case 'careerLevelPleno':
      return l10n.careerLevelPleno;
    case 'careerLevelPlenoPlus':
      return l10n.careerLevelPlenoPlus;
    case 'careerLevelSenior':
      return l10n.careerLevelSenior;
    case 'careerLevelEngineeringLead':
      return l10n.careerLevelEngineeringLead;
    case 'careerLevelArchitect':
      return l10n.careerLevelArchitect;
    case 'careerLevelProjectManager':
      return l10n.careerLevelProjectManager;
    case 'careerLevelDirector':
      return l10n.careerLevelDirector;
    case 'careerLevelExecutive':
      return l10n.careerLevelExecutive;
    case 'careerLevelCEO':
      return l10n.careerLevelCEO;
    default:
      return career.titleKey;
  }
}

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
                AppLocalizations.of(context).statsTitle,
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
                AppLocalizations.of(context).sessionInfo,
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
                AppLocalizations.of(context).sessionDuration,
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
                AppLocalizations.of(context).activity,
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
            label: AppLocalizations.of(context).totalClicks,
            value: totalClicks.toString(),
          ),
          const SizedBox(height: 12),
          _StatRow(
            emoji: '⭐',
            label: AppLocalizations.of(context).purchasedUpgrades,
            value: totalUpgrades.toString(),
          ),
          const SizedBox(height: 12),
          _StatRow(
            emoji: '📈',
            label: AppLocalizations.of(context).bonuses,
            value: totalPromos.toString(),
          ),
          const SizedBox(height: 12),
          _StatRow(
            emoji: '💰',
            label: AppLocalizations.of(context).totalEarnings,
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
      'careerLevelIntern': '📚',
      'careerLevelJunior': '👔',
      'careerLevelPleno': '📊',
      'careerLevelPlenoPlus': '👨‍💼',
      'careerLevelSenior': '🎩',
      'careerLevelCEO': '👑',
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
                AppLocalizations.of(context).careerInfo,
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
            getLocalizedCareerLevelName(context, career).toUpperCase(),
            style: GoogleFonts.silkscreen(
              fontSize: 24,
              color: const Color(0xFF4ADE80),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${AppLocalizations.of(context).incomePerClick}: \$${career.baseIncome.format()}',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 9,
              color: const Color(0xFFEAB308),
              fontWeight: FontWeight.w600,
            ),
          ),
          if (nextCareer != null) ...[
            const SizedBox(height: 16),
            Text(
              '${AppLocalizations.of(context).next} ${getLocalizedCareerLevelName(context, nextCareer).toUpperCase()}',
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
                AppLocalizations.of(context).upgradeStats,
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
