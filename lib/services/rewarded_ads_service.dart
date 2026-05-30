import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Service simples para carregar e exibir Rewarded Ads (AdMob).
///
/// Contrato:
/// - [show] garante que: tenta carregar (se necessário) e exibir.
/// - Só chama [onRewarded] quando o usuário realmente ganha a recompensa.
/// - Faz cache por adUnitId pra reduzir latência.
class RewardedAdsService {
  RewardedAdsService._();

  static final RewardedAdsService instance = RewardedAdsService._();

  final Map<String, RewardedAd> _cache = <String, RewardedAd>{};
  final Map<String, Completer<void>> _loading = <String, Completer<void>>{};

  bool _initialized = false;

  Future<void> ensureInitialized() async {
    if (_initialized) return;
    await MobileAds.instance.initialize();
    _initialized = true;
  }

  Future<void> preload(String adUnitId) async {
    await ensureInitialized();
    if (_cache.containsKey(adUnitId)) return;
    await _load(adUnitId);
  }

  Future<bool> show({
    required String adUnitId,
    required VoidCallback onRewarded,
    VoidCallback? onClosed,
    ValueChanged<String>? onFailed,
  }) async {
    await ensureInitialized();

    try {
      if (!_cache.containsKey(adUnitId)) {
        await _load(adUnitId);
      }

      final ad = _cache.remove(adUnitId);
      if (ad == null) {
        onFailed?.call('RewardedAd não disponível (cache vazio).');
        return false;
      }

      final closedCompleter = Completer<void>();

      ad.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          if (!closedCompleter.isCompleted) closedCompleter.complete();
          onClosed?.call();
          // Precarrega o próximo.
          unawaited(_load(adUnitId));
        },
        onAdFailedToShowFullScreenContent: (ad, err) {
          ad.dispose();
          if (!closedCompleter.isCompleted) closedCompleter.complete();
          onFailed?.call(
            'Falha ao exibir RewardedAd: ${err.code} ${err.message}',
          );
          onClosed?.call();
          unawaited(_load(adUnitId));
        },
      );

      ad.show(
        onUserEarnedReward: (ad, reward) {
          debugPrint(
            '[RewardedAdsService] Reward earned (${reward.type} ${reward.amount}) for unit=$adUnitId',
          );
          onRewarded();
        },
      );

      await closedCompleter.future;
      return true;
    } catch (e) {
      onFailed?.call('Erro ao mostrar RewardedAd: $e');
      return false;
    }
  }

  Future<void> _load(String adUnitId) async {
    if (_cache.containsKey(adUnitId)) return;

    // Evita loads duplicados.
    final existing = _loading[adUnitId];
    if (existing != null) return existing.future;

    final completer = Completer<void>();
    _loading[adUnitId] = completer;

    try {
      await RewardedAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            debugPrint('[RewardedAdsService] RewardedAd loaded unit=$adUnitId');
            _cache[adUnitId] = ad;
            _loading.remove(adUnitId);
            if (!completer.isCompleted) completer.complete();
          },
          onAdFailedToLoad: (err) {
            debugPrint(
              '[RewardedAdsService] RewardedAd failed to load unit=$adUnitId err=${err.code} ${err.message}',
            );
            _loading.remove(adUnitId);
            if (!completer.isCompleted) {
              completer.completeError(err);
            }
          },
        ),
      );
    } catch (e) {
      _loading.remove(adUnitId);
      if (!completer.isCompleted) completer.completeError(e);
    }

    return completer.future;
  }

  @visibleForTesting
  void clearCacheForTests() {
    for (final ad in _cache.values) {
      ad.dispose();
    }
    _cache.clear();
    _loading.clear();
    _initialized = false;
  }
}
