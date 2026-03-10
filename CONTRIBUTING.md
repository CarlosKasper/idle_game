# Contribuindo para Office Idle

Guia de desenvolvimento e contribuição para o projeto Office Idle.

## 🚀 Setup Inicial

### Pré-requisitos

- Flutter 3.11+ instalado
- Dart SDK compatível
- Editor: VS Code, Android Studio ou IntelliJ

### Instalação

```bash
# Clonar projeto
git clone <repo>
cd idle_game

# Instalar dependências
flutter pub get

# Rodar no emulador/device
flutter run
```

## 📁 Estrutura de Pastas

```
lib/
├── main.dart                    # App entry point
├── constants/
│   └── game_constants.dart     # Constantes do jogo (EDITAR AQUI para balancear)
├── models/                      # Classes de dados puras
│   ├── money.dart              # Representação de dinheiro
│   ├── career.dart             # Sistema de carreira
│   ├── upgrade.dart            # Sistema de upgrades
│   └── game_state.dart         # Estado completo do jogo
├── services/                    # Lógica de negócio
│   ├── game_service.dart       # GameService com ChangeNotifier
│   ├── save_service.dart       # Persistência em SharedPreferences
│   └── analytics_service.dart  # Rastreamento de eventos
├── screens/                     # Telas da UI
│   ├── home_screen.dart        # Tela principal
│   └── stats_screen.dart       # Tela de estatísticas
└── widgets/                     # Componentes reutilizáveis
    └── ui_components.dart      # GradientButton, InfoCard, etc

test/
└── game_state_test.dart        # Testes unitários
```

## 🎮 Fluxo de Desenvolvimento

### Adicionando um Novo Upgrade

1. **Definir em `lib/models/upgrade.dart`:**

```dart
Upgrade(
  id: 'novo_upgrade',
  name: 'Nome do Upgrade 🎯',
  description: '+5 dinheiro por clique',
  emoji: '🎯',
  type: UpgradeType.clickBonus,
  baseCost: Money(200),
  value: 5,
  isInfinite: true,
),
```

2. **Testar o ganho em `test/game_state_test.dart`**

3. **Balancear o custo em `lib/constants/game_constants.dart`**

### Modificando a Curva de Progressão

Editar `lib/constants/game_constants.dart`:

```dart
// Aumentar dificuldade das carreiras
static const careerAnalista = 10000.0; // Era 5000

// Aumentar custo dos upgrades
static const upgradeCoffeeCost = 15.0; // Era 10
```

Depois testar mudanças com:

```bash
flutter test
```

### Adicionando Novos Efeitos Visuais

1. Criar componente em `lib/widgets/ui_components.dart`
2. Usar em `lib/screens/home_screen.dart` ou `lib/screens/stats_screen.dart`
3. Testar com `flutter run`

## 🧪 Testes

### Rodar todos os testes

```bash
flutter test
```

### Rodar teste específico

```bash
flutter test test/game_state_test.dart
```

### Adicionar novo teste

1. Abrir `test/game_state_test.dart`
2. Adicionar novo `test()` dentro de um `group()`
3. Seguir padrão: Arrange → Act → Assert

Exemplo:

```dart
test('novo_upgrade_funciona', () {
  // Arrange
  state.money = Money(1000);

  // Act
  state.buyUpgrade('novo_upgrade');

  // Assert
  expect(state.money.amount, 800);
});
```

## 📊 Balanceamento

### Checklist antes de fazer push:

- [ ] Primeiro upgrade custa < 20 cliques?
- [ ] Primeira promoção é possível em < 5 min?
- [ ] Multiplicadores causam aumento visual?
- [ ] Nenhum upgrade domina demais os outros?
- [ ] Testes passam (`flutter test`)?
- [ ] Sem warnings de lint (`flutter analyze`)?

### Ferramentas de Debug

Adicionar ao `GameService` temporariamente:

```dart
// Debug: simular 1 hora de renda passiva
void debugSimulateTime(Duration duration) {
  state.earnPassiveIncome(duration);
  notifyListeners();
}

// Debug: dar dinheiro instantâneo
void debugAddMoney(double amount) {
  state.money = state.money + Money(amount);
  notifyListeners();
}

// Debug: ver estado atual
void debugPrintState() {
  print('''
    Money: ${state.money.format()}
    Total Earned: ${state.totalMoneyEarned.format()}
    Career: ${state.currentCareerLevel}
    Click Income: ${state.getClickIncome().format()}
    Passive Income: ${state.getIncomePerSecond().format()}
  ''');
}
```

## 🔄 Workflow de Feature

### Exemplo: Adicionar Sistema de Offline

1. **Branch**: `git checkout -b feature/offline-system`
2. **Develop**: Criar `lib/services/offline_service.dart`
3. **Integrar**: Adicionar ao `GameService`
4. **Testes**: Criar testes em `test/offline_service_test.dart`
5. **UI**: Adicionar visualização em `home_screen.dart`
6. **Polish**: Testes, análise, documentação
7. **PR**: Descrever mudanças e pedir review

## 🐛 Debugging

### Ativar logs de debug

```dart
// Em game_state.dart, ao comprar upgrade:
void buyUpgrade(String upgradeId) {
  final purchased = purchasedUpgrades[upgradeId];
  final cost = purchased.getCurrentCost();

  print('[DEBUG] Buying upgrade $upgradeId');
  print('[DEBUG] Cost: ${cost.amount}, Have: ${money.amount}');

  // ... resto do código
}
```

### Inspecionar estado do jogo

```dart
// Em qualquer lugar do código:
debugPrintState(); // (se implementado acima)

// Ou usar breakpoints:
// 1. Clicar no número da linha em lib/services/game_service.dart
// 2. Rodar: flutter run -d <device>
// 3. DevTools vai abrir automaticamente
```

## 📱 Build para Release

### Android

```bash
# Gerar APK
flutter build apk --release

# Gerar App Bundle (para Google Play)
flutter build appbundle --release
```

### iOS

```bash
# Gerar app iOS
flutter build ios --release
```

## 📝 Convenções de Código

### Nomes

- Classes: `PascalCase` (Money, GameService)
- Variáveis: `camelCase` (totalMoney, isInitialized)
- Constantes: `SCREAMING_SNAKE_CASE` (MAX_OFFLINE_HOURS)
- Métodos privados: `_prefixoComSubscreve` (\_calculateCost)

### Formatação

```dart
// Classes pequenas em um arquivo
// Usar imports explícitos (não package:idle_game/...)
import '../models/money.dart';

// Comentários importantes:
/// Calcula o custo do upgrade no nível atual
Money getCurrentCost() {
  // Detalhes implementação...
}

// Espaçamento: 2 linhas entre métodos
void method1() { }

void method2() { }
```

### Análise

```bash
# Rodar linter
flutter analyze

# Formatar código
dart format lib/

# Fix automático
dart fix --apply
```

## 🤝 Pull Request

### Template

```markdown
## Descrição

Breve descrição da mudança

## Tipo

- [ ] Feature
- [ ] Bug fix
- [ ] Refactor

## Testes

- [ ] Unitários passam
- [ ] Testei manualmente
- [ ] Sem warnings

## Checklist

- [ ] Código segue convenções
- [ ] Documentação atualizada
- [ ] BALANCING.md revisado (se mudou números)
```

## 📚 Documentação

Arquivos importantes:

- `GAMEPLAY.md` - Descrição do jogo
- `BALANCING.md` - Guia de balanceamento
- `ADVANCED_BALANCING.md` - Fórmulas matemáticas
- `ROADMAP.md` - Plano de desenvolvimento

**Sempre atualizar documentação ao fazer mudanças significativas!**

## 🎯 Próximas Prioridades

1. [ ] Sistema de Offline (v2.0)
2. [ ] Integração com AdMob
3. [ ] Sistema de Metas/Achievements
4. [ ] Sistema de Prestige (v3.0)
5. [ ] Mais upgrades e temas

---

## 📞 Dúvidas?

Criar issue no GitHub com tag `question` ou `help-wanted`.

Bom coding! 🚀
