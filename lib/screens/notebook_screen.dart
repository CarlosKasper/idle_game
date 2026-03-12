import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/game_service.dart';
import '../models/notebook_evolution.dart';

class NotebookScreen extends StatelessWidget {
  const NotebookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Notebook'), elevation: 0),
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

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  // Current Notebook Card
                  _buildCurrentNotebookCard(
                    context,
                    currentEvolution,
                    currentLevel,
                  ),
                  const SizedBox(height: 32),
                  // Current Stats
                  _buildCurrentStats(context, currentEvolution),
                  const SizedBox(height: 32),
                  // Next Evolution or Max Level
                  if (hasNextLevel && nextEvolution != null)
                    _buildNextEvolutionCard(
                      context,
                      nextEvolution,
                      canEvolve,
                      () => gameService.evolveNotebook(),
                    )
                  else
                    _buildMaxLevelCard(context),
                  const SizedBox(height: 32),
                  // Evolution History
                  _buildEvolutionHistory(context),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurrentNotebookCard(
    BuildContext context,
    NotebookEvolution evolution,
    int level,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.deepPurple.withOpacity(0.1),
            Colors.deepPurple.withOpacity(0.05),
          ],
        ),
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.deepPurple.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(isDark ? 0.2 : 0.1),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(evolution.emoji, style: const TextStyle(fontSize: 72)),
          ),
          const SizedBox(height: 20),
          Text(
            evolution.name,
            style: Theme.of(
              context,
            ).textTheme.displaySmall?.copyWith(color: Colors.deepPurple[400]),
          ),
          const SizedBox(height: 8),
          Text(
            'Nível ${level + 1} de ${notebookEvolutions.length}',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (level + 1) / notebookEvolutions.length,
              minHeight: 8,
              backgroundColor: Colors.grey.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.deepPurple[400]!,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStats(BuildContext context, NotebookEvolution evolution) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bônus Atuais',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.orange.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('⚡', style: TextStyle(fontSize: 32)),
                    const SizedBox(height: 8),
                    Text(
                      '+${evolution.clickBonusValue}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[400],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'por clique',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.green.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('💰', style: TextStyle(fontSize: 32)),
                    const SizedBox(height: 8),
                    Text(
                      '+${evolution.incomePerSecondValue.toStringAsFixed(1)}/s',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[400],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'por segundo',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNextEvolutionCard(
    BuildContext context,
    NotebookEvolution nextEvolution,
    bool canEvolve,
    VoidCallback onEvolve,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.amber.withOpacity(0.1),
            Colors.amber.withOpacity(0.05),
          ],
        ),
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Próxima Evolução',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Text(nextEvolution.emoji, style: const TextStyle(fontSize: 40)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nextEvolution.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber[400],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Custo: ${nextEvolution.cost.format()}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: canEvolve
                              ? Colors.green[400]
                              : Colors.red[400],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: canEvolve ? onEvolve : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[500],
                disabledBackgroundColor: Colors.grey[400],
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                canEvolve ? 'Evoluir Agora' : 'Dinheiro Insuficiente',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: canEvolve ? Colors.black : Colors.grey[600],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaxLevelCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.withOpacity(0.1),
            Colors.green.withOpacity(0.05),
          ],
        ),
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withOpacity(0.3), width: 2),
      ),
      child: Column(
        children: [
          const Text('🎉', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text(
            'Nível Máximo Atingido!',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Colors.green[400]),
          ),
          const SizedBox(height: 8),
          Text(
            'Parabéns! Você desbloqueou todas as evoluções do notebook.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEvolutionHistory(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Todas as Evoluções',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.85,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: notebookEvolutions.length,
          itemBuilder: (context, index) {
            final evolution = notebookEvolutions[index];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(evolution.emoji, style: const TextStyle(fontSize: 36)),
                  const SizedBox(height: 8),
                  Text(
                    evolution.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Nível ${index + 1}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    evolution.cost.format(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.amber[400],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
