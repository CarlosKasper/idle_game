/// Serviço de analytics para rastrear eventos do jogo
class AnalyticsService {
  static const String _clicksKey = 'total_clicks';
  static const String _upgradesBoughtKey = 'total_upgrades_bought';
  static const String _promosKey = 'total_promotions';

  final Map<String, dynamic> _sessionData = {};

  /// Inicializa a sessão
  void startSession() {
    _sessionData['session_start'] = DateTime.now();
  }

  /// Registra um clique
  void trackClick() {
    _incrementCounter(_clicksKey);
  }

  /// Registra compra de upgrade
  void trackUpgradePurchase(String upgradeId) {
    _incrementCounter(_upgradesBoughtKey);
    _incrementCounter('upgrade_$upgradeId');
  }

  /// Registra promoção de carreira
  void trackPromotion(int careerLevel) {
    _incrementCounter(_promosKey);
    _incrementCounter('career_level_$careerLevel');
  }

  /// Registra reward ad visto
  void trackRewardAdWatched(String rewardType) {
    _incrementCounter('ad_watched_$rewardType');
  }

  /// Pega duração da sessão atual
  Duration getSessionDuration() {
    final start = _sessionData['session_start'] as DateTime?;
    if (start == null) return Duration.zero;
    return DateTime.now().difference(start);
  }

  /// Incrementa um contador
  void _incrementCounter(String key) {
    _sessionData[key] = (_sessionData[key] as int? ?? 0) + 1;
  }

  /// Pega estatísticas da sessão
  Map<String, dynamic> getSessionStats() {
    return Map.from(_sessionData);
  }

  /// Reseta a sessão
  void resetSession() {
    _sessionData.clear();
    startSession();
  }
}
