import 'package:games_services/games_services.dart';

/// Serviço para gerenciar integração com Game Center (iOS) e Google Play Games (Android)
class GameCenterService {
  static const String _androidLeaderboardId = 'CgkI6LT5luoVEAIQAA';
  static const String _iOSLeaderboardId = 'com.kasperlabs.companyIdle.money';

  /// Inicializa a autenticação com Game Center/Google Play Games
  static Future<void> initialize() async {
    try {
      await GamesServices.signIn();
    } catch (e) {
      print('[GameCenterService] Erro ao fazer sign-in: $e');
    }
  }

  /// Submete a pontuação do jogador para o placar
  static Future<void> submitScore(int score) async {
    try {
      await GamesServices.submitScore(
        score: Score(
          androidLeaderboardID: _androidLeaderboardId,
          iOSLeaderboardID: _iOSLeaderboardId,
          value: score,
        ),
      );
      print('[GameCenterService] Pontuação submetida: $score');
    } catch (e) {
      print('[GameCenterService] Erro ao submeter pontuação: $e');
    }
  }

  /// Abre o placar no Game Center (iOS) ou Google Play Games (Android)
  static Future<void> showLeaderboard() async {
    try {
      await GamesServices.showLeaderboards(iOSLeaderboardID: _iOSLeaderboardId);
      print('[GameCenterService] Placar aberto');
    } catch (e) {
      print('[GameCenterService] Erro ao abrir placar: $e');
    }
  }
}
