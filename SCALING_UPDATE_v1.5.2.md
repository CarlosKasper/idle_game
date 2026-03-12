# ✅ v1.5.2 - Scaling Upgrade: Monitor e Curso escalam como Café

## 🎯 Mudança Realizada

Monitor Extra (🖥️) e Curso Online (📚) agora **escalam exponencialmente** como o Café, em vez de poderem ser comprados apenas uma vez.

---

## 📊 Fórmula de Escala

Todos os três upgrades seguem a mesma fórmula:

```
custo = base × 1.15^(nivel-1)
```

### Exemplos:

**Café ☕**

- Nível 1: $10
- Nível 2: $11.50 (10 × 1.15)
- Nível 3: $13.23 (10 × 1.15²)

**Monitor Extra 🖥️** (novo)

- Nível 1: $200
- Nível 2: $230 (200 × 1.15)
- Nível 3: $264.50 (200 × 1.15²)

**Curso Online 📚** (novo)

- Nível 1: $500
- Nível 2: $575 (500 × 1.15)
- Nível 3: $661.25 (500 × 1.15²)

---

## 💻 Mudanças no Código

### 1. `lib/models/upgrade.dart`

```dart
// ANTES
Upgrade(
  id: 'course',
  isInfinite: false, // ❌ Apenas uma vez
)

// DEPOIS
Upgrade(
  id: 'course',
  isInfinite: true, // ✅ Escala infinitamente
)
```

O mesmo aplica-se ao `monitor`.

### 2. `test/game_state_test.dart`

Atualizado teste para validar que ambos escalam:

```dart
test('course and monitor upgrades scale like coffee', () {
  state.money = Money(10000);

  // Compra Curso
  state.buyUpgrade('course');

  // Preço aumenta exponencialmente
  final courseSecondCost = state.purchasedUpgrades['course']!.getCurrentCost();
  expect(courseSecondCost.amount, closeTo(575, 0.1)); // 500 * 1.15

  // Mesmo padrão para Monitor
  state.buyUpgrade('monitor');
  final monitorSecondCost = state.purchasedUpgrades['monitor']!.getCurrentCost();
  expect(monitorSecondCost.amount, closeTo(230, 0.1)); // 200 * 1.15
});
```

---

## ✨ Benefícios

- ✅ **Consistência**: Todos os upgrades infinitos escalam da mesma forma
- ✅ **Progressão**: Monitor e Curso são agora parte da progressão contínua
- ✅ **MAX ALL**: Funciona melhor com mais upgrades escaláveis
- ✅ **Estratégia**: Jogador pode farmar mais com cada compra

---

## 🧪 Testes

```
✅ Testes: 33/33 passando
✅ Sem erros de compilação
✅ Preços calculados corretamente
✅ Scaling funcionando para todos os três
```

---

## 📝 Arquivos Modificados

1. `lib/models/upgrade.dart`
   - Monitor: `isInfinite: false` → `isInfinite: true`
   - Curso: `isInfinite: false` → `isInfinite: true`

2. `test/game_state_test.dart`
   - Removido teste antigo `non-infinite upgrades can only be bought once`
   - Adicionado novo teste `course and monitor upgrades scale like coffee`

---

## 🎮 Como Funciona Agora

```
Ao comprar Monitor Extra:
  1. Primeira compra: $200
  2. Segunda compra: $230
  3. Terceira compra: $264.50
  ... (cresce 15% a cada nível)

Ao comprar Curso Online:
  1. Primeira compra: $500
  2. Segunda compra: $575
  3. Terceira compra: $661.25
  ... (cresce 15% a cada nível)
```

---

**Status: 🟢 PRODUCTION READY**

Feature pronta para usar! Todos os upgrades infinitos agora escalam consistentemente.
