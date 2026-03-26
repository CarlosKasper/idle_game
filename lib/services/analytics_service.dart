import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Serviço de analytics para rastrear eventos do jogo
class AnalyticsService {
  static const String _clicksKey = 'total_clicks';
  static const String _upgradesBoughtKey = 'total_upgrades_bought';
  static const String _promosKey = 'total_promotions';
  static const String _analyticsKey = 'game_analytics_data';
  static const String _totalPlayTimeKey =
      'total_play_time_ms'; // Tempo total em milissegundos

  final Map<String, dynamic> _sessionData = {};
  late SharedPreferences _prefs;
  DateTime? _sessionStartTime;

  /// Inicializa o serviço de analytics
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadAnalyticsData();
  }

  /// Carrega dados de analytics do SharedPreferences
  Future<void> _loadAnalyticsData() async {
    // Se houver uma sessão anterior ativa, finaliza-a e salva o tempo
    // Isso garante que o tempo não seja perdido em reloads/restarts
    if (_sessionStartTime != null) {
      await _updateTotalPlayTime();
    }

    final jsonString = _prefs.getString(_analyticsKey);
    if (jsonString != null) {
      try {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        // Converte strings de volta para ints
        json.forEach((key, value) {
          if (value is String && key != 'session_start') {
            _sessionData[key] = int.tryParse(value) ?? 0;
          } else if (key == 'session_start') {
            // Ignore session_start ao carregar
          } else {
            _sessionData[key] = value;
          }
        });
      } catch (e) {
        print('Erro ao carregar analytics: $e');
      }
    }

    // Sempre inicia uma nova sessão
    startSession();
  }

  /// Salva dados de analytics no SharedPreferences
  Future<void> _saveAnalyticsData() async {
    // Converte tudo para strings para evitar problemas de serialização
    final dataToSave = <String, dynamic>{};
    _sessionData.forEach((key, value) {
      if (key != 'session_start') {
        dataToSave[key] = value.toString();
      }
    });

    final jsonString = jsonEncode(dataToSave);
    await _prefs.setString(_analyticsKey, jsonString);
  }

  /// Atualiza o tempo total jogado (acumulativo)
  Future<void> _updateTotalPlayTime() async {
    // Calcula tempo jogado na sessão atual
    if (_sessionStartTime != null) {
      final sessionDuration = DateTime.now().difference(_sessionStartTime!);

      // Pega tempo total já acumulado
      final totalPlayTimeMs = _prefs.getInt(_totalPlayTimeKey) ?? 0;

      // Adiciona tempo da sessão atual
      final newTotalPlayTimeMs =
          totalPlayTimeMs + sessionDuration.inMilliseconds;

      // Salva o novo total
      await _prefs.setInt(_totalPlayTimeKey, newTotalPlayTimeMs);
    }
  }

  /// Inicializa a sessão (começa a contar o tempo desta sessão)
  void startSession() {
    _sessionStartTime = DateTime.now();
    _sessionData['session_start'] = _sessionStartTime;
  }

  /// Finaliza a sessão e atualiza tempo total
  Future<void> endSession() async {
    await _updateTotalPlayTime();
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
    if (_sessionStartTime == null) return Duration.zero;
    return DateTime.now().difference(_sessionStartTime!);
  }

  /// Pega tempo total jogado (acumulativo em todas as sessões + sessão atual)
  Duration getTotalPlayTime() {
    final totalPlayTimeMs = _prefs.getInt(_totalPlayTimeKey) ?? 0;
    final currentSessionDuration = getSessionDuration();
    return Duration(
      milliseconds: totalPlayTimeMs + currentSessionDuration.inMilliseconds,
    );
  }

  /// Pega tempo total jogado em horas (formato legível)
  String getTotalPlayTimeFormatted() {
    final totalPlayTime = getTotalPlayTime();
    final hours = totalPlayTime.inHours;
    final minutes = totalPlayTime.inMinutes % 60;
    final seconds = totalPlayTime.inSeconds % 60;

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else if (minutes > 0) {
      return '$minutes:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${seconds}s';
    }
  }

  /// Incrementa um contador
  void _incrementCounter(String key) {
    _sessionData[key] = (_sessionData[key] as int? ?? 0) + 1;
    _saveAnalyticsData(); // Salva após cada incremento
  }

  /// Salva progresso periodicamente (para não perder dados em crashes/restarts)
  /// Deve ser chamado periodicamente durante o gameplay
  Future<void> saveProgressPeriodically() async {
    // Atualiza o tempo total jogado com a sessão atual acumulada
    await _updateTotalPlayTime();
    // Reinicia a sessão para não contar duas vezes
    startSession();
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

  /// Reseta todos os dados de analytics
  Future<void> resetAnalyticsData() async {
    _sessionData.clear();
    startSession();
    await _prefs.remove(_analyticsKey);
    await _prefs.remove(_totalPlayTimeKey);
  }
}
