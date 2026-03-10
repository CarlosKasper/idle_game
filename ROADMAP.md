# Roadmap - Office Idle

## ✅ Versão 1.0 (CONCLUÍDA)

**Objetivo**: Core loop funcional e viciante

- [x] Loop: clique → dinheiro → upgrade → progresso
- [x] 6 níveis de carreira com promoções automáticas
- [x] 5 upgrades funcionais (clique, passivo, multiplicadores)
- [x] Renda por segundo
- [x] Salvamento automático
- [x] Formatação de números (K, M, B, T)
- [x] UI limpa e responsiva

**Duração esperada**: 30 min - 1 hora para primeira sessão

---

## 📅 Versão 2.0 (Próxima) - Monetização

**Objetivo**: Adicionar reward ads sem forçar

### Features a Implementar

#### 2.1 Reward Ads com AdMob
```dart
// Novo modelo de RewardAdService
class RewardAdService {
  Future<void> showRewardAd(RewardType type) async {
    // 2x dinheiro por 5 minutos
    // ou 10 minutos de renda passiva instantânea
  }
}
```

**Tipos de Reward:**
- `2xMoney` (5 min): Todos ganhos multiplicados por 2
- `OfflineBoost` (10x): 10 minutos de renda passiva instantânea
- `ProductivityBoost` (3 min): +100% no clique

**Placement:**
- Botão flutuante opcional (não intrusivo)
- Após 2 minutos de jogo
- Ao volta offline
- Ao atingir cargo novo

#### 2.2 Sistema Offline Completo
```dart
// Calcula ganho baseado em tempo ausente
Duration offlineTime = now - lastSaveTime;
Money offlineReward = incomePerSecond * offlineTime.inSeconds;
// Máximo: 8 horas
// Com reward ad: dobra
```

**Implementação:**
- Detecta tempo desde último save
- Limita a 8 horas (previne abuse)
- Oferece reward ad para dobrar
- Mostra animação ao retornar

#### 2.3 Sistema de Metas/Conquistas
```dart
class Achievement {
  final String id;
  final String title;
  final String description;
  final Money requirement;
  final Money reward;
  bool isUnlocked;
}
```

**Exemplos de Metas:**
- Ganhar $100 total
- Ganhar $10K total
- Alcançar Gerente
- Comprar 50 upgrades
- Usar reward ad 5x

**Recompensas:**
- +1% renda permanente
- +1 clique base
- Novos upgrades desbloqueados

#### 2.4 Mais Upgrades Temáticos
```
Teclado Mecânico Gamer    | +3 clique      | $1K  | Infinito
Plantinha de Escritório   | +1/s passivo   | $200 | Infinito
Reunião que é Email       | +15% renda     | $5K  | Uma vez
ChatGPT no PC             | +50% renda     | $10K | Uma vez
Fone Noise Cancelling     | +20% renda     | $2K  | Uma vez
```

### Nova Tela: AchievementsScreen
- Lista de metas com progresso
- Notificações ao desbloquear
- Histórico de conquistas

### Modificações de UI
- Badge de reward ad disponível
- Contador offline ganho
- Animação ao retornar

**Tempo de desenvolvimento**: 4-6 horas

---

## 🔄 Versão 3.0 - Prestige & Endgame

**Objetivo**: Loop infinito viciante

### 3.1 Sistema de Prestige
```dart
class PrestigeData {
  int totalPrestiges; // Quantas vezes já prestigiou
  double permanentMultiplier; // +20% por prestige
  double prestigeBonus; // Total = 1.0 + (totalPrestiges * 0.2)
}

void prestige() {
  // Reseta: dinheiro, upgrades, carreira
  // Mantém: permanentMultiplier, achievements
  // Ganha: 20% de bônus multiplicador
}
```

**Requisitos para Prestigiar:**
- Alcançar $10B (ajustável)
- Popup confirma o reset
- Mostra quanto de bônus ganhará

**Progressão Pós-Prestige:**
- Primeira run: 1-2 horas para $10B
- Segunda run: 30 min (20% mais rápido)
- Terceira run: 15 min (40% mais rápido)
- E assim exponencialmente

### 3.2 Novos Upgrades Infinitos (Prestige+)
```
Treinamento Avançado  | +2 clique/nível      | $100K base
Eficiência Máxima     | +3% multiplicador/nv | $1M base
Curso de MBA          | +5 clique/nível      | $500K base
```

Estes only aparecem após primeiro prestige.

### 3.3 Desafios/Eventos Temporários
```dart
class Challenge {
  final String id;
  final String title;
  final Duration duration;
  final Map<String, double> multipliers;
}
```

**Exemplos:**
- "Black Friday": -50% preço upgrades por 30 min
- "Crunch Time": +200% ganho por clique por 15 min
- "Sabotagem": -50% ganho, mas prestige com 2x bônus
- "Jackpot": 1/100 cliques ganha $10K extra

### 3.4 Customização de Carreira
```dart
class CareerCustomization {
  String customTitle; // "CTO", "VP of Vibes"
  String companyName;
  Color themeColor;
}
```

Após 3 prestiges, permite renomear cargo/empresa.

### 3.5 Gráficos de Progresso
- Linha do tempo: Total ganho ao longo do tempo
- Velocity: Quanto ganha por segundo (em tempo real)
- Prestige history: Quantas vezes já prestigiou
- Upgrade usage: Qual upgrade mais comprado

**Telas Novas:**
- PrestigeScreen: Confirmação e visualização de bônus
- StatsScreen: Gráficos e estatísticas
- CareerCustomizationScreen: Personalização

**Tempo de desenvolvimento**: 6-8 horas

---

## 🚀 Versão 4.0+ (Futuro Distante)

### Ideias Adicionais

#### 4.1 Modo Competitivo (Leaderboard)
- Top 100 jogadores
- Por dinheiro total
- Por prestige
- Reset semanal

#### 4.2 Sistema de Trade
- Trocar upgrades com amigos
- Giftar dinheiro
- Competição local

#### 4.3 Prestige Infinito+
- Superintendente (tras para fora Prestige)
- Bônus gigantescos
- Redesign total após 10 prestiges

#### 4.4 Modo Sandbox
- Cheats para testes
- Multiplicadores configuráveis
- Debug tools

#### 4.5 Temas/Skins
- Tema corporativo (atual)
- Tema gamer
- Tema startup
- Tema governo

---

## 📊 Cronograma Estimado

```
Semana 1: v1.0 (Core - CONCLUÍDO)
Semana 2-3: v2.0 (Ads + Offline)
Semana 4: v3.0 (Prestige)
Semana 5+: v4.0 (Extra features)
```

---

## 🎯 Métricas de Sucesso

Cada versão deve atingir:

**v1.0:**
- ✅ Compila sem erros
- ✅ Primeiro upgrade em <2 min
- ✅ Primeira promoção em <5 min
- ✅ Joga por 30 min sem tédio

**v2.0:**
- ✅ Reward ads: 20%+ dos jogadores clickam
- ✅ Offline: Jogadores voltam depois de 2+ horas
- ✅ Metas: >30% conclusão de metas

**v3.0:**
- ✅ Prestige: >50% dos jogadores tentam
- ✅ Engajamento: Média de 30 min/dia em 1 semana
- ✅ Retenção: >40% volta no dia 2, >20% no dia 7

---

## 💻 Stack Técnico

### Current (v1.0)
- Flutter 3.11+
- Provider para state management
- SharedPreferences para save
- Material Design 3

### v2.0
- Google Mobile Ads SDK (AdMob)
- Analytics (Firebase Analytics)

### v3.0
- Firebase Firestore (leaderboard - v4)
- Cloud Functions (prestige sync)

### v4.0+
- Real-time multiplayer
- Cloud saves
- Themes/Skins gerenciados

---

## 🐛 Dívida Técnica

Itens para refatorar futuramente:

- [ ] Extrair constantes de balanceamento para `constants.dart`
- [ ] Criar enums para todas as strings (id dos upgrades, etc)
- [ ] Adicionar testes unitários (GameState, Money)
- [ ] Adicionar testes de widget (HomeScreen)
- [ ] Refatorar HomeScreen em componentes menores
- [ ] Criar serviço de analíticos centralizado
- [ ] Usar riverpod ao invés de provider (melhor performance)

---

## 📝 Notas Gerais

- **Sempre** começar com a versão anterior funcionando 100%
- **Jamais** mudar balanceamento drasticamente em mid-version
- **Sempre** testar offline antes de publicar
- **Sempre** incluir migration de save se mudar schema
- **Prestige é opcional** - Não force o jogador, deixa descobrir
- **AdMob não deve forçar** - Apenas oferecer bônus extra

Bem-vindo ao mundo dos idle games! 🚀
