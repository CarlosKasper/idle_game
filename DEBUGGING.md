# Debugging & Troubleshooting - Office Idle

Guia para diagnosticar e corrigir problemas durante desenvolvimento.

## 🐛 Problemas Comuns

### O app não compila

#### Erro: "The operator '*' can't be unconditionally invoked because the receiver can be 'null'"
```dart
// ❌ Errado
Money result = money * 2;

// ✅ Certo
Money result = money! * 2;
```

#### Erro: "Undefined name 'careerLevels'"
```dart
// Solução: Importar
import '../models/career.dart';
```

#### Erro: "Type 'GameState' expected a type argument"
```dart
// ❌ Errado
var state = GameState();

// ✅ Certo
final state = GameState();
// ou
GameState state = GameState();
```

### O app compila mas não funciona

#### Jogo trava ao clicar
```dart
// Possível causa: GameService não está fornecido
// Solução: Verificar main.dart
// Ensure você tem Provider ao redor do MaterialApp

ChangeNotifierProvider(
  create: (_) => GameService()..initialize(),
  child: const HomeScreen(),
)
```

#### "Null check operator used on a null value"
```dart
// Causa: GameService ainda não inicializou
// Solução: Verificar isInitialized

if (!gameService.isInitialized) {
  return const Center(child: CircularProgressIndicator());
}
```

#### Dinheiro não atualiza na tela
```dart
// Causa: Consumer não está monitorando mudanças
// Solução: Garantir que GameService chama notifyListeners()

void click() {
  state.earnMoneyFromClick();
  notifyListeners();  // ← Importante!
}
```

### Números parecem errados

#### Primeira promoção demora muito
```dart
// Causa: Requisito de carreira muito alto
// Solução: Editar em game_constants.dart

static const careerFuncionario = 50.0;  // Reduzir de 100
```

#### Upgrade muito barato/caro
```dart
// Causa: Custo base inadequado
// Solução: Ajustar em upgrade.dart

Upgrade(
  id: 'coffee',
  baseCost: Money(20),  // Aumentar de 10
  // ...
),
```

#### Multiplicadores não funcionam
```dart
// Causa: Multiplicador não é aplicado no getClickIncome()
// Solução: Verificar em game_state.dart

Money getClickIncome() {
  return Money(baseIncomePerClick + clickBonusTotal) * multiplierTotal;
  //                                                    ↑ multiplicador deve estar aqui
}
```

## 🔍 Debugging Avançado

### Ativar Logs de Debug

Em `lib/services/game_service.dart`:

```dart
void click() {
  print('[DEBUG] Before click: ${state.money.amount}');
  state.earnMoneyFromClick();
  print('[DEBUG] After click: ${state.money.amount}');
  _saveGame();
  notifyListeners();
}
```

Em `lib/models/game_state.dart`:

```dart
void buyUpgrade(String upgradeId) {
  final purchased = purchasedUpgrades[upgradeId];
  final cost = purchased.getCurrentCost();
  
  print('[DEBUG] Attempting to buy $upgradeId');
  print('[DEBUG] Cost: ${cost.amount}, Have: ${money.amount}');
  
  if (money < cost) {
    print('[DEBUG] Can\'t afford!');
    return false;
  }
  
  print('[DEBUG] Purchase successful!');
  // ... resto do código
}
```

### Usar DevTools

```bash
# Rodar com DevTools
flutter run -d <device> --devtools

# Depois acessar em browser: http://localhost:9100
```

Em DevTools:
- **Timeline**: Ver performance
- **Memory**: Verificar memory leaks
- **Logging**: Ver todos os prints
- **Inspector**: Ver árvore de widgets

### Inspecionar SharedPreferences

```dart
// Adicionar método debug em GameService
Future<void> debugPrintSaveFile() async {
  final json = state.toJson();
  print('[DEBUG] Save file:');
  print(jsonEncode(json));
}
```

Chamar em algum lugar:
```dart
// Em home_screen.dart onPress de button de debug
onPressed: () async {
  await gameService.debugPrintSaveFile();
},
```

## 🧪 Testing Checklist

Antes de considerar "pronto":

```
[ ] Jogo compila sem erros
[ ] Sem warnings de lint (flutter analyze)
[ ] 23 testes passam (flutter test)
[ ] 60fps estável (sem frame drops)
[ ] Salva sem lag
[ ] Load de save completo
[ ] Valores não ficam infinito/NaN
[ ] UI não tem overflow
[ ] Toca/clica sem delay
[ ] Som funcionaria (se implementar)
```

## 🔧 Ferramentas de Debug

### Verificar Performance

```dart
// Em game_service.dart
Stopwatch _clickStopwatch = Stopwatch();

void click() {
  _clickStopwatch.start();
  state.earnMoneyFromClick();
  _clickStopwatch.stop();
  
  if (_clickStopwatch.elapsedMilliseconds > 10) {
    print('[PERF] Click took ${_clickStopwatch.elapsedMilliseconds}ms - TOO SLOW!');
  }
  _clickStopwatch.reset();
  
  notifyListeners();
}
```

### Verificar Memory

```bash
# Durante flutter run, usar DevTools → Memory
# Procurar por memory leaks
# Clicar muito por 5 minutos
# Memory deve ser estável (não crescer continuamente)
```

### Verificar Saves Corrompidos

```dart
// Adicionar em save_service.dart
Future<GameState> loadGame() async {
  try {
    final jsonString = _prefs.getString(_saveKey);
    if (jsonString == null) return GameState();
    
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return GameState.fromJson(json);
  } catch (e, st) {
    print('[ERROR] Load failed: $e');
    print('[ERROR] Stack trace: $st');
    
    // Recuperar com reset
    await _prefs.remove(_saveKey);
    return GameState();
  }
}
```

## 🎯 Debugging Workflow

### Problema: "O jogo progride muito rápido"

1. **Reproduzir**: Jogar por 5 minutos
2. **Coletar dados**:
   ```bash
   # Ver quanto dinheiro após 5 min
   flutter run
   [clique 5 min]
   [espiar console money valor]
   ```

3. **Investigar**: Qual é a causa?
   - Upgrade muito barato?
   - Carreira sobe muito fácil?
   - Multiplicador muito alto?

4. **Fixar**: Editar constants e testar
5. **Validar**: Testar novamente por 5-10 min

### Problema: "O jogo trava intermitentemente"

1. **Identificar quando**: 
   - Após clique?
   - Após compra?
   - Após 10 min?

2. **Coletar logs**:
   ```bash
   flutter run 2>&1 | tee debug.log
   # Reproduzir problema
   # Ctrl+C para parar
   # Examinar debug.log
   ```

3. **Procurar por padrão**:
   - Erro antes da trava?
   - Qual função é a última?

4. **Fixar**: Adicionar try/catch ou refatorar

### Problema: "Save não funciona"

1. **Testar manually**:
   ```dart
   // Em home_screen.dart, adicionar botão debug
   FloatingActionButton(
     onPressed: () async {
       await gameService._saveService.saveGame(gameService.state);
       print('Manual save done');
     },
     child: Icon(Icons.save),
   )
   ```

2. **Verificar arquivo**:
   ```bash
   # Em Android emulator
   adb shell "sqlite3 /data/data/com.seu_app/shared_prefs/GameState.xml"
   ```

3. **Comparar antes/depois**:
   - Dinheiro igual?
   - Upgrades salvos?
   - Carreira igual?

## 📊 Perfiling

### Verificar FPS

```dart
// Em _HomeScreenState
int _frames = 0;
Stopwatch _fpsWatch = Stopwatch();

@override
void initState() {
  super.initState();
  _fpsWatch.start();
  _measureFPS();
}

void _measureFPS() {
  _frames++;
  if (_fpsWatch.elapsedSeconds >= 1) {
    print('[FPS] ${_frames} frames per second');
    _frames = 0;
    _fpsWatch.reset();
  }
  Future.delayed(Duration(milliseconds: 16), _measureFPS);
}
```

Target: 60 FPS consistente

### Verificar Tamanho APK

```bash
flutter build apk --release
# Resultado em: build/app/outputs/apk/release/app-release.apk
ls -lh build/app/outputs/apk/release/app-release.apk

# Ideal: < 50MB (sem assets grandes)
```

## 🆘 Quando Tudo Falha

### Nuclear Option: Reset Completo

```bash
# Limpar tudo e recomeçar
flutter clean
rm -rf .dart_tool pubspec.lock
flutter pub get
flutter run
```

### Verificar Versão do Flutter

```bash
flutter --version

# Esperado: Flutter 3.11.0+
# Se diferente, fazer upgrade:
flutter upgrade
```

### Procurar no Stack Overflow

1. Copiar erro completo
2. Procurar em [Stack Overflow](https://stackoverflow.com)
3. Tag `flutter` + `dart`

## 📞 Recursos

### Documentação Oficial
- [Flutter Docs](https://flutter.dev/docs)
- [Dart Docs](https://dart.dev/guides)
- [Provider Package](https://pub.dev/packages/provider)

### Community
- [Flutter Discord](https://discord.gg/flutter)
- [Reddit r/Flutter](https://reddit.com/r/Flutter)
- [Stack Overflow tagged Flutter](https://stackoverflow.com/questions/tagged/flutter)

---

**Dica Final**: A melhor forma de debugar é adicionar logs em pontos estratégicos e "ver o que está acontecendo" em tempo real. Não hesite em adicionar prints temporários!
