import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../config/admob_config.dart';

/// Serviço para gerenciar anúncios do Google AdMob
class AdMobService {
  static final AdMobService _instance = AdMobService._internal();

  late BannerAd _bannerAd;
  late InterstitialAd? _interstitialAd;

  // Usar Maps para suportar múltiplos anúncios recompensados
  final Map<String, RewardedAd?> _rewardedAds = {};
  final Map<String, bool> _isRewardedAdLoaded = {};

  bool _isBannerAdLoaded = false;
  bool _isInterstitialAdLoaded = false;

  AdMobService._internal();

  factory AdMobService() {
    return _instance;
  }

  // ═══════════════════════════════════════════════════════════════════
  // INICIALIZAÇÃO
  // ═══════════════════════════════════════════════════════════════════

  /// Inicializa o Google Mobile Ads SDK
  Future<void> init() async {
    await MobileAds.instance.initialize();
  }

  // ═══════════════════════════════════════════════════════════════════
  // BANNER ADS
  // ═══════════════════════════════════════════════════════════════════

  /// Carrega um anúncio em banner
  void loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdMobConfig.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _isBannerAdLoaded = true;
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('Banner Ad falhou ao carregar: $error');
        },
      ),
    );
    _bannerAd.load();
  }

  // ═══════════════════════════════════════════════════════════════════
  // INTERSTITIAL ADS
  // ═══════════════════════════════════════════════════════════════════

  /// Carrega um anúncio intersticial
  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdMobConfig.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialAdLoaded = true;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Interstitial Ad falhou ao carregar: $error');
          _isInterstitialAdLoaded = false;
        },
      ),
    );
  }

  /// Mostra um anúncio intersticial
  void showInterstitialAd() {
    if (_isInterstitialAdLoaded && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          loadInterstitialAd(); // Recarregar para próxima vez
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          loadInterstitialAd();
        },
      );
      _interstitialAd!.show();
      _isInterstitialAdLoaded = false;
    }
  }

  // ═══════════════════════════════════════════════════════════════════
  // REWARDED ADS (Anúncios com Recompensa)
  // ═══════════════════════════════════════════════════════════════════

  /// Carrega um anúncio com recompensa para um ad unit específico
  void loadRewardedAd(String adUnitId) {
    try {
      RewardedAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            _rewardedAds[adUnitId] = ad;
            _isRewardedAdLoaded[adUnitId] = true;
            print('Rewarded Ad carregado: $adUnitId');
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('Rewarded Ad falhou ao carregar: $error');
            _isRewardedAdLoaded[adUnitId] = false;
          },
        ),
      );
    } catch (e) {
      print('Erro ao carregar rewarded ad: $e');
      _isRewardedAdLoaded[adUnitId] = false;
    }
  }

  /// Mostra um anúncio com recompensa para um ad unit específico
  void showRewardedAd(
    String adUnitId,
    Function(RewardItem) onUserEarnedReward,
  ) {
    try {
      final ad = _rewardedAds[adUnitId];
      final isLoaded = _isRewardedAdLoaded[adUnitId] ?? false;

      if (!isLoaded || ad == null) {
        print('Rewarded ad não carregado para $adUnitId, carregando...');
        loadRewardedAd(adUnitId);
        return;
      }

      ad.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (dismissedAd) {
          dismissedAd.dispose();
          _rewardedAds[adUnitId] = null;
          _isRewardedAdLoaded[adUnitId] = false;
          loadRewardedAd(adUnitId); // Pré-carregar próximo
        },
        onAdFailedToShowFullScreenContent: (failedAd, error) {
          failedAd.dispose();
          _rewardedAds[adUnitId] = null;
          _isRewardedAdLoaded[adUnitId] = false;
          print('Falha ao exibir rewarded ad: $error');
          loadRewardedAd(adUnitId);
        },
      );

      ad.show(
        onUserEarnedReward: (ad, reward) {
          onUserEarnedReward(reward);
        },
      );
      _isRewardedAdLoaded[adUnitId] = false;
    } catch (e) {
      print('Erro ao exibir rewarded ad: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════════
  // GETTERS
  // ═══════════════════════════════════════════════════════════════════

  /// Retorna o banner ad
  BannerAd get bannerAd => _bannerAd;

  /// Verifica se banner ad foi carregado
  bool get isBannerAdLoaded => _isBannerAdLoaded;

  /// Verifica se interstitial ad foi carregado
  bool get isInterstitialAdLoaded => _isInterstitialAdLoaded;

  /// Verifica se um rewarded ad específico foi carregado
  bool isRewardedAdLoaded(String adUnitId) =>
      _isRewardedAdLoaded[adUnitId] ?? false;

  // ═══════════════════════════════════════════════════════════════════
  // LIMPEZA
  // ═══════════════════════════════════════════════════════════════════

  /// Libera recursos dos anúncios
  void dispose() {
    _bannerAd.dispose();
    _interstitialAd?.dispose();
    // Limpar todos os rewarded ads
    for (var ad in _rewardedAds.values) {
      ad?.dispose();
    }
    _rewardedAds.clear();
    _isRewardedAdLoaded.clear();
  }
}
