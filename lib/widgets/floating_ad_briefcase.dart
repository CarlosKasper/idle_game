import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../l10n/app_localizations.dart';
import '../models/money.dart';
import '../services/game_service.dart';
import '../services/rewarded_ads_service.dart';

/// Recompensas possíveis da maleta (sorteadas por peso).
enum _BriefcaseReward { incomeX2, clicksX3, instantMoney }

/// Maleta dourada que fica sempre flutuando na tela.
///
/// Ciclo: flutuando (sem tempo limite) -> toque abre oferta ->
/// anúncio recompensado -> bônus aplicado -> volta a flutuar.
///
/// Só aparece quando o rewarded ad já está carregado, para o toque nunca
/// levar a uma oferta que falha.
class FloatingAdBriefcase extends StatefulWidget {
  final GameService gameService;
  final String adUnitId;

  const FloatingAdBriefcase({
    super.key,
    required this.gameService,
    required this.adUnitId,
  });

  @override
  State<FloatingAdBriefcase> createState() => _FloatingAdBriefcaseState();
}

class _FloatingAdBriefcaseState extends State<FloatingAdBriefcase>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  static const _gold = Color(0xFFFBBF24);
  static const _goldDark = Color(0xFFB45309);
  static const _retryWhenAdNotReady = Duration(seconds: 10);

  final _random = math.Random();

  late final AnimationController _bob;
  late final AnimationController _drift;

  Timer? _spawnTimer;
  bool _visible = false;
  bool _busy = false; // oferta ou anúncio em andamento
  double _xFactor = 0.7;
  double _yFactor = 0.2;
  _BriefcaseReward _reward = _BriefcaseReward.incomeX2;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _bob = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _drift = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
    _preload();
    _scheduleSpawn(Duration.zero);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _spawnTimer?.cancel();
    _bob.dispose();
    _drift.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_busy) return; // o próprio anúncio pausa o app; não interromper
    if (state == AppLifecycleState.paused) {
      _spawnTimer?.cancel();
      _hide();
    } else if (state == AppLifecycleState.resumed && !_visible) {
      _scheduleSpawn(Duration.zero);
    }
  }

  void _preload() {
    RewardedAdsService.instance.preload(widget.adUnitId).catchError((_) {});
  }

  void _scheduleSpawn(Duration delay) {
    _spawnTimer?.cancel();
    _spawnTimer = Timer(delay, _spawn);
  }

  void _hide() {
    _bob.stop();
    _drift.stop();
    if (mounted && _visible) setState(() => _visible = false);
  }

  void _spawn() {
    if (!mounted || _busy) return;
    if (!RewardedAdsService.instance.isReady(widget.adUnitId)) {
      _preload();
      _scheduleSpawn(_retryWhenAdNotReady);
      return;
    }
    setState(() {
      _visible = true;
      _xFactor = 0.55 + _random.nextDouble() * 0.25;
      _yFactor = 0.15 + _random.nextDouble() * 0.15;
      _reward = _rollReward();
    });
    _bob.repeat(reverse: true);
    _drift.repeat();
  }

  _BriefcaseReward _rollReward() {
    final roll = _random.nextInt(100);
    if (roll < 50) return _BriefcaseReward.incomeX2;
    if (roll < 80) return _BriefcaseReward.clicksX3;
    return _BriefcaseReward.instantMoney;
  }

  /// 30 min de renda passiva, com piso de 200 cliques para o início do jogo.
  Money _instantAmount() {
    final state = widget.gameService.state;
    final fromIncome = state.getIncomePerSecond().amount * 1800;
    final fromClicks = state.getClickIncome().amount * 200;
    return Money(math.max(fromIncome, fromClicks));
  }

  String _rewardName(AppLocalizations l10n) {
    switch (_reward) {
      case _BriefcaseReward.incomeX2:
        return l10n.briefcaseIncomeX2;
      case _BriefcaseReward.clicksX3:
        return l10n.briefcaseClicksX3;
      case _BriefcaseReward.instantMoney:
        return l10n.briefcaseInstantMoney;
    }
  }

  String _rewardValue() {
    switch (_reward) {
      case _BriefcaseReward.incomeX2:
        return '×2 · 5 MIN';
      case _BriefcaseReward.clicksX3:
        return '×3 · 2 MIN';
      case _BriefcaseReward.instantMoney:
        return '\$${_instantAmount().format()}';
    }
  }

  String _rewardEmoji() {
    switch (_reward) {
      case _BriefcaseReward.incomeX2:
        return '📈';
      case _BriefcaseReward.clicksX3:
        return '👆';
      case _BriefcaseReward.instantMoney:
        return '💰';
    }
  }

  void _applyReward(AppLocalizations l10n) {
    final game = widget.gameService;
    switch (_reward) {
      case _BriefcaseReward.incomeX2:
        game.activateIncomeBonus(
          'briefcase_income_x2',
          l10n.briefcaseIncomeX2,
          1.0, // 100% extra = 2x
          const Duration(minutes: 5),
          _rewardEmoji(),
        );
      case _BriefcaseReward.clicksX3:
        game.activateClickBonus(
          'briefcase_clicks_x3',
          l10n.briefcaseClicksX3,
          2.0, // 200% extra = 3x
          const Duration(minutes: 2),
          _rewardEmoji(),
        );
      case _BriefcaseReward.instantMoney:
        game.addInstantMoney(_instantAmount());
    }
  }

  Future<void> _onTap() async {
    if (_busy) return;
    _busy = true;
    _drift.stop();
    _bob.stop();

    final l10n = AppLocalizations.of(context);
    final watch = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      builder: (context) => _OfferDialog(
        emoji: _rewardEmoji(),
        name: _rewardName(l10n),
        value: _rewardValue(),
      ),
    );

    if (!mounted) return;
    if (watch != true) {
      _busy = false;
      _bob.repeat(reverse: true);
      _drift.repeat();
      return;
    }

    _hide();
    final messenger = ScaffoldMessenger.of(context);
    var rewarded = false;
    String? failure;
    await RewardedAdsService.instance.show(
      adUnitId: widget.adUnitId,
      onRewarded: () {
        rewarded = true;
        _applyReward(l10n);
      },
      onFailed: (msg) => failure = msg,
    );

    _busy = false;
    if (!mounted) return;
    if (rewarded) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            '✅ ${_rewardName(l10n)} ${l10n.briefcaseRewardActivated} ${_rewardEmoji()}',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } else if (failure != null) {
      debugPrint('[FloatingAdBriefcase] $failure');
      messenger.showSnackBar(
        SnackBar(
          content: Text('❌ ${l10n.briefcaseAdUnavailable}'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
    // Reaparece assim que o próximo anúncio estiver carregado
    _preload();
    _scheduleSpawn(_retryWhenAdNotReady);
  }

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();
    const size = 64.0;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            AnimatedBuilder(
              animation: Listenable.merge([_bob, _drift]),
              builder: (context, child) {
                final t = Curves.easeInOut.transform(_bob.value);
                // Deriva lateral lenta e contínua
                final drift = math.sin(_drift.value * math.pi * 2) * 24;
                final left = (constraints.maxWidth * _xFactor + drift).clamp(
                  8.0,
                  constraints.maxWidth - size - 8,
                );
                return Positioned(
                  left: left,
                  top: constraints.maxHeight * _yFactor - t * 8,
                  child: Transform.rotate(
                    angle: (t - 0.5) * 0.14,
                    child: child,
                  ),
                );
              },
              child: Semantics(
                button: true,
                label: AppLocalizations.of(context).briefcaseTitle,
                child: GestureDetector(
                  onTap: _onTap,
                  child: SizedBox(
                    width: size,
                    height: size + 14,
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topCenter,
                      children: [
                        Positioned(
                          top: 6,
                          child: Container(
                            width: 52,
                            height: 52,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: _gold,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: const [
                                BoxShadow(
                                  color: _goldDark,
                                  offset: Offset(3, 3),
                                ),
                              ],
                            ),
                            child: const Text(
                              '💼',
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0A0A0F),
                              border: Border.all(color: _gold, width: 2),
                            ),
                            child: Text(
                              AppLocalizations.of(context).briefcaseTag,
                              style: GoogleFonts.silkscreen(
                                fontSize: 8,
                                color: _gold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _OfferDialog extends StatelessWidget {
  final String emoji;
  final String name;
  final String value;

  const _OfferDialog({
    required this.emoji,
    required this.name,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const gold = _FloatingAdBriefcaseState._gold;
    return Dialog(
      backgroundColor: const Color(0xFF141418),
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: gold, width: 3),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 10),
            Text(
              l10n.briefcaseTitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.silkscreen(fontSize: 16, color: gold),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.briefcaseWatchAdToEarn,
              textAlign: TextAlign.center,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 11,
                color: Colors.white54,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              textAlign: TextAlign.center,
              style: GoogleFonts.silkscreen(fontSize: 20, color: Colors.white),
            ),
            Text(
              name,
              textAlign: TextAlign.center,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 11,
                color: Colors.white54,
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => Navigator.pop(context, true),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const BoxDecoration(
                  color: Color(0xFF4ADE80),
                  boxShadow: [
                    BoxShadow(color: Color(0xFF15803D), offset: Offset(3, 3)),
                  ],
                ),
                child: Text(
                  l10n.briefcaseWatch,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.silkscreen(
                    fontSize: 14,
                    color: const Color(0xFF0A0A0F),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => Navigator.pop(context, false),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF2A2A30), width: 2),
                ),
                child: Text(
                  l10n.briefcaseNotNow,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.silkscreen(
                    fontSize: 11,
                    color: Colors.white54,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
