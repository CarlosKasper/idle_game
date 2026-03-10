# Análise de Balanceamento Baseada em Idle Games Reais

Esse documento baseia-se em análise de games vencedores como Cookie Clicker, Clicker Heroes, AdCap e Tycoon Empire.

## 📊 Comparativa: Nosso Game vs. Market Leaders

### Cookie Clicker (Baseline)
- Primeiro upgrade em 15 cliques
- Custo exponencial: 1.15x por nível ✓ (usamos igual)
- Prestige em ~1-2 horas
- Multiplicadores fortes: +10%, +20%, até +100%

### Clicker Heroes
- 10 heróis, cada um com upgrade infinito
- Autoclicker após 1 minuto
- Prestige a cada 30min-1h
- Progression muito rápida (explosiva)

### AdCap (Mobile)
- Foco em reward ads
- Monetização principal via ads 2x
- Offline ganho limitado (2h max)
- Prestige com pequeno bônus

### Nós (Office Idle v1.0)
- 5 upgrades simples
- Clique manual (por enquanto)
- Passivo significativo desde cedo
- Pronto para prestige em v3

## 🎯 Análise de Nossos Números

### Early Game (0-5 minutos)
```
Sequência esperada:
1. 0:00 - Iniciar com $0
2. 0:30 - Ganhar $15-30 (15-30 cliques)
3. 1:00 - Comprar Café ($10), agora +1 clique
4. 2:00 - Ganhar $500+ com Café
5. 2:30 - Comprar Notebook ($100), agora +2 cliques
6. 4:00 - Ganhar $10k
7. 4:30 - Primeira promoção (Funcionário)
8. 5:00 - Tem $50k, opções de novo upgrade
```

**Verdict**: Muito rápido! ⚠️

**Problema**: Primeira promoção em 4:30 (na verdade ~3-4 minutos)

**Solução**: Aumentar custo de Funcionário para $500 (era $100)

### Mid Game (5-30 minutos)
```
6. 5:00 - $50k, compra Cadeira ($50) para +0.5/s
7. 10:00 - $500k, compra Curso ($500) para +10%
8. 15:00 - $1M, compra Monitor ($200) para +5%
9. 20:00 - $5M, múltiplas compras
10. 30:00 - $100M, ou mais
```

**Verdict**: Exponencial mas viciante

**Análise**: À marca de 30 minutos, deve estar no nível de Analista ou Gerente
- Esperado: Analista ($10k renda)
- Atual: Provavelmente Gerente ($50k renda)

**Possível ajuste**: Aumentar Analista para $50k (era $5k)

### Late Game (30min+)
```
Sem limite claro, números explodem
Prestige ainda não implementado
Sem meta clara apos CEO
```

**Verdict**: Falta endgame

**Problema**: Jogador fica sem motivação após CEO

**Solução**: v3.0 com Prestige e bônus crescentes

## 💰 Comparativa de Custos

### Nossa Progressão vs. Cookie Clicker

```
Nome          Nosso    Cookie   Multiplier
Cursor        N/A      15       N/A
Clique base   1        1        1x
Primeiro upg  10       15       ✓ Similar
2º upgrade    100      100      ✓ Similar
3º upgrade    50       1100     ? Muito barato
4º upgrade    500      12000    ? Muito barato
5º upgrade    200      130k     ? Muito barato

Carreira 2    100      N/A      N/A
Carreira 3    5000     N/A      N/A
Carreira 4    100k     N/A      N/A
Carreira 5    2M       N/A      N/A
Carreira 6    50M      N/A      N/A
```

**Análise**: Nossos upgrades são muito baratos!

**Recomendação**: Aumentar custos em v2.0

## 🔄 Sugestões de Rebalanceamento

### Opção A: "Casual" (Mais rápido)
Para jogadores que querem progressão rápida

```
// Reduzir custos de carreira em 50%
careerFuncionario = 50     // era 100
careerAnalista = 2500      // era 5000
careerGerente = 50000      // era 100000
careerDiretor = 1000000    // era 2000000
careerCEO = 25000000       // era 50000000

// Aumentar ganhos
upgradeClickBonus = 2      // era 1
upgradeNotebookBonus = 3   // era 2
```

**Resultado**: Primeira promoção em 2-3 min, CEO em 30 min

### Opção B: "Balanced" (Recomendado)
O meio termo - similar a Cookie Clicker

```
// Manter carreira como está (já está bem)
careerFuncionario = 100    // OK
careerAnalista = 5000      // OK
careerGerente = 100000     // OK
careerDiretor = 2000000    // OK
careerCEO = 50000000       // OK

// Aumentar custos de upgrades
upgradeCoffeeCost = 20     // era 10 (2x)
upgradeNotebookCost = 250  // era 100 (2.5x)
upgradeChairCost = 150     // era 50 (3x)
upgradeCourseCost = 2000   // era 500 (4x)
upgradeMonitorCost = 1000  // era 200 (5x)

// Aumentar valores um pouco
upgradeClickBonus = 1.5    // era 1
upgradePassiveBonus = 1.0  // era 0.5
```

**Resultado**: Primeira promoção em 10 min, CEO em 1-2 horas

### Opção C: "Hardcore" (Mais desafiador)
Para jogadores que querem que dure

```
// Aumentar requisitos de carreira
careerFuncionario = 500    // era 100 (5x)
careerAnalista = 50000     // era 5000 (10x)
careerGerente = 1000000    // era 100000 (10x)
careerDiretor = 20000000   // era 2000000 (10x)
careerCEO = 500000000      // era 50000000 (10x)

// Manter custos de upgrades normais
```

**Resultado**: Primeira promoção em 30 min, CEO em 6-10 horas

## 📈 Recomendação Final

**Comece com Opção B (Balanced)**, depois:

1. **Dia 1**: Testar por 2-3 horas
2. **Feedback**: Qual sensação de progressão?
3. **Ajuste**: Se muito rápido → Opção A; se muito lento → Opção C
4. **Iteração**: A cada ajuste, testar 30-60 minutos

## 🎮 Testes de Validação

Use essa checklist antes de cada release:

```
[ ] Primeiro upgrade em tempo aceitável (15-30s melhor)
[ ] Segunda compra possível em <2 minutos
[ ] Primeira carreira em tempo esperado:
    - Casual: 2-3 min
    - Balanced: 5-10 min
    - Hardcore: 15-30 min
[ ] Passivo visível em >5 minutos
[ ] Multiplicadores causam "wow" moment
[ ] Nenhum upgrade domina os outros
[ ] Números não explodem em overflow
[ ] Sessão de 30-60 min é satisfatória
```

## 🔬 Métricas para Monitorar

Com Analytics (v2.0), rastrear:

```dart
// Para cada teste de 30 minutos:
{
  "total_clicks": 150,      // Meta: 200-400
  "total_upgrades_bought": 8, // Meta: 5-12
  "promotions": 2,           // Meta: 1-3
  "clicks_per_minute": 5,    // Meta: 5-8
  "money_earned": 100000,    // Meta: 50k-500k
  "final_career": 2,         // Meta: 2-4
}
```

## 🎯 Próximas Ações

### Imediato (Antes de v2.0)
1. [ ] Decidir entre Opção A, B ou C
2. [ ] Implementar mudanças em constants.dart
3. [ ] Testar por 2-3 horas
4. [ ] Rebalancear se necessário

### v2.0 (Com Offline + Ads)
1. [ ] Sistema offline pode quebrar balanceamento
2. [ ] Ads tornam progressão muito rápida
3. [ ] Pode precisar aumentar custos 50% mais
4. [ ] Testar com offline de 8 horas

### v3.0 (Com Prestige)
1. [ ] Prestige deve viabilizar runs repetidas
2. [ ] Cada run ~50% mais rápida que anterior
3. [ ] Mínimo 2-3 runs deve ser satisfatório
4. [ ] Bônus permanente deve parecer "worth it"

## 📚 Referências

Estudos sobre game design:
- GDC Talk: "Lazy Game Design" (sobre idle games)
- "Progress is the Best Reward" - Jane McGonigal
- Cookie Clicker: Orteil's notes on balance

---

**Conclusão**: Office Idle está bem estruturado. O balanceamento inicial é agressivo (progressão rápida), mas facilmente ajustável. Recomendo começar com **Opção B** e iterar baseado em testes.
