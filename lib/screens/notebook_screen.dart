import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../services/game_service.dart';
import '../models/notebook_evolution.dart';

// Helper para obter o nome localizado da evolução
String getLocalizedNotebookName(
  BuildContext context,
  NotebookEvolution evolution,
) {
  final l10n = AppLocalizations.of(context);
  switch (evolution.nameKey) {
    case 'notebookBasicName':
      return l10n.notebookBasicName;
    case 'notebookUpdatedName':
      return l10n.notebookUpdatedName;
    case 'notebookProfessionalName':
      return l10n.notebookProfessionalName;
    case 'workstationName':
      return l10n.workstationName;
    case 'superWorkstationName':
      return l10n.superWorkstationName;
    case 'gamingRigName':
      return l10n.gamingRigName;
    case 'serverRoomName':
      return l10n.serverRoomName;
    case 'dataCenterName':
      return l10n.dataCenterName;
    case 'quantumComputerName':
      return l10n.quantumComputerName;
    case 'superintelligenceName':
      return l10n.superintelligenceName;
    default:
      return evolution.nameKey;
  }
}

// Helper para obter a descrição localizada da evolução
String getLocalizedNotebookDesc(
  BuildContext context,
  NotebookEvolution evolution,
) {
  final l10n = AppLocalizations.of(context);
  switch (evolution.descriptionKey) {
    case 'notebookBasicDesc':
      return l10n.notebookBasicDesc;
    case 'notebookUpdatedDesc':
      return l10n.notebookUpdatedDesc;
    case 'notebookProfessionalDesc':
      return l10n.notebookProfessionalDesc;
    case 'workstationDesc':
      return l10n.workstationDesc;
    case 'superWorkstationDesc':
      return l10n.superWorkstationDesc;
    case 'gamingRigDesc':
      return l10n.gamingRigDesc;
    case 'serverRoomDesc':
      return l10n.serverRoomDesc;
    case 'dataCenterDesc':
      return l10n.dataCenterDesc;
    case 'quantumComputerDesc':
      return l10n.quantumComputerDesc;
    case 'superintelligenceDesc':
      return l10n.superintelligenceDesc;
    default:
      return evolution.descriptionKey;
  }
}

class NotebookScreen extends StatelessWidget {
  const NotebookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: Consumer<GameService>(
        builder: (context, gameService, child) {
          final currentLevel = gameService.state.notebookLevel;
          final currentEvolution = notebookEvolutions[currentLevel];
          final nextLevel = currentLevel + 1;
          final hasNextLevel = nextLevel < notebookEvolutions.length;
          final nextEvolution = hasNextLevel
              ? notebookEvolutions[nextLevel]
              : null;
          final canEvolve =
              hasNextLevel && gameService.state.money >= nextEvolution!.cost;

          return SafeArea(
            child: Column(
              children: [
                // Header
                _ScreenHeader(
                  title: AppLocalizations.of(context).notebookTitle,
                ),
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        // Current Notebook Card
                        _CurrentNotebookCard(
                          evolution: currentEvolution,
                          level: currentLevel,
                        ),
                        const SizedBox(height: 20),
                        // Current Stats
                        _CurrentStatsPanel(evolution: currentEvolution),
                        const SizedBox(height: 20),
                        // Next Evolution or Max Level
                        if (hasNextLevel && nextEvolution != null)
                          _NextEvolutionCard(
                            nextEvolution: nextEvolution,
                            canEvolve: canEvolve,
                            onEvolve: () => gameService.evolveNotebook(),
                          )
                        else
                          _MaxLevelCard(),
                        const SizedBox(height: 20),
                        // Evolution Grid
                        _EvolutionGrid(),
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
  final String title;

  const _ScreenHeader({required this.title});

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
              const Text('💻', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Text(
                title,
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
// CURRENT NOTEBOOK CARD
// ─────────────────────────────────────────────────

class _CurrentNotebookCard extends StatelessWidget {
  final NotebookEvolution evolution;
  final int level;

  const _CurrentNotebookCard({required this.evolution, required this.level});

  @override
  Widget build(BuildContext context) {
    return _PixelContainer(
      child: Column(
        children: [
          // Window title bar
          Container(
            padding: const EdgeInsets.only(bottom: 8),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFF2A2A30), width: 2),
              ),
            ),
            child: Row(
              children: [
                for (var i = 0; i < 3; i++) ...[
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white24, width: 2),
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context).notebookExe,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 9,
                    color: Colors.white38,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          // Notebook emoji
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E25),
              border: Border.all(color: const Color(0xFF4ADE80), width: 2),
            ),
            child: Center(
              child: Text(
                evolution.emoji,
                style: const TextStyle(fontSize: 56),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            getLocalizedNotebookName(context, evolution).toUpperCase(),
            style: GoogleFonts.silkscreen(
              fontSize: 20,
              color: const Color(0xFF4ADE80),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// CURRENT STATS PANEL
// ─────────────────────────────────────────────────

class _CurrentStatsPanel extends StatelessWidget {
  final NotebookEvolution evolution;

  const _CurrentStatsPanel({required this.evolution});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF141418),
        border: Border.all(color: const Color(0xFF2A2A30), width: 2),
        boxShadow: const [
          BoxShadow(color: Color(0xCC000000), offset: Offset(4, 4)),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: const Color(0xFF1E1E25),
            child: Row(
              children: [
                const Text('⚙️', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context).currentBonuses,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 9,
                    color: Colors.white70,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E25),
                      border: Border.all(
                        color: const Color(0xFF2A2A30),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('⚡', style: TextStyle(fontSize: 20)),
                        const SizedBox(height: 6),
                        Text(
                          '+${evolution.clickBonusValue}',
                          style: GoogleFonts.silkscreen(
                            fontSize: 14,
                            color: const Color(0xFFEAB308),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          AppLocalizations.of(context).perClick,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 7,
                            color: Colors.white38,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E25),
                      border: Border.all(
                        color: const Color(0xFF2A2A30),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('💰', style: TextStyle(fontSize: 20)),
                        const SizedBox(height: 6),
                        Text(
                          '+${evolution.incomePerSecondValue.toStringAsFixed(1)}/s',
                          style: GoogleFonts.silkscreen(
                            fontSize: 14,
                            color: const Color(0xFFEAB308),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          AppLocalizations.of(context).perSecond,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 7,
                            color: Colors.white38,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// NEXT EVOLUTION CARD
// ─────────────────────────────────────────────────

class _NextEvolutionCard extends StatelessWidget {
  final NotebookEvolution nextEvolution;
  final bool canEvolve;
  final VoidCallback onEvolve;

  const _NextEvolutionCard({
    required this.nextEvolution,
    required this.canEvolve,
    required this.onEvolve,
  });

  @override
  Widget build(BuildContext context) {
    return _PixelContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context).nextEvolutionLabel,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 9,
              color: Colors.white70,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E25),
              border: Border.all(color: const Color(0xFF2A2A30), width: 1),
            ),
            child: Row(
              children: [
                Text(nextEvolution.emoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getLocalizedNotebookName(
                          context,
                          nextEvolution,
                        ).toUpperCase(),
                        style: GoogleFonts.silkscreen(
                          fontSize: 12,
                          color: const Color(0xFF4ADE80),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${AppLocalizations.of(context).costLabel}: \$${nextEvolution.cost.format()}',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 9,
                          color: canEvolve
                              ? const Color(0xFF4ADE80)
                              : Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: canEvolve ? onEvolve : null,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: canEvolve
                    ? const Color(0xFF4ADE80)
                    : const Color(0xFF555555),
                border: Border.all(
                  color: canEvolve
                      ? const Color(0xFF4ADE80)
                      : const Color(0xFF555555),
                  width: 2,
                ),
                boxShadow: canEvolve
                    ? const [
                        BoxShadow(
                          color: Color(0xFF2D8659),
                          offset: Offset(3, 3),
                        ),
                      ]
                    : [],
              ),
              child: Text(
                canEvolve
                    ? AppLocalizations.of(context).evolveNow
                    : AppLocalizations.of(context).insufficientMoney,
                textAlign: TextAlign.center,
                style: GoogleFonts.silkscreen(
                  fontSize: 11,
                  color: canEvolve
                      ? const Color(0xFF0A0A0F)
                      : const Color(0xFF999999),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// MAX LEVEL CARD
// ─────────────────────────────────────────────────

class _MaxLevelCard extends StatelessWidget {
  const _MaxLevelCard();

  @override
  Widget build(BuildContext context) {
    return _PixelContainer(
      child: Column(
        children: [
          const Text('🎉', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context).maxLevelLabel,
            style: GoogleFonts.silkscreen(
              fontSize: 16,
              color: const Color(0xFF4ADE80),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).allEvolutionsUnlocked,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 9,
              color: Colors.white38,
              letterSpacing: 1,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// EVOLUTION GRID
// ─────────────────────────────────────────────────

class _EvolutionGrid extends StatelessWidget {
  const _EvolutionGrid();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF141418),
        border: Border.all(color: const Color(0xFF2A2A30), width: 2),
        boxShadow: const [
          BoxShadow(color: Color(0xCC000000), offset: Offset(4, 4)),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: const Color(0xFF1E1E25),
            child: Row(
              children: [
                const Text('📋', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context).allEvolutions,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 9,
                    color: Colors.white70,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth = (constraints.maxWidth - 24) / 2;
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(notebookEvolutions.length, (index) {
                    final evolution = notebookEvolutions[index];
                    return SizedBox(
                      width: itemWidth,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E25),
                          border: Border.all(
                            color: const Color(0xFF2A2A30),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              evolution.emoji,
                              style: const TextStyle(fontSize: 28),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              getLocalizedNotebookName(context, evolution),
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 8,
                                color: Colors.white70,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Nv ${index + 1}',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 7,
                                color: Colors.white38,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$${evolution.cost.format()}',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 8,
                                color: const Color(0xFFEAB308),
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
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
