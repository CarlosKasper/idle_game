import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/game_service.dart';
import '../models/career.dart';
import '../widgets/ui_components.dart';
import 'stats_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Office Idle'),
        backgroundColor: const Color(0xFF1565C0),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StatsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              _showSettingsDialog(context);
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
                const SizedBox(height: 20),
                _buildCareerHeader(context, gameService),
                const SizedBox(height: 20),
                _buildMoneyDisplay(context, gameService),
                const SizedBox(height: 20),
                _buildWorkButton(context, gameService),
                const SizedBox(height: 20),
                _buildIncomeInfo(context, gameService),
                const SizedBox(height: 20),
                _buildUpgradesSection(context, gameService),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCareerHeader(BuildContext context, GameService gameService) {
    final career = careerLevels[gameService.state.currentCareerLevel];
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              career.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1565C0),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ganho: ${gameService.state.getClickIncome().format()} por clique',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoneyDisplay(BuildContext context, GameService gameService) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: MoneyDisplay(
        amount: gameService.state.money.format(),
        subtitle: 'Saldo',
      ),
    );
  }

  Widget _buildWorkButton(BuildContext context, GameService gameService) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GestureDetector(
        onTap: () {
          gameService.click();
          _showClickAnimation(context);
        },
        child: GradientButton(
          label: '💼 TRABALHAR',
          onPressed: () {
            gameService.click();
            _showClickAnimation(context);
          },
          fontSize: 24,
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 60),
        ),
      ),
    );
  }

  Widget _buildIncomeInfo(BuildContext context, GameService gameService) {
    final clickIncome = gameService.state.getClickIncome();
    final incomePerSecond = gameService.state.getIncomePerSecond();
    final multiplier = (gameService.state.multiplierTotal * 100).toStringAsFixed(0);

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
            _buildInfoRow(
              'Ganho por clique',
              '\$${clickIncome.format()}',
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              'Ganho por segundo',
              '\$${incomePerSecond.format()}',
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              'Multiplicador',
              '$multiplier%',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
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

  Widget _buildUpgradesSection(BuildContext context, GameService gameService) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upgrades',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: gameService.state.purchasedUpgrades.length,
            itemBuilder: (context, index) {
              final upgradeId =
                  gameService.state.purchasedUpgrades.keys.toList()[index];
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
      canAfford: canAfford,
    );
  }

  void _showClickAnimation(BuildContext context) {
    // Animação visual do clique
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.center,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.2).animate(animation),
            child: Opacity(
              opacity: 1 - animation.value,
              child: Text(
                '+\$${context.read<GameService>().state.getClickIncome().format()}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4CAF50),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Configurações'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Total ganho: \$${context.read<GameService>().state.totalMoneyEarned.format()}',
            ),
            const SizedBox(height: 16),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await context.read<GameService>().resetGame();
            },
            child: const Text('Resetar Jogo'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
}
