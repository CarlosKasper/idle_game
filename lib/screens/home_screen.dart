import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/game_service.dart';
import '../models/career.dart';
import '../widgets/ui_components.dart';
import 'stats_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(ThemeMode)? onThemeChanged;

  const HomeScreen({super.key, this.onThemeChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Inicia update loop para renda passiva
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
            icon: const Icon(Icons.bar_chart),
            tooltip: 'Estatísticas',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StatsScreen()),
              );
            },
          ),
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
              // Se voltou com 'reset', reseta o jogo
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

    // Map emojis based on career title
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
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '💰 Ganho: ${gameService.state.getClickIncome().format()} por clique',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
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
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: GradientButton(
              label: '💼 TRABALHAR',
              onPressed: () {
                gameService.click();
              },
              fontSize: 28,
              padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 80),
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
                    style: TextStyle(
                      fontSize: 14,
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
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey[400] : Colors.grey[700],
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
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
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: gameService.state.purchasedUpgrades.length,
              itemBuilder: (context, index) {
                final upgradeId = gameService.state.purchasedUpgrades.keys
                    .toList()[index];
                final purchased =
                    gameService.state.purchasedUpgrades[upgradeId]!;
                final cost = purchased.getCurrentCost();
                final canAfford = gameService.state.money >= cost;

                return _buildUpgradeCard(
                  context,
                  gameService,
                  purchased,
                  cost,
                  canAfford,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpgradeCard(
    BuildContext context,
    GameService gameService,
    dynamic purchased,
    dynamic cost,
    bool canAfford,
  ) {
    final upgrade = purchased.upgrade;
    final level = purchased.level;

    return UpgradeCard(
      emoji: upgrade.emoji,
      title: upgrade.name,
      description: upgrade.description,
      level: upgrade.isInfinite ? 'Nível $level' : null,
      cost: cost.format(),
      onBuy: canAfford
          ? () {
              gameService.buyUpgrade(upgrade.id);
            }
          : () {},
      onMaxBuy: canAfford
          ? () {
              gameService.buyMaxUpgrades();
            }
          : null,
      canAfford: canAfford,
    );
  }
}
