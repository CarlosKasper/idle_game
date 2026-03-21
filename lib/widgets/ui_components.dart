import 'package:flutter/material.dart';

/// Componentes reutilizáveis para a UI do jogo

class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final List<Color> colors;
  final bool enabled;
  final double fontSize;
  final EdgeInsets padding;

  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.colors = const [Color(0xFF4CAF50), Color(0xFF388E3C)],
    this.enabled = true,
    this.fontSize = 18,
    this.padding = const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onPressed : null,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: enabled ? colors : [Colors.grey[400]!, Colors.grey[600]!],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colors.first.withOpacity(enabled ? 0.4 : 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: enabled ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final List<InfoRow> rows;
  final Color? borderColor;

  const InfoCard({
    super.key,
    required this.title,
    required this.rows,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: borderColor != null
            ? Border.all(color: borderColor!, width: 2)
            : null,
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
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          const SizedBox(height: 12),
          ...rows.asMap().entries.map((e) {
            final isLast = e.key == rows.length - 1;
            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    e.value.label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark ? Colors.grey[400] : Colors.grey,
                    ),
                  ),
                  Text(
                    e.value.value,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class InfoRow {
  final String label;
  final String value;

  const InfoRow({required this.label, required this.value});
}

class MoneyDisplay extends StatelessWidget {
  final String amount;
  final String subtitle;

  const MoneyDisplay({
    super.key,
    required this.amount,
    this.subtitle = 'Saldo',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [primaryColor, primaryColor.withOpacity(0.7)]
              : [const Color(0xFF1565C0), const Color(0xFF0D47A1)],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(isDark ? 0.2 : 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\$$amount',
            style: const TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class UpgradeCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String description;
  final String? level;
  final String cost;
  final VoidCallback onBuy;
  final VoidCallback? onMaxBuy;
  final bool canAfford;

  const UpgradeCard({
    super.key,
    required this.emoji,
    required this.title,
    required this.description,
    this.level,
    required this.cost,
    required this.onBuy,
    this.onMaxBuy,
    required this.canAfford,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: canAfford
              ? primaryColor
              : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
          width: canAfford ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: onSurfaceColor,
                  ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isDark ? Colors.grey[400] : Colors.grey,
                  ),
                ),
                if (level != null)
                  Text(
                    level!,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Botão Comprar
                  GestureDetector(
                    onTap: canAfford ? onBuy : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: canAfford
                            ? const Color(0xFF4CAF50)
                            : (isDark ? Colors.grey[700] : Colors.grey[300]),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Comprar',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: canAfford
                              ? Colors.white
                              : (isDark ? Colors.grey[400] : Colors.grey[600]),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  // Botão MAX ALL
                  if (onMaxBuy != null)
                    GestureDetector(
                      onTap: canAfford ? onMaxBuy : null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: canAfford
                              ? const Color(0xFF2196F3)
                              : (isDark ? Colors.grey[700] : Colors.grey[300]),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'MAX',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: canAfford
                                    ? Colors.white
                                    : (isDark
                                          ? Colors.grey[400]
                                          : Colors.grey[600]),
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '\$$cost',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: onSurfaceColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Widget de navegação inferior reutilizável
class BottomNavigationMenu extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavigationMenu({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (_) {}, // bloqueia swipe no menu
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey.withOpacity(0.15), width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(
              context: context,
              icon: Icons.home,
              label: 'Início',
              isSelected: selectedIndex == 0,
              onTap: () => onItemTapped(0),
            ),
            _buildNavItem(
              context: context,
              icon: Icons.laptop,
              label: 'Notebook',
              isSelected: selectedIndex == 1,
              onTap: () => onItemTapped(1),
            ),
            _buildNavItem(
              context: context,
              icon: Icons.emoji_events,
              label: 'Carreira',
              isSelected: selectedIndex == 2,
              onTap: () => onItemTapped(2),
            ),
            _buildNavItem(
              context: context,
              icon: Icons.bar_chart,
              label: 'Estatísticas',
              isSelected: selectedIndex == 3,
              onTap: () => onItemTapped(3),
            ),
            _buildNavItem(
              context: context,
              icon: Icons.shopping_bag,
              label: 'Loja',
              isSelected: selectedIndex == 4,
              onTap: () => onItemTapped(4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedOpacity(
          opacity: isSelected ? 1.0 : 0.6,
          duration: const Duration(milliseconds: 200),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? primaryColor.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? primaryColor
                      : (isDark ? Colors.grey[500] : Colors.grey[600]),
                  size: 24,
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected
                        ? primaryColor
                        : (isDark ? Colors.grey[500] : Colors.grey[600]),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
