import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_state.dart';

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
