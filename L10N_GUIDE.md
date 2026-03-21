# 🌐 Guia de Tradução - Office Idle

## 📋 Padrão de Uso

Em qualquer widget, use:

```dart
import '../l10n/app_localizations.dart';

// No build method:
final loc = AppLocalizations.of(context)!;

// Usar a variável:
Text(loc.workButtonLabel)  // "WORK" em EN ou "TRABALHAR" em PT
```

## 🎯 Principais Strings a Traduzir

### Home Screen (`lib/screens/home_screen.dart`)

```dart
// Atuais textos hardcoded:
'NV ${gameService.state.currentCareerLevel + 1}' → Use careerLevel + nível
'LATENCY: 14MS' → system.latency (nova variável)
'BUILD: V0.1.0-ALPHA' → system.build (nova variável)  
'CLICKS: $totalClicks' → use totalClicks
'PERFIL.EXE' → profile.exe (nova variável)
'Ganho por Click' → incomePerClick (já existe)
'Multiplicador' → multiplier (nova variável)
'Auto-Ganho/s' → passiveIncomePerSecond (nova variável)
'Total Ganho' → totalEarnings (já existe)
```

### Shop Screen (`lib/screens/shop_screen.dart`)

```dart
'Buffs & Recompensas' → buffsAndRewards (já existe)
'Processando compra...' → processing (já existe)
'✅ ${product.name} ativado!' → Usar success + activated
```

### Career Screen (`lib/screens/career_upgrades_screen.dart`)

```dart
'Nenhum cargo desbloqueado' → noUnlockedCareers (nova)
'SEM UPGRADES' → noUpgrades (já existe)
'Nenhum upgrade para esta posição' → noUpgradesDescription (já existe)
'⚙️ UPGRADES' → upgrades (já existe)
'COMPRADO' → purchased (já existe)
'MAX ALL' → maxAll (já existe)
```

### Stats Screen (`lib/screens/stats_screen.dart`)

```dart
'ESTATÍSTICAS' → statsTitle (já existe)
'Informações da Sessão' → sessionInfo (já existe)
'Duração da Sessão' → sessionDuration (já existe)
'Total de Cliques' → totalClicks (já existe)
'Total de Ganhos' → totalEarnings (já existe)
```

### Settings Screen (`lib/screens/settings_screen.dart`)

```dart
'CONFIGURAÇÕES' → settingsTitle (já existe)
'APARÊNCIA' → appearance (já existe)
'AUTOMÁTICO' → system.automatic (nova)
'Segue configuração do dispositivo' → system.followDevice (nova)
'CLARO' → lightMode (já existe)
'Fundo branco e texto escuro' → (nova descrição)
'ESCURO' → darkMode (já existe)
'Fundo preto e texto claro' → (nova descrição)
'JOGO' → game.section (nova)
'RESETAR JOGO' → resetGame (já existe)
'Apagar todos os dados e começar do zero' → resetGameDescription (nova)
'INFORMAÇÕES' → about (já existe)
'Versão' → version (já existe)
'Desenvolvido com' → developedWith (já existe)
```

## ✅ Nova Strings a Adicionar

Adicione estas em `app_localizations.dart`, `app_localizations_en.dart` e `app_localizations_pt.dart`:

```dart
// System labels
String get systemLatency;     // "Latency"
String get systemBuild;       // "Build"
String get system Automatic;  // "Automatic"
String get systemFollowDevice; // "Follow device setting"

// Game labels
String get gameSection;       // "Game"
String get multiplier;        // "Multiplier"
String get passiveIncomePerSecond; // "Auto-income/s" ou "Ganho automático/s"
String get profileExe;        // "Profile.exe"
String get noUnlockedCareers; // "No unlocked careers"
String get resetGameDescription; // "Delete all data and start over"
String get lighModeDescription;  // "Light background and dark text"
String get darkModeDescription;  // "Dark background and light text"
```

## 🚀 Processo de Refatoração

1. **Adicione novos getters em `app_localizations.dart`**
2. **Implemente em `app_localizations_en.dart`** 
3. **Implemente em `app_localizations_pt.dart`**
4. **Atualize cada screen:**
   - Adicione import: `import '../l10n/app_localizations.dart';`
   - Na função build: `final loc = AppLocalizations.of(context)!;`
   - Substitua strings: `Text('OLD')` → `Text(loc.newVariable)`

## 📝 Exemplo Prático

### Antes:
```dart
Text('TRABALHAR', style: TextStyle(fontSize: 18))
```

### Depois:
```dart
final loc = AppLocalizations.of(context)!;
Text(loc.workButtonLabel, style: TextStyle(fontSize: 18))
```

## 💡 Dica

- Strings que são dinâmicas (com variáveis) continuam inline: `'NV ${level + 1}'`
- Strings estáticas viram variáveis localizadas: `'NV'` → `loc.level`
- Emojis permanecem hardcoded, apenas textos são traduzidos

## ✨ Prioridade

1. **Crítica**: Titles e botões principais (Home, Shop, Stats, Settings)
2. **Alta**: Descrições e labels de cards
3. **Normal**: Valores dinâmicos, status messages

---

**Próximo Passo**: Escolha uma tela e comece a refatorar!
