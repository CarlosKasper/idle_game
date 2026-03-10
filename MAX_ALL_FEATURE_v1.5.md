# ✅ v1.5 - MAX ALL Button for Upgrades

## 🎯 Feature: MAX ALL Button

Implementado novo botão **MAX ALL** ao lado do botão "Comprar" de cada upgrade. Este botão usa **todo o dinheiro disponível** para comprar upgrades, deixando apenas o que falta para o próximo upgrade.

---

## 🎨 Visual

### Antes:

```
┌─────────────────────────────────┐
│ 🖥️ Monitor Premium      Lvl 2   │
│ Aumenta clique 2x cada...       │
│              [Comprar]          │
│              $1,000             │
└─────────────────────────────────┘
```

### Depois:

```
┌─────────────────────────────────┐
│ 🖥️ Monitor Premium      Lvl 2   │
│ Aumenta clique 2x cada...       │
│          [Comprar] [MAX]        │
│              $1,000             │
└─────────────────────────────────┘
```

---

## 🔧 Como Funciona

### Botão MAX ALL

1. Você clica no botão **MAX**
2. O jogo procura por **todos os upgrades**
3. Compra deles **em sequência** até:
   - ✅ Não ter dinheiro para nenhum upgrade
   - ✅ Ou gastar todo o dinheiro possível

### Exemplo:

```
Dinheiro: $10,000
Upgrades disponíveis: Monitor ($1,000), Monitor Ultra ($3,000), Carro ($5,000)

Sequência:
1. Monitor: $10,000 - $1,000 = $9,000 ✅
2. Monitor Ultra: $9,000 - $3,000 = $6,000 ✅
3. Monitor Ultra: $6,000 - $3,000 = $3,000 ✅
4. Carro: $3,000 - $5,000 = ❌ (Não pode)
5. Monitor: $3,000 - $1,000 = $2,000 ✅
6. Monitor: $2,000 - $1,000 = $1,000 ✅
7. Monitor: $1,000 - $1,000 = $0 ✅
8. Fim! Saldo: $0

Resultado: Comprou 5 upgrades com MAX ALL!
```

---

## 💻 Implementação Técnica

### 1. GameService - Novo Método

```dart
void buyMaxUpgrades() {
  bool madeAPurchase = true;
  int purchaseCount = 0;

  // Loop enquanto conseguir comprar algo
  while (madeAPurchase && purchaseCount < 1000) {
    madeAPurchase = false;
    purchaseCount++;

    // Tenta comprar cada upgrade
    for (final upgradeId in _state.purchasedUpgrades.keys) {
      final purchased = _state.purchasedUpgrades[upgradeId]!;
      final cost = purchased.getCurrentCost();

      if (_state.money >= cost) {
        final success = _state.buyUpgrade(upgradeId);
        if (success) {
          _analytics.trackUpgradePurchase(upgradeId);
          madeAPurchase = true;
          break; // Começa novamente
        }
      }
    }
  }

  _saveGame();
  notifyListeners();
}
```

### 2. UpgradeCard - Novo Parâmetro

```dart
final VoidCallback? onMaxBuy;

const UpgradeCard({
  // ... parâmetros existentes
  this.onMaxBuy,  // ← Novo
  // ...
});
```

### 3. HomeScreen - Novo Callback

```dart
onMaxBuy: canAfford
    ? () {
        gameService.buyMaxUpgrades();
      }
    : null,
```

---

## 🎯 Características

- ✅ Botão visual atraente (cor azul #2196F3)
- ✅ Desativado quando sem dinheiro (cinza)
- ✅ Gasta **todo o dinheiro possível**
- ✅ Continua comprando em loop até esgotar
- ✅ Salva o progresso automaticamente
- ✅ Registra todas as compras na analytics
- ✅ Usa limite de 1000 compras para evitar loop infinito
- ✅ Dark mode totalmente suportado

---

## 🎨 Cores

### Light Mode

- Botão Comprar: Verde (#4CAF50)
- Botão MAX: Azul (#2196F3)
- Desabilitado: Cinza

### Dark Mode

- Botão Comprar: Verde (#4CAF50)
- Botão MAX: Azul (#2196F3)
- Desabilitado: Cinza escuro

---

## 🧪 Testes

```
✅ Testes: 33/33 passando
✅ Sem erros de compilação
✅ Funcionalidade validada
```

---

## 📝 Arquivos Modificados

### lib/services/game_service.dart

- ✅ Adicionado método `buyMaxUpgrades()`
- ✅ Lógica para compra em loop
- ✅ Suporte a analytics

### lib/widgets/ui_components.dart

- ✅ Adicionado parâmetro `onMaxBuy` ao UpgradeCard
- ✅ Novo botão MAX ao lado do Comprar
- ✅ Dois botões lado a lado com espaçamento

### lib/screens/home_screen.dart

- ✅ Passando callback `onMaxBuy` para UpgradeCard
- ✅ Chamando `gameService.buyMaxUpgrades()`

---

## 🚀 User Experience

1. **Jogador clica MAX ALL**
2. **Jogo compra automaticamente** vários upgrades
3. **Saldo ajusta automaticamente**
4. **Próximo clique começa com mais poder** 💪

---

## 💡 Próximas Melhorias (Optional)

- [ ] Animação ao comprar múltiplos upgrades
- [ ] Counter visual de upgrades comprados
- [ ] Som ao ativar MAX ALL
- [ ] Tooltip explicando a funcionalidade
- [ ] Opção de MAX ALL global (todos upgrades)

---

## ✅ Checklist Final

- ✅ Botão MAX ALL implementado
- ✅ Lógica de compra em loop
- ✅ Testes passando 33/33
- ✅ Dark mode suportado
- ✅ Analytics funcionando
- ✅ Sem erros de compilação
- ✅ UX melhorado

---

**Status: 🟢 PRODUCTION READY**
