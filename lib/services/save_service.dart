import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_state.dart';
import '../constants/game_constants.dart';

class SaveService {
  static const String _saveKey = 'idle_game_state';
  late SharedPreferences _prefs;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _isInitialized = true;
  }

  Future<GameState> loadGame() async {
    final jsonString = _prefs.getString(_saveKey);
    if (jsonString == null) {
      final state = GameState();
      state.initializePurchasedUpgrades();
      return state;
    }

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final state = GameState.fromJson(json);
      // Aplicar ganhos off-line (idle) desde o último save
      try {
        final now = DateTime.now();
        final last = state.lastSaveTime;
        final elapsed = now.difference(last);

        // Limita tempo off-line para evitar ganhos infinitos
        final maxSeconds = GameConstants.maxOfflineHours * 3600;
        final seconds = elapsed.inSeconds > maxSeconds
            ? maxSeconds
            : elapsed.inSeconds;

        if (seconds > 0) {
          final offlineDuration = Duration(seconds: seconds);
          // Aplica renda passiva proporcional ao tempo off-line
          state.earnPassiveIncome(offlineDuration);
          // Atualiza lastSaveTime para evitar dupla aplicação
          state.lastSaveTime = now;
          // Persiste imediatamente o estado atualizado
          await saveGame(state);
        }
      } catch (e) {
        print('Erro ao aplicar ganhos off-line: $e');
      }
      return state;
    } catch (e) {
      print('Erro ao carregar jogo: $e');
      final state = GameState();
      state.initializePurchasedUpgrades();
      return state;
    }
  }

  Future<void> saveGame(GameState state) async {
    state.lastSaveTime = DateTime.now();
    final json = state.toJson();
    final jsonString = jsonEncode(json);
    await _prefs.setString(_saveKey, jsonString);
  }

  Future<void> deleteGame() async {
    await _prefs.remove(_saveKey);
  }
}
