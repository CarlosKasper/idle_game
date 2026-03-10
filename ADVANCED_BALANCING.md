# Fórmulas Avançadas de Balanceamento - Office Idle

Esse documento detalha as fórmulas matemáticas que tornam um idle game realmente viciante.

## 1. The Exponential Curve (A Fórmula Secreta)

A maioria dos idle games usa uma **exponential growth curve** que cria a ilusão de progresso acelerado:

```
custo_n = base × 1.15^(n-1)
```

Isso significa:
- Nível 1: $10
- Nível 2: $11.50
- Nível 3: $13.22
- Nível 10: $40.45
- Nível 100: $1,301,000
- Nível 200: $169,000,000

**Por que funciona:** O jogador sente que está comprando "caro" (1.15x mais), mas comparado ao dinheiro que ganhou, é barato.

### Ajustes de Balanceamento

Se o jogo fica muito fácil:
```
// Atual (1.15 = +15% por nível)
custo_n = base × 1.15^(n-1)

// Mais difícil (1.20 = +20% por nível)
custo_n = base × 1.20^(n-1)

// Muito mais difícil (1.25 = +25%)
custo_n = base × 1.25^(n-1)
```

Se o jogo fica muito difícil, reduzir para 1.10 ou 1.12.

**Recomendação:** Começa com 1.15 e ajusta baseado em feedback.

---

## 2. The Prestige Formula (Loop Infinito)

Para criar um endgame que não quebra:

```
final_multiplier = 1.0 × (1 + prestige_count × prestige_bonus)

prestige_bonus = 0.20  // 20% por prestige

Exemplos:
- 0 prestiges: 1.0x (100%)
- 1 prestige:  1.2x (120%)
- 2 prestiges: 1.4x (140%)
- 5 prestiges: 2.0x (200%)
- 10 prestiges: 3.0x (300%)
```

**Nota:** Isso é aditivo, não multiplicativo. Se fosse multiplicativo (1.2 × 1.2 × 1.2), explodiria.

### Balanced Prestige Progression

Para que prestige não seja "one-time only", cada prestige deve:

1. **Dobrar a velocidade do próximo run**
   - Run 1: 2 horas para $10B
   - Run 2: 1 hora para $10B (2x boost)
   - Run 3: 30 min para $10B (4x boost)

2. **Fórmula de velocidade:**
   ```
   tempo_run_n = tempo_base / (2^(n-1))
   
   // Com prestige bonus:
   velocidade_final = base_velocity × prestige_multiplier
   ```

---

## 3. Curva Ideal de Custo x Ganho

Um upgrade é satisfatório quando:

```
custo = ganho_por_segundo × tempo_payout

tempo_payout (ideal) = 30-60 segundos

Exemplos:
- Ganho: $5/s
- Tempo ideal: 30s
- Custo ideal: $150

Validação:
- Muito barato: < 15s (frustra)
- Muito caro: > 120s (chata)
```

**Fórmula para rebalancear:**

```dart
double calculateIdealCost(double gainPerSecond, Duration payoutTime) {
  return gainPerSecond * payoutTime.inSeconds;
}

// Uso:
double cost = calculateIdealCost(5, Duration(seconds: 45));
// Resultado: $225
```

---

## 4. Multiplicador Perception (Quão "bom" parece)

Estudos mostram que multiplicadores são percebidos assim:

```
Multiplicador | Percepção         | Ideal para
+5%           | "Mal sinto"       | Upgrades fracos
+10%          | "Notável"         | Upgrades médios
+25%          | "Muito bom!"      | Upgrades fortes
+50%          | "Insane!"         | Multiplicadores especiais
+100% (2x)    | "Exponencial!"    | Reward ads ou prestige
+500%         | "Quebra o jogo"   | Evitar ou balance muito bem
```

**Recomendação:**
- Maioria dos upgrades: +5% a +15%
- Multiplicadores especiais: +25% a +50%
- Nunca acumule muitos +50% (vai explodir)

---

## 5. Dopamine Curve (Vício Científico)

Idle games funcionam porque disparam dopamina em momentos específicos:

```
Ação                      | Dopamina | Quando Ocorre
Clique (feedback)         | ++       | Imediato
Upgrade comprado          | +++      | A cada 30-60s
Novo multiplicador        | ++++     | A cada 2-5 min
Promoção de carreira      | +++++    | A cada 5-15 min
Número novo (1M, 1B)      | +++      | Progressivo
Prestige desbloqueado     | +++++    | Depois de horas
```

**Design para manter dopamina:**
- Cliques devem ter feedback imediato (som/animação)
- Upgrades devem estar sempre disponíveis
- Não deixar >5 min sem algo novo acontecer

---

## 6. Balanceamento por Faze

### Early Game (0-10 min)
Objetivo: Adição dopamine rápida
```
- Primeiro upgrade em 10-20 segundos
- Ganho base: 1 por clique
- Custo primeiro upgrade: 5-10x o ganho
- Multiplicadores pequenos: +5% a +10%
```

### Mid Game (10-60 min)
Objetivo: Sensação de aceleração
```
- Upgrades a cada 30-60 segundos
- Ganho explode exponencialmente
- Multiplicadores dominam: +15% a +25%
- Promoção a cada 5-10 minutos
```

### Late Game (1h+)
Objetivo: Mantém engajado mas não força
```
- Passivo é >90% do ganho
- Clique é negligenciável
- Multiplicadores massivos: +50%+
- Prestige começa a fazer sentido
```

---

## 7. Overflow Prevention (Evitar Números Quebrados)

Double em Dart pode ir até ~10^308, mas UI quebra com números muito grandes.

```dart
// Implementado no Money.format():
if (amount < 1000) return "$amount";
if (amount < 1e6) return "${(amount/1e3).toStringAsFixed(1)}K";
if (amount < 1e9) return "${(amount/1e6).toStringAsFixed(1)}M";
if (amount < 1e12) return "${(amount/1e9).toStringAsFixed(1)}B";
if (amount < 1e15) return "${(amount/1e12).toStringAsFixed(1)}T";
// Após: Qa, Qin, Sx, Sp...
```

**Dica:** Mesmo que o jogo suporte números gigantes, a UI só precisa mostrar até Trillions (T = 1e12).

---

## 8. Upgrade Variety (Não deixar um dominador)

Se um upgrade é sempre melhor que todos, o jogo fica entediante.

```
Cenário BAD:
- Café sempre o melhor (nunca compra outra coisa)

Cenário GOOD:
- Café barato, rápido de recuperar (buy many)
- Notebook mais caro (buy when rich)
- Multiplicadores raro/caro (save for special)
```

**Fórmula para garantir variedade:**

```
valor_relativo = ganho_upgrade / custo_upgrade

// Deve estar numa range
min_value = 0.010   // Upgrade fraco
max_value = 0.050   // Upgrade forte

// Revisar regularmente:
café = 1 / 10 = 0.10    // TOO GOOD!
notebook = 2 / 100 = 0.02  // OK
cadeira = 0.5 / 50 = 0.01  // OK
```

Se café é sempre melhor, aumentar custo ou reduzir valor.

---

## 9. Ad Placement (Monetização sem Tédio)

Reward ads funcionam melhor em momentos específicos:

```
Momento              | Chance Click | Design
Ao retornar offline  | 60%          | "Ganhou $100M! Clique pro 2x"
Novo cargo/rank      | 45%          | "Parabéns CEO! 2x renda?"
Bloqueado (sem $)    | 30%          | Ofertar boost pago
A cada 15 min        | 5%           | Apenas oferta suave
```

**Estratégia:**
- Primeiro ad após 5 min (natural)
- Próximo após ganho offline ou promoção
- Máximo 1 por 10 minutos (não spam)

---

## 10. Prestige Math (A Fórmula do Loop Infinito)

Para que prestige crie um loop realmente viciante:

```
tempo_alcançar_prestige = T_0
velocidade_ganho = V_0 × (1 + prestige_bonus × count)

// Run 1:
T_1 = 120 min, V_1 = 1.0x
Ganho para prestige = $10B

// Run 2 (com 1 prestige):
T_2 = 120 / 2 = 60 min (2x mais rápido)
V_2 = 1.0 × 1.2 = 1.2x velocidade

// Run 3 (com 2 prestiges):
T_3 = 120 / 4 = 30 min
V_3 = 1.0 × 1.4 = 1.4x velocidade

// Run 10:
T_10 = 120 / (2^9) = 0.23 min = 14 segundos!
```

**Problema:** Eventualmente fica muito rápido (cosmético)

**Solução:** Ajustar requisito de prestige por run

```
req_prestige_1 = $10B
req_prestige_2 = $100B  (10x)
req_prestige_3 = $1T    (10x)

// Mantém tempo similar mesmo com boost
```

---

## 11. Balanceamento de Teste (Checklist)

Antes de cada release:

```
GAMEPLAY
- [ ] Primeiro upgrade em <30 segundos
- [ ] Primeira promoção em <5 minutos
- [ ] Passivo significativo em >10 minutos
- [ ] Nenhum upgrade tão bom que ignora outros

PROGRESSÃO
- [ ] Números crescem visualmente (ex: 1, 10, 100, 1K)
- [ ] Multiplicadores causam "WOW" moments
- [ ] Promoções marcam milestones claros

BALANÇO
- [ ] Nenhuma fase >2 horas sem mudança
- [ ] Tempo offline realista (2-8 horas)
- [ ] Prestige é opcional, não forçado

MONETIZAÇÃO (v2+)
- [ ] Ads não interrompem gameplay (apenas oferta)
- [ ] Reward ad improve a experiência, não necessária
- [ ] Offline reward é satisfatório sem ad

PERFORMANCE
- [ ] Salva sem lag
- [ ] 60 FPS mesmo com números gigantes
- [ ] Sem memory leaks em 1+ hora de jogo
```

---

## 12. Fórmula Final: O Multiplicador da Satisfação

```
satisfacao = (progresso_visual × dopamina_timing) / tedium_factor

onde:
progresso_visual = quanto os números crescem por ação
dopamina_timing = frequência de recompensas
tedium_factor = quanto tempo espera entre ações
```

**Para maximizar:**
1. ↑ Aumentar crescimento dos números (exponencial)
2. ↑ Aumentar frequência de upgrades (mais baratos)
3. ↓ Diminuir tempo de espera (passivo rápido)

Mas equilibrado - não todo mundo quer spam de notificações!

---

## Conclusão

Os idle games que viram fenômenos (Cookie Clicker, Clicker Heroes, AdCap) usam essas fórmulas. A matemática simples por trás cria loops viciantes.

**Key Takeaway:** Exponential growth + frequent rewards + optional ads = sucesso.
