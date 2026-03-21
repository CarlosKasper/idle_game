import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/game_service.dart';
import '../services/purchase_state_service.dart';
import '../models/career.dart';
import 'stats_screen.dart';
import 'shop_screen.dart';
import 'career_upgrades_screen.dart';
import 'notebook_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(ThemeMode)? onThemeChanged;

  const HomeScreen({super.key, this.onThemeChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
    _startUpdateLoop();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _startUpdateLoop() {
    Future.delayed(const Duration(milliseconds: 16), () {
      if (mounted) {
        try {
          context.read<GameService>().updatePassiveIncome();
          _startUpdateLoop();
        } catch (e) {
          // Widget foi deativado, parar a loop
        }
      }
    });
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              children: [
                // Página 0: Home
                _HomeContent(onThemeChanged: widget.onThemeChanged),
                // Página 1: Notebook
                const NotebookScreen(),
                // Página 2: Career
                const CareerUpgradesScreen(),
                // Página 3: Stats
                const StatsScreen(),
                // Página 4: Shop
                const ShopScreen(),
              ],
            ),
          ),
          Consumer<PurchaseStateService>(
            builder: (context, purchaseState, _) {
              return IgnorePointer(
                ignoring: purchaseState.isPurchasing,
                child: Opacity(
                  opacity: purchaseState.isPurchasing ? 0.5 : 1.0,
                  child: _BottomNav(
                    selectedIndex: _selectedIndex,
                    onItemTapped: _onNavItemTapped,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// HOME CONTENT - Conteúdo principal da tela
// ─────────────────────────────────────────────────

class _HomeContent extends StatefulWidget {
  final Function(ThemeMode)? onThemeChanged;

  const _HomeContent({this.onThemeChanged});

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  @override
  void initState() {
    super.initState();
    _startUpdateLoop();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _startUpdateLoop() {
    Future.delayed(const Duration(milliseconds: 16), () {
      if (mounted) {
        try {
          context.read<GameService>().updatePassiveIncome();
          _startUpdateLoop();
        } catch (e) {
          // Widget foi deativado, parar a loop
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameService>(
      builder: (context, gameService, child) {
        if (!gameService.isInitialized) {
          return Scaffold(
            backgroundColor: const Color(0xFF0A0A0F),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFF0A0A0F),
          body: SafeArea(
            child: Column(
              children: [
                // Header
                _GameHeader(gameService: gameService),
                // Status bar
                _StatusBar(
                  totalClicks:
                      gameService.analytics.getSessionStats()['total_clicks']
                          as int? ??
                      0,
                ),
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _ProfileCard(gameService: gameService),
                        const SizedBox(height: 16),
                        _BalanceCard(gameService: gameService),
                        const SizedBox(height: 16),
                        _WorkButton(onWork: () => gameService.click()),
                        const SizedBox(height: 16),
                        _ActiveBonusesPanel(gameService: gameService),
                        const SizedBox(height: 16),
                        _MultipliersPanel(gameService: gameService),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────
// HEADER
// ─────────────────────────────────────────────────

class _GameHeader extends StatelessWidget {
  final GameService gameService;

  const _GameHeader({required this.gameService});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameService>(
      builder: (context, gameService, _) {
        final career = careerLevels[gameService.state.currentCareerLevel];
        final isCEO = gameService.state.isCEO;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isCEO ? const Color(0xFF2A1F14) : const Color(0xFF141418),
            border: Border(
              bottom: BorderSide(
                color: isCEO
                    ? const Color(0xFFD4A574)
                    : const Color(0xFF2A2A30),
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    isCEO ? '👑' : '💼',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Office Idle',
                    style: GoogleFonts.silkscreen(
                      fontSize: 18,
                      color: isCEO ? const Color(0xFFD4A574) : Colors.white,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    career.title.toUpperCase(),
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  Text(
                    'NV ${gameService.state.currentCareerLevel + 1}',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 9,
                      color: Colors.white38,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────
// STATUS BAR
// ─────────────────────────────────────────────────

class _StatusBar extends StatelessWidget {
  final int totalClicks;

  const _StatusBar({required this.totalClicks});

  @override
  Widget build(BuildContext context) {
    final style = GoogleFonts.jetBrainsMono(
      fontSize: 9,
      color: Colors.white30,
      letterSpacing: 2,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF2A2A30), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('LATENCY: 14MS', style: style),
          Text('BUILD: V0.1.0-ALPHA', style: style),
          Text('CLICKS: $totalClicks', style: style),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// PROFILE CARD
// ─────────────────────────────────────────────────

class _ProfileCard extends StatelessWidget {
  final GameService gameService;

  const _ProfileCard({required this.gameService});

  @override
  Widget build(BuildContext context) {
    final career = careerLevels[gameService.state.currentCareerLevel];

    final careerEmojis = {
      'Estagiário': '👨‍🎓',
      'Funcionário': '👔',
      'Analista': '📊',
      'Gerente': '👨‍💼',
      'Diretor': '🎩',
      'CEO': '👑',
    };

    final emoji = careerEmojis[career.title] ?? '💼';

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
                  'PERFIL.EXE',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 9,
                    color: Colors.white38,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E25),
              border: Border.all(color: const Color(0xFF4ADE80), width: 2),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 36)),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            career.title,
            style: GoogleFonts.silkscreen(
              fontSize: 24,
              color: const Color(0xFF4ADE80),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '> Nível ${gameService.state.currentCareerLevel + 1} _',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10,
              color: Colors.white38,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// BALANCE CARD
// ─────────────────────────────────────────────────

class _BalanceCard extends StatefulWidget {
  final GameService gameService;

  const _BalanceCard({required this.gameService});

  @override
  State<_BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<_BalanceCard>
    with SingleTickerProviderStateMixin {
  bool _isAnimating = false;

  @override
  void didUpdateWidget(_BalanceCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.gameService.state.money != widget.gameService.state.money) {
      _playAnimation();
    }
  }

  void _playAnimation() {
    setState(() => _isAnimating = true);
    Future.delayed(const Duration(milliseconds: 250), () {
      if (mounted) setState(() => _isAnimating = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final balance = widget.gameService.state.money.format();

    return _PixelContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '// SALDO_ATUAL',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 9,
              color: Colors.white38,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          AnimatedScale(
            scale: _isAnimating ? 1.15 : 1.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            child: Text(
              '\$$balance',
              style: GoogleFonts.silkscreen(
                fontSize: 36,
                color: const Color(0xFFEAB308),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(height: 2, color: const Color(0xFF2A2A30)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'STATUS: ATIVO',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 9,
                  color: Colors.white30,
                  letterSpacing: 2,
                ),
              ),
              Text(
                '■ ONLINE',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 9,
                  color: const Color(0xFF4ADE80),
                  letterSpacing: 2,
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
// WORK BUTTON
// ─────────────────────────────────────────────────

class _WorkButton extends StatelessWidget {
  final VoidCallback onWork;

  const _WorkButton({required this.onWork});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onWork,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF3B82F6),
          border: Border.all(color: const Color(0xFF3B82F6), width: 2),
          boxShadow: const [
            BoxShadow(color: Color(0xFF1D4ED8), offset: Offset(4, 4)),
          ],
        ),
        child: Column(
          children: [
            const Text('💼', style: TextStyle(fontSize: 36)),
            const SizedBox(height: 12),
            Text(
              'TRABALHAR',
              style: GoogleFonts.silkscreen(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 4),
            Text(
              '[ CLICK PARA GANHAR ]',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 9,
                color: Colors.white54,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// ACTIVE BONUSES PANEL
// ─────────────────────────────────────────────────

class _ActiveBonusesPanel extends StatefulWidget {
  final GameService gameService;

  const _ActiveBonusesPanel({required this.gameService});

  @override
  State<_ActiveBonusesPanel> createState() => _ActiveBonusesPanelState();
}

class _ActiveBonusesPanelState extends State<_ActiveBonusesPanel> {
  @override
  void initState() {
    super.initState();
    _startTimerRefresh();
  }

  void _startTimerRefresh() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {});
        _startTimerRefresh();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bonuses = widget.gameService.state.getActiveBonuses();

    if (bonuses.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF141418),
        border: Border.all(color: const Color(0xFF4ADE80), width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x4400FF00),
            offset: Offset(2, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: const Color(0xFF1E1E25),
            child: Row(
              children: [
                const Text('⚡', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 8),
                Text(
                  'BÔNUS ATIVOS',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 9,
                    color: const Color(0xFF4ADE80),
                    letterSpacing: 2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '${bonuses.length} ativo${bonuses.length > 1 ? 's' : ''}',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 8,
                    color: Colors.white38,
                  ),
                ),
              ],
            ),
          ),
          for (var i = 0; i < bonuses.length; i++)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                border: i < bonuses.length - 1
                    ? const Border(bottom: BorderSide(color: Color(0xFF2A2A30)))
                    : null,
              ),
              child: Row(
                children: [
                  Text(bonuses[i].emoji, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bonuses[i].name,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Valor: +${(bonuses[i].value * 100).toStringAsFixed(0)}%',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 8,
                            color: Colors.white38,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A30),
                      border: Border.all(
                        color: const Color(0xFF4ADE80),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      bonuses[i].remainingTimeFormatted,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 10,
                        color: const Color(0xFF4ADE80),
                        fontWeight: FontWeight.w600,
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
// MULTIPLIERS PANEL
// ─────────────────────────────────────────────────

class _MultipliersPanel extends StatelessWidget {
  final GameService gameService;

  const _MultipliersPanel({required this.gameService});

  @override
  Widget build(BuildContext context) {
    final clickIncome = gameService.state.getClickIncome().format();
    final incomePerSecond = gameService.state.getIncomePerSecond().format();

    final items = [
      {'icon': '📈', 'name': 'Ganho por Click', 'value': '\$$clickIncome'},
      {
        'icon': '⚡',
        'name': 'Multiplicador',
        'value': 'x${gameService.state.multiplierTotal.toStringAsFixed(1)}',
      },
      {'icon': '🔄', 'name': 'Auto-Ganho/s', 'value': '\$$incomePerSecond'},
      {
        'icon': '📊',
        'name': 'Total Ganho',
        'value': '\$${gameService.state.totalMoneyEarned.format()}',
      },
    ];

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
                const Text('📉', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 8),
                Text(
                  'GANHOS E MULTIPLICADORES',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 9,
                    color: Colors.white70,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          for (var i = 0; i < items.length; i++)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: i < items.length - 1
                    ? const Border(bottom: BorderSide(color: Color(0xFF2A2A30)))
                    : null,
              ),
              child: Row(
                children: [
                  Text(items[i]['icon']!, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      items[i]['name']!,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 12,
                        color: Colors.white38,
                      ),
                    ),
                  ),
                  Text(
                    items[i]['value']!,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 12,
                      color: const Color(0xFF4ADE80),
                      fontWeight: FontWeight.w600,
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
// PIXEL CONTAINER (reusable)
// ─────────────────────────────────────────────────

class _PixelContainer extends StatelessWidget {
  final Widget child;

  const _PixelContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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

// ─────────────────────────────────────────────────
// BOTTOM NAVIGATION
// ─────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const _BottomNav({required this.selectedIndex, required this.onItemTapped});

  static const _tabs = [
    {'icon': Icons.home, 'label': 'INÍCIO'},
    {'icon': Icons.computer, 'label': 'NOTEBOOK'},
    {'icon': Icons.emoji_events, 'label': 'CARREIRA'},
    {'icon': Icons.bar_chart, 'label': 'ESTATÍS.'},
    {'icon': Icons.shopping_bag, 'label': 'LOJA'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF141418),
        border: Border(top: BorderSide(color: Color(0xFF2A2A30), width: 2)),
      ),
      child: Row(
        children: List.generate(_tabs.length, (i) {
          final active = i == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onItemTapped(i),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: active ? const Color(0xFF4ADE80) : Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _tabs[i]['icon'] as IconData,
                      size: 20,
                      color: active ? const Color(0xFF0A0A0F) : Colors.white38,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _tabs[i]['label'] as String,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 8,
                        color: active
                            ? const Color(0xFF0A0A0F)
                            : Colors.white38,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
