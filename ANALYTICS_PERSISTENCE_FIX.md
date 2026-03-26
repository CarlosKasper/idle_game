# Correção de Persistência de Analytics - Company Idle

## Problema Identificado

⚠️ **Total de cliques e upgrades comprados zerados** ao fechar o app

Na tela de estatísticas:

- ❌ Total de cliques = 0
- ❌ Upgrades comprados = 0
- ❌ Promoções = 0

## Causa Raiz

O `AnalyticsService` estava **armazenando dados apenas em memória** (`_sessionData`). Quando o app era fechado, todos esses dados eram perdidos!

### Dados que estavam sendo perdidos:

- `total_clicks` - Total de cliques realizados
- `total_upgrades_bought` - Total de upgrades comprados
- `total_promotions` - Total de promoções de carreira
- Estatísticas individuais de cada upgrade e nível de carreira

## Solução Implementada

### 1. Adicionado Persistência com SharedPreferences

O `AnalyticsService` agora:

- ✅ Carrega dados de `SharedPreferences` ao inicializar
- ✅ Salva dados em `SharedPreferences` após cada incremento
- ✅ Converte dados para string para evitar problemas de serialização JSON

### 2. Novo Método `initialize()`

```dart
Future<void> initialize() async {
  _prefs = await SharedPreferences.getInstance();
  await _loadAnalyticsData();
}
```

Carrega todos os dados salvos e faz a inicialização necessária.

### 3. Novos Métodos de Persistência

```dart
Future<void> _loadAnalyticsData() async {
  // Carrega dados de SharedPreferences
}

Future<void> _saveAnalyticsData() async {
  // Salva dados em SharedPreferences após cada ação
}

Future<void> resetAnalyticsData() async {
  // Reseta todos os analytics (ao resetar o jogo)
}
```

### 4. Atualizado `GameService`

Agora o `GameService.initialize()` chama:

```dart
Future<void> initialize() async {
  await _saveService.initialize();
  await _analytics.initialize();  // ← Inicializa analytics
  _state = await _saveService.loadGame();
  // ...
}
```

E o `resetGame()` também reseta os analytics:

```dart
Future<void> resetGame() async {
  await _saveService.deleteGame();
  await _analytics.resetAnalyticsData();  // ← Reseta analytics
  // ...
}
```

## Fluxo de Dados

### Ao abrir o app:

1. `GameService.initialize()` é chamado
2. `_analytics.initialize()` carrega dados do SharedPreferences
3. Estatísticas aparecem com valores corretos

### Ao jogar:

1. Cada clique chama `analytics.trackClick()`
2. `_incrementCounter()` salva dados imediatamente em SharedPreferences
3. Dados persistem mesmo que o app feche

### Ao resetar:

1. `GameService.resetGame()` é chamado
2. `_analytics.resetAnalyticsData()` limpa dados de analytics
3. Estatísticas voltam a zero

## Dados Agora Persistidos ✅

- ✅ Total de cliques (total_clicks)
- ✅ Total de upgrades comprados (total_upgrades_bought)
- ✅ Total de promoções (total_promotions)
- ✅ Cliques por upgrade individual (upgrade\_$id)
- ✅ Níveis de carreira alcançados (career*level*$level)
- ✅ Ads assistidos (ad*watched*$rewardType)

## Como Verificar

1. Abra o app
2. Faça vários cliques
3. Compre alguns upgrades
4. Vá para a tela de estatísticas
5. Anote os valores de "Total de cliques" e "Upgrades comprados"
6. **Feche completamente o app**
7. Abra novamente
8. **Os valores devem estar iguais!** ✅

## Performance

- Salva apenas após cada ação significativa
- JSON é compacto (apenas inteiros)
- Não impacta frame rate
- Savings são assincronos

## Backwards Compatibility

- Se não houver dados salvos, começa do zero
- Suporta múltiplas chaves de estatísticas
- Respeita dados existentes ao carregar

---

**Data da Correção:** 26 de março de 2026  
**Status:** ✅ Implementado e testado
