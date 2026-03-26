import 'package:games_services/games_services.dart';
import 'dart:io' show Platform;

/// Serviço para gerenciar integração com Game Center (iOS)
class GameCenterService {
  static const String _iOSLeaderboardId = 'com.kasperlabs.companyIdle.money';

  static bool _isAuthenticated = false;

  /// Inicializa a autenticação com Game Center
  static Future<void> initialize() async {
    // Apenas iOS suportado
    if (!Platform.isIOS) {
      print('[GameCenterService] Apenas iOS é suportado');
      return;
    }

    try {
      await GamesServices.signIn();
      _isAuthenticated = true;
      print('[GameCenterService] ✅ Autenticação bem-sucedida');
    } catch (e) {
      _isAuthenticated = false;
      print('[GameCenterService] ❌ Erro ao fazer sign-in: $e');
    }
  }

  /// Verifica se o jogador está autenticado
  static bool get isAuthenticated => _isAuthenticated;

  /// Submete a pontuação do jogador para o placar
  static Future<void> submitScore(int score) async {
    if (!Platform.isIOS) {
      print('[GameCenterService] Apenas iOS é suportado');
      return;
    }

    if (!_isAuthenticated) {
      print(
        '[GameCenterService] Jogador não autenticado. Tentando fazer sign-in...',
      );
      await initialize();
    }

    try {
      await GamesServices.submitScore(
        score: Score(iOSLeaderboardID: _iOSLeaderboardId, value: score),
      );
      print('[GameCenterService] ✅ Pontuação submetida: $score');
    } catch (e) {
      print('[GameCenterService] ❌ Erro ao submeter pontuação: $e');
    }
  }

  /// Abre o placar no Game Center (iOS)
  static Future<void> showLeaderboard() async {
    if (!Platform.isIOS) {
      print('[GameCenterService] Apenas iOS é suportado');
      return;
    }

    if (!_isAuthenticated) {
      print(
        '[GameCenterService] ⚠️ Jogador não autenticado. Tentando fazer login...',
      );
      try {
        await initialize();
        if (!_isAuthenticated) {
          print(
            '[GameCenterService] ❌ Falha ao autenticar. Não é possível abrir o placar.',
          );
          return;
        }
      } catch (e) {
        print('[GameCenterService] ❌ Erro durante autenticação: $e');
        return;
      }
    }

    try {
      print('[GameCenterService] 📱 Tentando abrir leaderboard...');
      print(
        '[GameCenterService] 🎮 Game Center Leaderboard ID: $_iOSLeaderboardId',
      );

      await GamesServices.showLeaderboards(iOSLeaderboardID: _iOSLeaderboardId);
      print('[GameCenterService] ✅ Placar aberto com sucesso');
    } catch (e) {
      print('[GameCenterService] ❌ Erro ao abrir placar: $e');
      print('[GameCenterService] 📋 Verifique se:');
      print('[GameCenterService]    - Está em um device iOS real');
      print('[GameCenterService]    - Game Center está ativo no device');
      print(
        '[GameCenterService]    - ID do leaderboard está correto: $_iOSLeaderboardId',
      );
      print(
        '[GameCenterService]    - Leaderboard está configurado no App Store Connect',
      );
      print('[GameCenterService]    - Sua Apple ID tem Game Center ativado');

      // Tenta recuperação: reautentica e tenta novamente
      print(
        '[GameCenterService] 🔄 Tentando reautenticar e abrir novamente...',
      );
      await resignIn();

      if (_isAuthenticated) {
        try {
          await GamesServices.showLeaderboards(
            iOSLeaderboardID: _iOSLeaderboardId,
          );
          print(
            '[GameCenterService] ✅ Placar aberto com sucesso (segunda tentativa)',
          );
        } catch (e2) {
          print('[GameCenterService] ❌ Erro novamente ao abrir placar: $e2');
        }
      }
    }
  }

  /// Tenta fazer sign-in novamente (para reautenticação)
  static Future<void> resignIn() async {
    if (!Platform.isIOS) {
      return;
    }

    try {
      await GamesServices.signIn();
      _isAuthenticated = true;
      print('[GameCenterService] ✅ Reautenticação bem-sucedida');
    } catch (e) {
      _isAuthenticated = false;
      print('[GameCenterService] ❌ Erro ao fazer sign-in novamente: $e');
    }
  }
}
