import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/game_service.dart';
import '../models/career.dart';
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
    _tabController = TabController(length: careerLevels.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Upgrades de Carreira'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).colorScheme.primary,
          tabs: careerLevels.map((career) => Tab(text: career.title)).toList(),
        ),
      ),
      body: Consumer<GameService>(
        builder: (context, gameService, child) {
          final currentCareerLevel = gameService.state.currentCareerLevel;

          return TabBarView(
            controller: _tabController,
            children: careerLevels.map((selectedCareer) {
              final isUnlocked = currentCareerLevel >= selectedCareer.id;
              final upgradesForCareer = careerUpgrades
                  .where((u) => u.unlocksAtCareerLevel == selectedCareer.id)
                  .toList();

              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    // Seção de carreira
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isUnlocked
                              ? Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.1)
                              : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isUnlocked
                                ? Theme.of(
                                    context,
                                  ).colorScheme.primary.withOpacity(0.3)
                                : Colors.grey.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            if (!isUnlocked)
                              Column(
                                children: [
                                  const Icon(
                                    Icons.lock,
                                    size: 32,
                                    color: Colors.orange,
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Bloqueado',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Desbloqueie ao atingir ${selectedCareer.title}',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(color: Colors.grey[400]),
                                  ),
                                ],
                              )
                            else
                              Column(
                                children: [
                                  Text(
                                    'Nível Atual',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withOpacity(0.7),
                                        ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    selectedCareer.title,
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Renda por clique: \$${selectedCareer.baseIncome.format()}',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Upgrades
                    if (upgradesForCareer.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          'Nenhum upgrade para esta posição',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[400]),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: upgradesForCareer.length,
                          itemBuilder: (context, index) {
                            final upgrade = upgradesForCareer[index];
                            final purchased = gameService
                                .state
                                .purchasedCareerUpgrades[upgrade.id];
                            final cost = purchased?.getCurrentCost();
                            final canAfford =
                                isUnlocked && gameService.state.money >= cost!;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isUnlocked
                                        ? Theme.of(
                                            context,
                                          ).colorScheme.primary.withOpacity(0.3)
                                        : Colors.grey.withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      upgrade.emoji,
                                      style: const TextStyle(fontSize: 28),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            upgrade.name,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            upgrade.description,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall
                                                ?.copyWith(
                                                  color: Theme.of(
                                                    context,
                                                  ).textTheme.bodySmall?.color,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if (isUnlocked)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '\$${cost?.format()}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: canAfford
                                                  ? Colors.green
                                                  : Colors.grey,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 8,
                                                  ),
                                            ),
                                            onPressed: canAfford
                                                ? () {
                                                    gameService
                                                        .buyCareerUpgrade(
                                                          upgrade.id,
                                                        );
                                                  }
                                                : null,
                                            child: const Text(
                                              'Comprar',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ],
                                      )
                                    else
                                      Opacity(
                                        opacity: 0.5,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: const Text(
                                            'Bloqueado',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 32),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
