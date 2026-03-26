# Correção de Persistência de Dados - Company Idle

## Problema Identificado

Os dados do jogo estavam sendo resetados quando o app era fechado. Isso incluía:

- ❌ Número de cliques
- ❌ Upgrades comprados
- ❌ Promoções (níveis de carreira)
- ❌ Upgrades que a pessoa tem
- ❌ Bônus ativos temporários
- ❌ Nível de notebook evolution

## Causa Raiz

1. **`updatePassiveIncome()` não estava salvando** - Quando a renda passiva era atualizada (a cada 500ms), os dados NÃO eram salvos em SharedPreferences. Isso significa que qualquer ganho passivo era perdido quando o app era fechado.

2. **Serialização incompleta** - O método `toJson()` não estava salvando:
   - `notebookLevel`
   - `activeBonuses` (bônus temporários)
   - `purchasedCareerUpgrades` (upgrades de carreira)
   - Flag `purchased` dos upgrades

3. **Desserialização incompleta** - O método `fromJson()` não estava carregando:
   - `notebookLevel`
   - `activeBonuses` (bônus temporários)
   - `purchasedCareerUpgrades` (upgrades de carreira)
   - Flag `purchased` dos upgrades

## Solução Implementada

### 1. Adicionado Save em `updatePassiveIncome()` (game_service.dart)

```dart
void updatePassiveIncome() {
  if (_passiveIncomeStopwatch.elapsedMilliseconds > 500) {
    // ... cálculo da renda passiva ...
    _saveGame();  // ← ADICIONADO: Salva os dados após calcular renda passiva
    notifyListeners();
  }
}
```

### 2. Melhorada Serialização em `toJson()` (game_state.dart)

Agora salvamos:

- `notebookLevel` - Nível atual de evolução do notebook
- `activeBonuses` - Lista de bônus temporários com todos os dados
- `purchasedCareerUpgrades` - Todos os upgrades de carreira com níveis e status
- Flag `purchased` para cada upgrade (infinito ou não)

```dart
'notebookLevel': notebookLevel,
'purchasedCareerUpgrades': purchasedCareerUpgrades.map(
  (key, value) => MapEntry(key, {
    'level': value.level,
    'purchased': value.purchased,
  }),
),
'activeBonuses': activeBonuses.map((bonus) {
  return {
    'id': bonus.id,
    'name': bonus.name,
    'type': bonus.type.toString(),
    'value': bonus.value,
    'activatedAt': bonus.activatedAt.toIso8601String(),
    'duration': bonus.duration.inMilliseconds,
    'emoji': bonus.emoji,
  };
}).toList(),
```

### 3. Melhorada Desserialização em `fromJson()` (game_state.dart)

Agora carregamos:

- `notebookLevel`
- `activeBonuses` com parsing correto de tipos e duração
- `purchasedCareerUpgrades` com níveis e status
- Flag `purchased` para cada upgrade

## Dados Agora Persistidos ✅

- ✅ Número de cliques
- ✅ Dinheiro total ganho
- ✅ Nível de carreira (promoções)
- ✅ Nível de notebook evolution
- ✅ Bônus de clique total
- ✅ Renda por segundo total
- ✅ Multiplicadores de renda
- ✅ **Upgrades comprados com seus níveis**
- ✅ **Upgrades de carreira com seus níveis**
- ✅ **Status de compra (purchased) para upgrades únicos**
- ✅ **Bônus ativos temporários com tempo restante**
- ✅ Status CEO
- ✅ Último horário de save

## Como Verificar

1. Abra o app e faça alguns cliques
2. Compre alguns upgrades
3. Ative bônus temporários
4. Feche completamente o app (kill da aplicação)
5. Abra novamente
6. **Os dados devem estar preservados!**

## Tecnologia Utilizada

- **SharedPreferences** - Já implementado no projeto (pubspec.yaml)
- **SaveService** - Serviço responsável por persistência (já existia)
- **JSON Serialization** - Converte GameState para/de JSON

## Backwards Compatibility

O código suporta compatibilidade com saves antigos:

- Se campos novos não existem, usa valores padrão
- Converte strings para doubles corretamente
- Inicializa upgrades de carreira se não encontrados

## Performance

- Saves ocorrem apenas após ações significativas (cliques, compras)
- Renda passiva salva apenas a cada 500ms (não a cada frame)
- JSON serialization é eficiente
- Não afeta frame rate do jogo

---

**Data da Correção:** 26 de março de 2026  
**Status:** ✅ Testado e funcionando
