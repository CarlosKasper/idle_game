/// Configuração do Google AdMob para Office Idle
///
/// IDs do AdMob fornecidos pelo usuário

class AdMobConfig {
  // ═══════════════════════════════════════════════════════════════════
  // MODO DE TESTE (Mude para false em produção)
  // ═══════════════════════════════════════════════════════════════════

  /// Se true, usa IDs de teste do Google. Se false, usa IDs de produção.
  static const bool useTestAds = true;

  // ═══════════════════════════════════════════════════════════════════
  // APP IDs
  // ═══════════════════════════════════════════════════════════════════

  /// ID da App no Google AdMob - iOS
  static const String appIdIos = 'ca-app-pub-2763680410215400~4902419688';

  /// ID da App no Google AdMob - Android (será configurado depois)
  static const String appIdAndroid = 'ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy';

  // ═══════════════════════════════════════════════════════════════════
  // REWARDED ADS (Anúncios com Recompensa)
  // ═══════════════════════════════════════════════════════════════════

  // IDs de Produção
  static const String _prodRewardedAdUnitId1 =
      'ca-app-pub-2763680410215400/6376482564';
  static const String _prodRewardedAdUnitId2 =
      'ca-app-pub-2763680410215400/3475954652';
  static const String _prodRewardedAdUnitId3 =
      'ca-app-pub-2763680410215400/9476089517';

  // IDs de Teste do Google (funcionam em desenvolvimento)
  static const String _testRewardedAdUnitId =
      'ca-app-pub-3940256099942544/5224354917';

  /// Multiplicador 2x (Anúncio) - +100% renda por 30 min
  static String get rewardedAdUnitId1 =>
      useTestAds ? _testRewardedAdUnitId : _prodRewardedAdUnitId1;

  /// Cliques 2x (Anúncio) - +100% cliques por 20 min
  static String get rewardedAdUnitId2 =>
      useTestAds ? _testRewardedAdUnitId : _prodRewardedAdUnitId2;

  /// Bônus de Dinheiro (Anúncio) - Ganhe $500
  static String get rewardedAdUnitId3 =>
      useTestAds ? _testRewardedAdUnitId : _prodRewardedAdUnitId3;

  // ═══════════════════════════════════════════════════════════════════
  // BANNER ADS (Opcional - para futuros banners)
  // ═══════════════════════════════════════════════════════════════════

  /// ID para Banner Ads (será configurado depois)
  static const String bannerAdUnitId = 'ca-app-pub-2763680410215400/xxxxxxxxxx';

  // ═══════════════════════════════════════════════════════════════════
  // INTERSTITIAL ADS (Opcional - para futuros anúncios intersticiais)
  // ═══════════════════════════════════════════════════════════════════

  /// ID para Interstitial Ads (será configurado depois)
  static const String interstitialAdUnitId =
      'ca-app-pub-2763680410215400/xxxxxxxxxx';
}
