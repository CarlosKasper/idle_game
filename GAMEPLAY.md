# Office Idle - Jogo Corporativo

Um idle game minimalista com tema corporativo, focado em progressão natural e monetização por anúncios.

## 🎮 Features Atuais (Versão 1)

- ✅ **Cliques geradores de dinheiro** - O jogador ganha dinheiro ao clicar no botão "Trabalhar"
- ✅ **Carreira corporativa** - 6 níveis de carreira (Estagiário → CEO) com aumento progressivo de renda
- ✅ **Sistema de upgrades** - 5 upgrades para melhorar a eficiência
- ✅ **Multiplicadores** - Upgrades que multiplicam sua renda total
- ✅ **Renda passiva** - Ganho automático de dinheiro por segundo
- ✅ **Salvamento automático** - Progresso salvo com SharedPreferences
- ✅ **Formatação de números** - Abreviações (K, M, B, T) para valores grandes

## 📁 Estrutura do Projeto

```
lib/
├── main.dart                 # Entrada da app com Provider setup
├── models/
│   ├── money.dart          # Classe Money com formatação
│   ├── career.dart         # Definição de cargos corporativos
│   ├── upgrade.dart        # Sistema de upgrades
│   └── game_state.dart     # Estado completo do jogo
├── services/
│   ├── game_service.dart   # Lógica principal (ChangeNotifier)
│   └── save_service.dart   # Persistência com SharedPreferences
└── screens/
    └── home_screen.dart    # UI principal do jogo
```

## 🏗️ Arquitetura

### Money (Classe de Valor)

Encapsula double para operações monetárias com:

- Operadores matemáticos overloadados (+, -, \*, /)
- Formatação automática (1000 → 1K)
- Comparações facilitadas

### GameState

Estado imutável-like que contém:

- Dinheiro atual e total ganho
- Nível de carreira
- Bônus adquiridos (clique, renda/s, multiplicadores)
- Upgrades comprados e seus níveis

### GameService (ChangeNotifier)

Gerencia a lógica do jogo:

- `click()` - Processa ganho por clique
- `updatePassiveIncome()` - Atualiza renda passiva
- `buyUpgrade()` - Compra e aplica upgrade
- Integração com SaveService

### SaveService

Persiste o estado do jogo com JSON serialization.

## 📊 Economia do Jogo

### Cargos (Career Levels)

| Cargo       | Renda Base    | Requer      |
| ----------- | ------------- | ----------- |
| Estagiário  | $1/clique     | $0          |
| Funcionário | $3/clique     | $100        |
| Analista    | $10/clique    | $5,000      |
| Gerente     | $50/clique    | $100,000    |
| Diretor     | $200/clique   | $2,000,000  |
| CEO         | $1,000/clique | $50,000,000 |

### Upgrades Versão 1

| Nome        | Tipo          | Efeito | Custo | Infinito |
| ----------- | ------------- | ------ | ----- | -------- |
| Café ☕     | Clique        | +1     | $10   | ✅       |
| Notebook 💻 | Clique        | +2     | $100  | ✅       |
| Cadeira 🪑  | Passivo       | +0.5/s | $50   | ✅       |
| Curso 📚    | Multiplicador | +10%   | $500  | ❌       |
| Monitor 🖥️  | Multiplicador | +5%    | $200  | ❌       |

### Fórmulas Principais

```
ganho_clique = (cargo_base + bônus_clique) × multiplicador
ganho_segundo = (bônus_passivo) × multiplicador
custo_upgrade = base × 1.15^(nível-1)  // Apenas upgrades infinitos
```

## 🎯 Progressão Recomendada (Versão 2-3)

### Versão 2 (Próxima)

- [ ] Reward Ads: 2x dinheiro por 5 minutos
- [ ] Sistema offline: Ganho baseado em tempo ausente
- [ ] Metas/Conquistas
- [ ] Efeitos visuais melhorados

### Versão 3 (Prestige)

- [ ] Sistema de Prestige (renúncia com bônus permanente)
- [ ] Novos upgrades infinitos (Treinamento, Eficiência)
- [ ] Bônus permanentes desbloqueáveis
- [ ] Rebalanceamento de curva de progresso

## 🎨 UI/UX

- **Material Design 3** com tema azul corporativo
- **Gradientes** para destacar áreas principais
- **Sombras** para profundidade
- **Animações** ao clicar (feedback visual)
- **Responsivo** - Adaptável a diferentes tamanhos

## 🔧 Como Rodar

```bash
# Instalar dependências
flutter pub get

# Rodar em emulador/device
flutter run

# Build release
flutter build apk   # Android
flutter build ios   # iOS
```

## 💾 Persistência

O jogo salva automaticamente após:

- Cada clique
- Cada compra de upgrade

Dados salvos em SharedPreferences (em JSON):

- Dinheiro e total ganho
- Nível de carreira
- Bônus adquiridos
- Níveis de upgrades infinitos
- Timestamp do último save

## 📈 Balanceamento de Jogo

A curva de progressão foi pensada para:

1. **Early Game (1min - 5min)** - Muito rápido
   - Cliques geram dinheiro visível
   - Primeiros upgrades baratos
   - Primeira promoção rápida

2. **Mid Game (5min - 30min)** - Progressão natural
   - Upgrades curam mais
   - Multiplicadores começam a aparecer
   - Carreira avança mas desacelera

3. **Late Game (30min+)** - Exponencial
   - Multiplicadores dominam
   - Números muito grandes
   - Prestige se torna interessante (próxima versão)

## 🚀 Próximos Passos

1. **AdMob Integration** - Reward ads
2. **Analíticos** - Rastrear engajamento
3. **Offline Rewards** - Dinheiro quando offline
4. **Sistema de Prestige** - Endgame loop
5. **Mais upgrades** - Expandir variedade

## 📝 Notas de Design

- **Simple is better**: Apenas o jogador gera dinheiro (sem NPCs)
- **Visual feedback**: Animações ao clicar mantêm o jogo vivo
- **Exponential growth**: Multiplicadores criam sensação de progresso
- **Long tail**: Prestige e offline rewards estendem o ciclo de vida
- **Humor corporativo**: Emojis e nomes tornam o jogo divertido

## 📄 Licença

Este projeto é um exemplo de arquitetura de idle game em Flutter.
