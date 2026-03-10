# Guia de Balanceamento - Office Idle

## 📊 Princípios de Design

Um idle game bem balanceado deve:

1. **Criar sensação de progresso constante**
   - Números crescem visualmente
   - Novos upgrades sempre disponíveis
   - Promoções marcam milestones

2. **Ser viciante mas não exaustivo**
   - Passivo deve ser significativo
   - Cliques ativos devem ser opcionais depois
   - Reward ads dobram o prazer, não são necessários

3. **Suportar semanas de jogo**
   - Exponential growth previne "teto"
   - Prestige reinicia com bônus (próx. versão)
   - Sempre há algo para fazer

## 🎯 Métricas Atuais

### Progressão de Dinheiro (com 0 upgrades)

```
Tempo    | Cliques | Dinheiro | Cargo
---------|---------|----------|----------
1 seg    | 3       | $3       | Estagiário
10 seg   | 30      | $30      | Estagiário
1 min    | 180     | $180     | Estagiário
5 min    | 900     | $900     | Funcionário
10 min   | 1,800   | $1,800   | Funcionário
30 min   | 5,400   | $5,400   | Analista (aprox)
```

### Custo dos Upgrades

```
Upgrade  | Custo Base | Nível 2 | Nível 3 | Nível 5
---------|-----------|---------|---------|--------
Café     | $10       | $11.50  | $13.22  | $17.49
Notebook | $100      | $115    | $132.25 | $174.90
Cadeira  | $50       | $57.50  | $66.12  | $87.45
```

**Custo cresce 15% por nível** - Previne que um único upgrade domine tudo.

## 💡 Estratégia de Rebalanceamento

### Problema: O jogo fica chato (muito fácil ou muito difícil)

**Sinal**: Jogador não compra nada por 5 minutos
**Solução**: 
- Reduzir custo base em 20%
- Ou aumentar ganho em 30%

**Sinal**: Jogador preso num cargo por >15 minutos
**Solução**:
- Reduzir requerimento de carreira
- Ou aumentar ganho base da carreira anterior

### Problema: Números explodem muito rápido

**Sinal**: $1B atingido em <1 hora
**Solução**:
- Aumentar custos de upgrade em 10%
- Reduzir valor de multiplicadores em 5%

### Problema: Prestige ou eventos offline não compensam

**Sinal**: Jogador prefere continuar ao invés de prestigiar
**Solução**:
- Aumentar bônus permanente de prestige
- Ou reduzir custo de compras na próxima run

## 📈 Fórmulas de Balanceamento

### 1. Tempo para próximo upgrade

Idealmente deve ser 20-60 segundos:

```
tempo_upgrade = custo_upgrade / ganho_atual
```

Se < 20s: Upgrade muito barato
Se > 60s: Upgrade muito caro

### 2. Pico de engajamento

Upgrade é mais satisfatório se:
- Custo = 10-20x o ganho por clique
- Valor = 20-50% do ganho anterior

### 3. Curva de multiplicadores

Cada multiplicador deve aumentar a velocidade de jogo:
- 5% = "Mal sinto a diferença"
- 10% = "Perceptível"
- 25% = "Notável"
- 50% = "Massivo"
- 100% = "Duplica tudo"

## 🎮 Meta-Loop Desejado

### Dia 1 (0-30 min)
1. Clica para ganhar $100
2. Compra café ($10), ganha +1 clique
3. Clica mais rápido, alcança $500
4. Compra curso (+10%), sente multiplicador
5. Compra notebook, renda dispara
6. Atinge CEO em 30 min

### Dia 1-2 (30min - 6hrs)
7. Passa a usar renda passiva como principal
8. Cadeira ergonômica ativa
9. Números explodem
10. Atinge $100M
11. Ativa reward ad (2x por 5 min)
12. Logs off

### Dia 2+ (Offline + Prestige)
13. Volta: Ganhou $100M offline (8 horas)
14. Pode prestigiar com bônus permanente
15. Recomeça mas progride 20% mais rápido
16. Torna-se ciclo viciante

## 🔧 Checklist de Balanceamento

Antes de lançar uma nova versão:

- [ ] Primeiro upgrade custa < 10% do starting capital?
- [ ] Cada cargo leva 5-15 minutos para alcançar?
- [ ] Multiplicadores causam aumento visual de velocidade?
- [ ] Nenhum upgrade é dominante (melhor sempre variar)?
- [ ] Prestige/offline cria loop de 1-2 dias?
- [ ] Números não explodem em overflow?
- [ ] Passivo é significativo depois de 10 minutos?

## 📊 Ferramentas para Testar

```dart
// Adicionar ao GameService para testes:
void debugMultiplyMoney(double factor) {
  state.money = state.money * factor;
  notifyListeners();
}

void debugAddUpgrade(String upgradeId) {
  buyUpgrade(upgradeId);
}

void debugSetCareer(int level) {
  state.currentCareerLevel = level;
  notifyListeners();
}

void debugElapsedTime(Duration duration) {
  state.earnPassiveIncome(duration);
  notifyListeners();
}
```

Use isso para:
- Simular 1 hora de jogo em 10 segundos
- Testar se multiplicadores funcionam
- Verificar promoções automáticas
- Validar transições de fase

## 🎯 Objetivo Final

Um jogo onde:
- ✅ Novos jogadores entendem em <1 minuto
- ✅ Progresso é satisfatório nos primeiros 30 min
- ✅ Jogo continua viciante até semanas
- ✅ Reward ads aumentam o prazer mas não são forcing
- ✅ Prestige cria endgame loop
