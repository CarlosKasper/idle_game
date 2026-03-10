# Documentação Completa - Office Idle

Índice e guia de leitura para toda a documentação do projeto.

## 📚 Como Navegar

A documentação está organizada em 4 categorias:

### 1️⃣ **Iniciando** (Comece aqui!)

#### [README.md](README.md)
**Leitura: 5 minutos**
- Overview do projeto
- Como instalar e rodar
- Estrutura básica
- Links para mais info

**Quando ler**: Primeira vez acessando o projeto

---

### 2️⃣ **Jogando & Entendendo o Jogo**

#### [GAMEPLAY.md](GAMEPLAY.md)
**Leitura: 10 minutos**
- Como o jogo funciona
- Features atuais (v1.0)
- Sistema de carreira, upgrades
- Progressão e balanceamento básico

**Quando ler**: Antes de jogar, para entender mecânicas

#### [SUMMARY.md](SUMMARY.md)
**Leitura: 8 minutos**
- O que foi implementado na v1.0
- Números e estatísticas
- Status do projeto
- Próximos passos

**Quando ler**: Para entender o estado atual do projeto

---

### 3️⃣ **Balanceando & Ajustando**

#### [BALANCING.md](BALANCING.md)
**Leitura: 15 minutos**
- Princípios de design de idle games
- Métricas atuais do jogo
- Problemas comuns e soluções
- Checklist de balanceamento

**Quando ler**: Quando o jogo sente "estranho" (rápido/lento demais)

#### [ADVANCED_BALANCING.md](ADVANCED_BALANCING.md)
**Leitura: 20 minutos**
- Fórmulas matemáticas avançadas
- Exponential curve (1.15^n)
- Prestige math
- Dopamine curve
- Overflow prevention

**Quando ler**: Para entender a matemática profunda

#### [BALANCE_ANALYSIS.md](BALANCE_ANALYSIS.md)
**Leitura: 15 minutos**
- Comparativa com games reais (Cookie Clicker, etc)
- Análise da progressão atual
- 3 opções de rebalanceamento (Casual, Balanced, Hardcore)
- Recomendações finais

**Quando ler**: Antes de fazer mudanças grandes no balanceamento

---

### 4️⃣ **Desenvolvendo & Contribuindo**

#### [CONTRIBUTING.md](CONTRIBUTING.md)
**Leitura: 15 minutos**
- Como contribuir ao projeto
- Estrutura de pastas
- Convenções de código
- Fluxo de desenvolvimento
- Como adicionar features
- Workflow de testing

**Quando ler**: Antes de fazer código/PR

#### [ROADMAP.md](ROADMAP.md)
**Leitura: 20 minutos**
- Roadmap completo (v2, v3, v4+)
- O que vem em cada versão
- Cronograma estimado
- Dívida técnica
- Métricas de sucesso

**Quando ler**: Para entender o plano futuro

---

### 5️⃣ **Publicando & Marketing**

#### [PUBLISHING.md](PUBLISHING.md)
**Leitura: 20 minutos**
- Guia passo-a-passo para publicar
- Android (Google Play)
- iOS (App Store)
- Build, assinatura, upload
- Checklist pré-lançamento

**Quando ler**: Quando pronto para lançar

#### [MARKETING.md](MARKETING.md)
**Leitura: 15 minutos**
- Estratégia de marketing
- Fase 1: Soft Launch
- Fase 2: Hard Launch
- Canais de divulgação (Reddit, Twitter, etc)
- Community management
- Crescimento realista

**Quando ler**: Para planejar lançamento e crescimento

---

## 🗺️ Mapa de Leitura por Persona

### 👤 "Eu só quero jogar"
1. Instale seguindo README
2. Leia GAMEPLAY para entender
3. Jogue! 🎮

**Tempo**: 15 minutos

---

### 👨‍💻 "Vou balancear o jogo"
1. Leia BALANCING para entender princípios
2. Consulte BALANCE_ANALYSIS para opções
3. Altere números em `lib/constants/game_constants.dart`
4. Teste por 30-60 minutos
5. Repita até ficar bom

**Tempo**: 1-2 horas

---

### 🛠️ "Vou adicionar features"
1. Leia CONTRIBUTING para estrutura
2. Escolha feature no ROADMAP
3. Implemente seguindo padrão
4. Adicione testes
5. Faça PR

**Tempo**: Depende da feature (2-6 horas)

---

### 🚀 "Vou publicar o jogo"
1. Leia PUBLISHING para setup
2. Siga checklist pré-lançamento
3. Build Android e iOS
4. Submeta para appstores
5. Leia MARKETING para crescimento

**Tempo**: 2-3 dias

---

### 📊 "Vou analisar balanceamento avançado"
1. Leia ADVANCED_BALANCING para fórmulas
2. Estude BALANCE_ANALYSIS para aplicação
3. Use ferramentas de debug em GameService
4. Teste cenários específicos

**Tempo**: 2-3 horas

---

## 📖 Guia Rápido por Tópico

### Como...?

#### ...jogar o jogo?
→ [GAMEPLAY.md](GAMEPLAY.md) seção "Features Atuais"

#### ...balancear números?
→ [BALANCING.md](BALANCING.md) seção "Checklist de Balanceamento"

#### ...adicionar um novo upgrade?
→ [CONTRIBUTING.md](CONTRIBUTING.md) seção "Adicionando um Novo Upgrade"

#### ...fazer um teste?
→ [CONTRIBUTING.md](CONTRIBUTING.md) seção "Testes"

#### ...publicar na Play Store?
→ [PUBLISHING.md](PUBLISHING.md) seção "Google Play Console"

#### ...fazer marketing do jogo?
→ [MARKETING.md](MARKETING.md) seção "Canais de Divulgação"

#### ...entender a matemática?
→ [ADVANCED_BALANCING.md](ADVANCED_BALANCING.md) seção "The Exponential Curve"

#### ...saber o roadmap?
→ [ROADMAP.md](ROADMAP.md)

---

## 📊 Documentação por Assunto

### Game Design
- [GAMEPLAY.md](GAMEPLAY.md) - Mecânicas básicas
- [BALANCING.md](BALANCING.md) - Balanceamento
- [ADVANCED_BALANCING.md](ADVANCED_BALANCING.md) - Fórmulas

### Desenvolvimento
- [CONTRIBUTING.md](CONTRIBUTING.md) - Como contribuir
- [ROADMAP.md](ROADMAP.md) - Plano futuro

### Publicação
- [PUBLISHING.md](PUBLISHING.md) - Como publicar
- [MARKETING.md](MARKETING.md) - Marketing

### Análise
- [BALANCE_ANALYSIS.md](BALANCE_ANALYSIS.md) - Análise atual
- [SUMMARY.md](SUMMARY.md) - Status do projeto

---

## 🔗 Estrutura de Código

Documentação incluída nos arquivos:

- `lib/models/money.dart` - Documentação do Money class
- `lib/models/upgrade.dart` - Lista de upgrades com descrições
- `lib/services/game_service.dart` - Métodos principais documentados
- `lib/constants/game_constants.dart` - Constantes com comentários
- `test/game_state_test.dart` - 23 testes com nomes descritivos

---

## 📝 Convenções de Documentação

### Markdown
- `# Título` - Seção grande
- `## Subtítulo` - Seção média
- `### Tópico` - Seção pequena
- `**bold** para ênfase
- `código` para code
- `[Link](path)` para links internos

### Exemplos de Código
- Blocos com ` ``` `
- Indicar linguagem: `dart`, `bash`, `gradle`
- Comentários explicativos

### Tabelas
- Para dados estruturados
- Sempre incluir header

---

## 🎓 Leitura Recomendada

### Para Iniciantes (Total: 30 minutos)
1. [README.md](README.md) - 5 min
2. [GAMEPLAY.md](GAMEPLAY.md) - 10 min
3. [SUMMARY.md](SUMMARY.md) - 8 min
4. [CONTRIBUTING.md](CONTRIBUTING.md) - 7 min

### Para Desenvolvedores (Total: 1 hora)
1. [CONTRIBUTING.md](CONTRIBUTING.md) - 15 min
2. [BALANCING.md](BALANCING.md) - 15 min
3. [ROADMAP.md](ROADMAP.md) - 15 min
4. Explore `lib/` - 15 min

### Para Publicação (Total: 45 minutos)
1. [PUBLISHING.md](PUBLISHING.md) - 20 min
2. [MARKETING.md](MARKETING.md) - 15 min
3. [BALANCE_ANALYSIS.md](BALANCE_ANALYSIS.md) - 10 min

### Para Estudo Aprofundado (Total: 2-3 horas)
1. [ADVANCED_BALANCING.md](ADVANCED_BALANCING.md) - 30 min
2. [BALANCE_ANALYSIS.md](BALANCE_ANALYSIS.md) - 20 min
3. Code review em `lib/models/` - 30 min
4. Testes em `test/` - 20 min
5. Experimentos com GameService - 20 min

---

## 🔄 Como Manter a Documentação Atualizada

Depois de cada grande mudança:

```
1. Modificar código
2. Rodar testes
3. Atualizar docs relacionadas
4. Verificar links quebrados
5. Commit tudo junto
```

Documentos que devem ser atualizados quando:

| Evento | Docs |
|--------|------|
| Novo upgrade | GAMEPLAY, ROADMAP |
| Mudança no balance | BALANCING, BALANCE_ANALYSIS |
| Nova feature | ROADMAP, CONTRIBUTING |
| Novo arquivo | CONTRIBUTING (estrutura) |
| Bug fix | SUMMARY |
| Publicação | SUMMARY, PUBLISHING |

---

## 🆘 Ajuda Rápida

**"Estou perdido!"**
→ Leia [README.md](README.md)

**"Como faço X?"**
→ Use Ctrl+F nesse arquivo para "Como..."

**"Preciso mudar números"**
→ Vá para [BALANCE_ANALYSIS.md](BALANCE_ANALYSIS.md)

**"Vou adicionar feature"**
→ Vá para [CONTRIBUTING.md](CONTRIBUTING.md)

**"Vou publicar"**
→ Vá para [PUBLISHING.md](PUBLISHING.md)

**"Quero entender math"**
→ Vá para [ADVANCED_BALANCING.md](ADVANCED_BALANCING.md)

---

## 📊 Estatísticas da Documentação

| Arquivo | Linhas | Tempo Leitura |
|---------|--------|--------------|
| README.md | ~100 | 5 min |
| GAMEPLAY.md | ~200 | 10 min |
| BALANCING.md | ~250 | 15 min |
| ADVANCED_BALANCING.md | ~400 | 20 min |
| BALANCE_ANALYSIS.md | ~350 | 15 min |
| CONTRIBUTING.md | ~400 | 15 min |
| ROADMAP.md | ~300 | 20 min |
| PUBLISHING.md | ~400 | 20 min |
| MARKETING.md | ~350 | 15 min |
| **TOTAL** | **~2,750** | **~2 horas** |

---

## 🎯 Objetivo da Documentação

✅ Facilitar entendimento do projeto
✅ Permitir contribuições independentes
✅ Documentar decisões de design
✅ Servir como guia de publicação
✅ Ser referência durante desenvolvimento

---

**Última atualização**: 10 de março de 2026
**Versão**: 1.0
**Status**: Completo ✅
