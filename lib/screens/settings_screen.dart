import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final ThemeMode currentTheme;
  final Function(ThemeMode) onThemeChanged;

  const SettingsScreen({
    super.key,
    required this.currentTheme,
    required this.onThemeChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late ThemeMode _selectedTheme;

  @override
  void initState() {
    super.initState();
    _selectedTheme = widget.currentTheme;
  }

  void _applyTheme(ThemeMode mode) {
    setState(() {
      _selectedTheme = mode;
    });
    widget.onThemeChanged(mode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Configurações'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Seção de Tema
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'APARÊNCIA',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Card de Tema Sistema
          _buildThemeCard(
            context,
            mode: ThemeMode.system,
            title: 'Automático',
            subtitle: 'Segue a configuração do dispositivo',
            icon: Icons.brightness_auto,
            isSelected: _selectedTheme == ThemeMode.system,
          ),
          const SizedBox(height: 12),

          // Card de Tema Claro
          _buildThemeCard(
            context,
            mode: ThemeMode.light,
            title: 'Modo Claro',
            subtitle: 'Tema claro com fundo branco',
            icon: Icons.brightness_7,
            isSelected: _selectedTheme == ThemeMode.light,
          ),
          const SizedBox(height: 12),

          // Card de Tema Escuro
          _buildThemeCard(
            context,
            mode: ThemeMode.dark,
            title: 'Modo Escuro',
            subtitle: 'Tema escuro com fundo preto',
            icon: Icons.brightness_4,
            isSelected: _selectedTheme == ThemeMode.dark,
          ),

          const SizedBox(height: 32),

          // Seção de Jogo
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'JOGO',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Card de Reset
          Card(
            child: ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text('Resetar Jogo'),
              subtitle: const Text(
                'Voltar ao início com todos os dados apagados',
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _showResetConfirmation(context),
            ),
          ),

          const SizedBox(height: 32),

          // Seção de Informações
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'INFORMAÇÕES',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),

          Card(
            child: ListTile(
              title: const Text('Versão'),
              trailing: Text(
                'v1.2',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
          const SizedBox(height: 12),

          Card(
            child: ListTile(
              title: const Text('Desenvolvido com'),
              trailing: const Text('Flutter + Dart'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeCard(
    BuildContext context, {
    required ThemeMode mode,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
  }) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final borderColor = isSelected ? primaryColor : Colors.grey[300];
    final backgroundColor = isSelected
        ? primaryColor.withOpacity(0.1)
        : Theme.of(context).colorScheme.surface;

    return InkWell(
      onTap: () => _applyTheme(mode),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor ?? Colors.grey,
            width: isSelected ? 2 : 1,
          ),
          color: backgroundColor,
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: primaryColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: primaryColor, size: 28),
          ],
        ),
      ),
    );
  }

  void _showResetConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Resetar Jogo?'),
        content: const Text(
          'Tem certeza que deseja resetar o jogo? '
          'Todos os seus dados serão apagados e não podem ser recuperados.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              // Reset será implementado no HomeScreen
              Navigator.pop(context, 'reset');
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Resetar'),
          ),
        ],
      ),
    );
  }
}
