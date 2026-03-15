import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/game_service.dart';

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
      backgroundColor: const Color(0xFF0A0A0F),
      body: Column(
        children: [
          _ScreenHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tema Section
                  _SectionTitle(title: 'APARÊNCIA'),
                  const SizedBox(height: 12),
                  _ThemeCard(
                    mode: ThemeMode.system,
                    title: 'AUTOMÁTICO',
                    subtitle: 'Segue configuração do dispositivo',
                    icon: '⚙️',
                    isSelected: _selectedTheme == ThemeMode.system,
                    onTap: () => _applyTheme(ThemeMode.system),
                  ),
                  const SizedBox(height: 12),
                  _ThemeCard(
                    mode: ThemeMode.light,
                    title: 'CLARO',
                    subtitle: 'Fundo branco e texto escuro',
                    icon: '☀️',
                    isSelected: _selectedTheme == ThemeMode.light,
                    onTap: () => _applyTheme(ThemeMode.light),
                  ),
                  const SizedBox(height: 12),
                  _ThemeCard(
                    mode: ThemeMode.dark,
                    title: 'ESCURO',
                    subtitle: 'Fundo preto e texto claro',
                    icon: '🌙',
                    isSelected: _selectedTheme == ThemeMode.dark,
                    onTap: () => _applyTheme(ThemeMode.dark),
                  ),
                  const SizedBox(height: 32),

                  // Game Section
                  _SectionTitle(title: 'JOGO'),
                  const SizedBox(height: 12),
                  _SettingsButton(
                    icon: '🔄',
                    title: 'RESETAR JOGO',
                    subtitle: 'Apagar todos os dados e começar do zero',
                    isDestructive: true,
                    onTap: () => _showResetConfirmation(context),
                  ),
                  const SizedBox(height: 32),

                  // Info Section
                  _SectionTitle(title: 'INFORMAÇÕES'),
                  const SizedBox(height: 12),
                  _InfoRow(label: 'Versão', value: 'v1.5.2'),
                  const SizedBox(height: 12),
                  _InfoRow(label: 'Desenvolvido com', value: 'Flutter + Dart'),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showResetConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: const Color(0xFF141418),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF141418),
            border: Border.all(color: const Color(0xFF2A2A30), width: 2),
            boxShadow: const [
              BoxShadow(color: Color(0xCC000000), offset: Offset(4, 4)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('⚠️', style: TextStyle(fontSize: 40)),
              const SizedBox(height: 16),
              Text(
                'RESETAR JOGO?',
                style: GoogleFonts.silkscreen(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Todos os dados serão apagados permanentemente.',
                textAlign: TextAlign.center,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 9,
                  color: Colors.white54,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(dialogContext),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF555555),
                          border: Border.all(
                            color: const Color(0xFF555555),
                            width: 2,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xCC000000),
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          'CANCELAR',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 9,
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        Navigator.pop(dialogContext);
                        await context.read<GameService>().resetGame();
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.red[900],
                          border: Border.all(color: Colors.red[900]!, width: 2),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xCC000000),
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          'RESETAR',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 9,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text('⚙️', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Text(
                'CONFIGURAÇÕES',
                style: GoogleFonts.silkscreen(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Text('✕', style: TextStyle(fontSize: 24)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// SECTION TITLE
// ─────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.jetBrainsMono(
        fontSize: 10,
        color: Colors.white54,
        letterSpacing: 2,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// THEME CARD
// ─────────────────────────────────────────────────

class _ThemeCard extends StatelessWidget {
  final ThemeMode mode;
  final String title;
  final String subtitle;
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeCard({
    required this.mode,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF141418),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF4ADE80)
                : const Color(0xFF2A2A30),
            width: 2,
          ),
          boxShadow: const [
            BoxShadow(color: Color(0xCC000000), offset: Offset(4, 4)),
          ],
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.silkscreen(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 8,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Text(
                '✓',
                style: TextStyle(fontSize: 24, color: Color(0xFF4ADE80)),
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// SETTINGS BUTTON
// ─────────────────────────────────────────────────

class _SettingsButton extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final bool isDestructive;
  final VoidCallback onTap;

  const _SettingsButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isDestructive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF141418),
          border: Border.all(
            color: isDestructive ? Colors.red[900]! : const Color(0xFF2A2A30),
            width: 2,
          ),
          boxShadow: const [
            BoxShadow(color: Color(0xCC000000), offset: Offset(4, 4)),
          ],
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.silkscreen(
                      fontSize: 12,
                      color: isDestructive ? Colors.red[300] : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 8,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),
            const Text(
              '→',
              style: TextStyle(fontSize: 20, color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// INFO ROW
// ─────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141418),
        border: Border.all(color: const Color(0xFF2A2A30), width: 2),
        boxShadow: const [
          BoxShadow(color: Color(0xCC000000), offset: Offset(4, 4)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10,
              color: Colors.white70,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10,
              color: const Color(0xFF4ADE80),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
