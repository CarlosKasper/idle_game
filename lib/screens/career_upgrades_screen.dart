import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/game_service.dart';
import '../models/career.dart' as career_model;
import '../models/career_upgrade.dart';

class CareerUpgradesScreen extends StatefulWidget {
  const CareerUpgradesScreen({super.key});

  @override
  State<CareerUpgradesScreen> createState() => _CareerUpgradesScreenState();
}

class _CareerUpgradesScreenState extends State<CareerUpgradesScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Inicializar com 1 aba padrão, será atualizado no build
    _tabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: Consumer<GameService>(
        builder: (context, gameService, child) {
          final currentCareerLevel = gameService.state.currentCareerLevel;

          // Filtrar apenas os cargos desbloqueados
          final unlockedCareers = career_model.careerLevels
              .where((career) => currentCareerLevel >= career.id)
              .toList();

          // Atualizar o TabController se o número de abas mudou
          if (_tabController.length != unlockedCareers.length) {
            _tabController.dispose();
            _tabController = TabController(
              length: unlockedCareers.length,
              vsync: this,
            );
          }

          if (unlockedCareers.isEmpty) {
            return Column(
              children: [
                _ScreenHeader(),
                const Expanded(
                  child: Center(child: Text('Nenhum cargo desbloqueado')),
                ),
              ],
            );
          }

          return Column(
            children: [
              // Header
              _ScreenHeader(),
              // Tabs
              Container(
                color: const Color(0xFF141418),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(unlockedCareers.length, (index) {
                      final career = unlockedCareers[index];
                      final isActive = _tabController.index == index;
                      return GestureDetector(
                        onTap: () {
                          _tabController.animateTo(index);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? const Color(0xFF4ADE80)
                                : Colors.transparent,
                            border: isActive
                                ? null
                                : const Border(
                                    bottom: BorderSide(
                                      color: Color(0xFF2A2A30),
                                      width: 1,
                                    ),
                                  ),
                          ),
                          child: Text(
                            career.title.toUpperCase(),
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 9,
                              color: isActive
                                  ? const Color(0xFF0A0A0F)
                                  : Colors.white38,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              // Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: unlockedCareers.map((selectedCareer) {
                    final upgradesForCareer = careerUpgrades
                        .where(
                          (u) => u.unlocksAtCareerLevel == selectedCareer.id,
                        )
                        .toList();

                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          // Career Info Card
                          _CareerInfoCard(
                            career: selectedCareer,
                            isUnlocked: true,
                          ),
                          const SizedBox(height: 20),
                          // Upgrades Section
                          if (upgradesForCareer.isEmpty)
                            _NoUpgradesCard()
                          else
                            _UpgradesListCard(
                              upgrades: upgradesForCareer,
                              gameService: gameService,
                              isUnlocked: true,
                              currentCareer: selectedCareer,
                            ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
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
        children: [
          const Text('🏆', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Text(
            'CARREIRA',
            style: GoogleFonts.silkscreen(fontSize: 18, color: Colors.white),
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
  final career_model.CareerLevel career;
  final bool isUnlocked;

  const _CareerInfoCard({required this.career, required this.isUnlocked});

  @override
  Widget build(BuildContext context) {
    return _PixelContainer(
      child: Column(
        children: [
          if (!isUnlocked)
            Column(
              children: [
                const Text('🔒', style: TextStyle(fontSize: 40)),
                const SizedBox(height: 12),
                Text(
                  'BLOQUEADO',
                  style: GoogleFonts.silkscreen(
                    fontSize: 18,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Desbloqueie ao atingir ${career.title}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 9,
                    color: Colors.white38,
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                Text(
                  'NÍVEL ATUAL',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 9,
                    color: Colors.white38,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  career.title.toUpperCase(),
                  style: GoogleFonts.silkscreen(
                    fontSize: 28,
                    color: const Color(0xFF4ADE80),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Renda por clique: \$${career.baseIncome.format()}',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 10,
                    color: const Color(0xFFEAB308),
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
// NO UPGRADES CARD
// ─────────────────────────────────────────────────

class _NoUpgradesCard extends StatelessWidget {
  const _NoUpgradesCard();

  @override
  Widget build(BuildContext context) {
    return _PixelContainer(
      child: Column(
        children: [
          const Text(
            '—',
            style: TextStyle(fontSize: 28, color: Colors.white30),
          ),
          const SizedBox(height: 8),
          Text(
            'SEM UPGRADES',
            style: GoogleFonts.silkscreen(fontSize: 14, color: Colors.white38),
          ),
          const SizedBox(height: 4),
          Text(
            'Nenhum upgrade para esta posição',
            textAlign: TextAlign.center,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 8,
              color: Colors.white38,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// UPGRADES LIST CARD
// ─────────────────────────────────────────────────

class _UpgradesListCard extends StatelessWidget {
  final List<CareerUpgrade> upgrades;
  final GameService gameService;
  final bool isUnlocked;
  final career_model.CareerLevel currentCareer; // Novo parâmetro

  const _UpgradesListCard({
    required this.upgrades,
    required this.gameService,
    required this.isUnlocked,
    required this.currentCareer,
  });

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
                  'UPGRADES',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 9,
                    color: Colors.white70,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: upgrades.length,
            itemBuilder: (context, index) {
              final upgrade = upgrades[index];
              final purchased =
                  gameService.state.purchasedCareerUpgrades[upgrade.id];
              final cost = purchased?.getCurrentCost();
              final canAfford = isUnlocked && gameService.state.money >= cost!;

              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: index < upgrades.length - 1
                      ? const Border(
                          bottom: BorderSide(color: Color(0xFF2A2A30)),
                        )
                      : null,
                ),
                child: Row(
                  children: [
                    Text(upgrade.emoji, style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            upgrade.name,
                            style: GoogleFonts.silkscreen(
                              fontSize: 11,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            upgrade.description,
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 8,
                              color: Colors.white38,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (isUnlocked)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (!purchased!.purchased)
                            Text(
                              '\$${cost?.format()}',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 10,
                                color: canAfford
                                    ? const Color(0xFF4ADE80)
                                    : Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          else
                            Text(
                              'COMPRADO',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 8,
                                color: const Color(0xFFEAB308),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: (canAfford && !purchased.purchased)
                                ? () => gameService.buyCareerUpgrade(upgrade.id)
                                : null,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: purchased.purchased
                                    ? const Color(0xFF4ADE80)
                                    : canAfford
                                    ? const Color(0xFF4ADE80)
                                    : const Color(0xFF555555),
                                border: Border.all(
                                  color: purchased.purchased
                                      ? const Color(0xFF4ADE80)
                                      : canAfford
                                      ? const Color(0xFF4ADE80)
                                      : const Color(0xFF555555),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                purchased.purchased ? 'MAX' : 'COMPRAR',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 7,
                                  color: const Color(0xFF0A0A0F),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: Colors.orange, width: 1),
                        ),
                        child: Text(
                          'LOCK',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 7,
                            color: Colors.orange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          // MAX ALL Button - Aparece apenas um cargo acima
          _buildMaxAllButton(),
        ],
      ),
    );
  }

  Widget _buildMaxAllButton() {
    final currentCareerLevel = gameService.state.currentCareerLevel;
    final upgradeCareerlevel = currentCareer.id;

    // MAX ALL aparece para todos os cargos anteriores ao atual
    final shouldShowMaxAll = currentCareerLevel > upgradeCareerlevel;

    if (!shouldShowMaxAll) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFF2A2A30))),
      ),
      child: Center(
        child: GestureDetector(
          onTap: () {
            // Compra todos os upgrades dessa carreira gastando todo o dinheiro
            gameService.buyMaxCareerUpgrades(currentCareer.id);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF4ADE80),
              border: Border.all(color: const Color(0xFF4ADE80), width: 2),
            ),
            child: Text(
              'MAX ALL',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 9,
                color: const Color(0xFF0A0A0F),
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
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
