import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/game_service.dart';
import '../widgets/ui_components.dart';
import 'home_screen.dart';
import 'notebook_screen.dart';
import 'career_upgrades_screen.dart';
import 'stats_screen.dart';
import 'settings_screen.dart';

/// Tela raiz que gerencia a navegação entre as telas com menu persistente
class RootScreen extends StatefulWidget {
  final Function(ThemeMode)? onThemeChanged;

  const RootScreen({super.key, this.onThemeChanged});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
    // Inicia update loop para renda passiva
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
        context.read<GameService>().updatePassiveIncome();
        _startUpdateLoop();
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                _HomeScreenContent(onThemeChanged: widget.onThemeChanged),
                // Página 1: Notebook
                const NotebookScreen(),
                // Página 2: Career
                const CareerUpgradesScreen(),
                // Página 3: Stats
                const StatsScreen(),
                // Página 4: Settings
                SettingsScreen(
                  currentTheme: ThemeMode.system,
                  onThemeChanged: widget.onThemeChanged ?? (_) {},
                ),
              ],
            ),
          ),
          BottomNavigationMenu(
            selectedIndex: _selectedIndex,
            onItemTapped: _onNavItemTapped,
          ),
        ],
      ),
    );
  }
}

/// Conteúdo da tela home (sem o Scaffold e sem o menu)
class _HomeScreenContent extends StatefulWidget {
  final Function(ThemeMode)? onThemeChanged;

  const _HomeScreenContent({this.onThemeChanged});

  @override
  State<_HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<_HomeScreenContent> {
  @override
  void initState() {
    super.initState();
    _startUpdateLoop();
  }

  void _startUpdateLoop() {
    Future.delayed(const Duration(milliseconds: 16), () {
      if (mounted) {
        context.read<GameService>().updatePassiveIncome();
        _startUpdateLoop();
      }
    });
  }

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
              child: const Text('💼', style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 12),
            const Text('Office Idle'),
          ],
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Configurações',
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SettingsScreen(
                    currentTheme: ThemeMode.system,
                    onThemeChanged: widget.onThemeChanged ?? (_) {},
                  ),
                ),
              );
              if (result == 'reset' && mounted) {
                await context.read<GameService>().resetGame();
              }
            },
          ),
        ],
      ),
      body: Consumer<GameService>(
        builder: (context, gameService, child) {
          if (!gameService.isInitialized) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                _buildCareerHeader(context, gameService),
                const SizedBox(height: 24),
                _buildMoneyDisplay(context, gameService),
                const SizedBox(height: 24),
                _buildWorkButton(context, gameService),
                const SizedBox(height: 28),
                _buildIncomeInfo(context, gameService),
                const SizedBox(height: 28),
                _buildUpgradesSection(context, gameService),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCareerHeader(BuildContext context, GameService gameService) {
    final career = careerLevels[gameService.state.currentCareerLevel];
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

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
      child: SizedBox(
        width: double.infinity,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                primaryColor.withOpacity(0.1),
                primaryColor.withOpacity(0.05),
              ],
            ),
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: primaryColor.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(isDark ? 0.15 : 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(emoji, style: const TextStyle(fontSize: 56)),
              ),
              const SizedBox(height: 16),
              Text(
                career.title,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Nível ${gameService.state.currentCareerLevel + 1}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoneyDisplay(BuildContext context, GameService gameService) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        width: double.infinity,
        child: MoneyDisplay(
          amount: gameService.state.money.format(),
          subtitle: 'Saldo',
        ),
      ),
    );
  }

  Widget _buildWorkButton(BuildContext context, GameService gameService) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        width: double.infinity,
        child: GestureDetector(
          onTap: () {
            gameService.click();
          },
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.35),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [primaryColor, primaryColor.withOpacity(0.85)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 36,
                  horizontal: 32,
                ),
                child: Column(
                  children: [
                    const Text('💼', style: TextStyle(fontSize: 40)),
                    const SizedBox(height: 8),
                    Text(
                      'TRABALHAR',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIncomeInfo(BuildContext context, GameService gameService) {
    final clickIncome = gameService.state.getClickIncome();
    final incomePerSecond = gameService.state.getIncomePerSecond();
    final multiplier = (gameService.state.multiplierTotal * 100)
        .toStringAsFixed(0);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        width: double.infinity,
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
                    child: const Text('📈', style: TextStyle(fontSize: 20)),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Ganhos e Multiplicadores',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildIncomeRow(
                context,
                '💰',
                'Ganho por clique',
                '\$${clickIncome.format()}',
              ),
              const SizedBox(height: 12),
              _buildIncomeRow(
                context,
                '⏱️',
                'Ganho por segundo',
                '\$${incomePerSecond.format()}',
              ),
              const SizedBox(height: 12),
              _buildIncomeRow(context, '✨', 'Multiplicador', '$multiplier%'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIncomeRow(
    BuildContext context,
    String emoji,
    String label,
    String value,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 12),
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
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildUpgradesSection(BuildContext context, GameService gameService) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primaryColor.withOpacity(0.15),
                    primaryColor.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryColor.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('⭐', style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Upgrades & Melhorias',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ...gameService.getAvailableUpgrades().take(3).map((upgrade) {
              final canAfford = gameService.canBuyUpgrade(upgrade.id);
              final cost = gameService.state.getNextUpgradeCost(upgrade.id);
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: UpgradeCard(
                  upgrade: upgrade,
                  cost: cost,
                  canBuy: canAfford,
                  onBuy: () => gameService.buyUpgrade(upgrade.id),
                  level: gameService.state.purchasedUpgrades[upgrade.id]?.level
                      .toString(),
                ),
              );
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
