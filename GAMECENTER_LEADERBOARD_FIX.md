# Correção de Game Center Leaderboard - Company Idle

## Problema Identificado

⚠️ **Game Center abre mas não mostra tabela com informações de jogadores**

Ao clicar no botão de Placar, uma UI do Game Center é aberta, mas não exibe:

- Lista de jogadores
- Pontuações
- Rankings

## Possíveis Causas

1. **Jogador não está autenticado** - Sem autenticação, não pode acessar o leaderboard
2. **ID do leaderboard incorreto ou não configurado** - No App Store Connect (iOS) ou Google Play Console (Android)
3. **Nenhuma pontuação submetida** - O leaderboard vazio pode não exibir UI corretamente
4. **Configuração incompleta** - O leaderboard não foi criado/ativado na plataforma

## Soluções Implementadas

### 1. Verificação de Autenticação

Adicionado controle de estado de autenticação:

```dart
static bool _isAuthenticated = false;

static bool get isAuthenticated => _isAuthenticated;
```

### 2. Melhor Tratamento no `initialize()`

```dart
static Future<void> initialize() async {
  try {
    await GamesServices.signIn();
    _isAuthenticated = true;
    print('[GameCenterService] Autenticação bem-sucedida');
  } catch (e) {
    _isAuthenticated = false;
    print('[GameCenterService] Erro ao fazer sign-in: $e');
  }
}
```

### 3. Verificação antes de Submeter Pontuação

```dart
static Future<void> submitScore(int score) async {
  if (!_isAuthenticated) {
    print('[GameCenterService] Jogador não autenticado. Tentando fazer sign-in...');
    await initialize();
  }
  // ... resto do código
}
```

### 4. Melhor Tratamento ao Abrir Leaderboard

```dart
static Future<void> showLeaderboard() async {
  if (!_isAuthenticated) {
    print('[GameCenterService] Jogador não autenticado...');
    try {
      await initialize();
      if (!_isAuthenticated) {
        print('[GameCenterService] Falha ao autenticar.');
        return;
      }
    } catch (e) {
      print('[GameCenterService] Erro durante autenticação: $e');
      return;
    }
  }

  try {
    await GamesServices.showLeaderboards(
      iOSLeaderboardID: _iOSLeaderboardId,
      androidLeaderboardID: _androidLeaderboardId,
    );
    print('[GameCenterService] Placar aberto com sucesso');
  } catch (e) {
    print('[GameCenterService] Erro ao abrir placar: $e');
    // Lista diagnostics
  }
}
```

### 5. Novo Método `resignIn()`

Para permitir reautenticação manual:

```dart
static Future<void> resignIn() async {
  try {
    await GamesServices.signIn();
    _isAuthenticated = true;
    print('[GameCenterService] Reautenticação bem-sucedida');
  } catch (e) {
    _isAuthenticated = false;
    print('[GameCenterService] Erro ao fazer sign-in novamente: $e');
  }
}
```

## Passo a Passo para Resolver

### Se está no iOS (Game Center):

1. **Verificar App Store Connect:**
   - Ir em: My Apps > Company Idle > Game Center
   - Verificar se existe um Leaderboard com ID: `com.kasperlabs.companyIdle.money`
   - Se não existir, criar um novo leaderboard com este ID
   - Ativar o leaderboard

2. **Verificar Autenticação:**
   - O usuário deve estar logado com sua conta do Game Center
   - Pode aparecer prompt pedindo permissão

3. **Submeter Pontuação:**
   - A pontuação deve ser submetida pelo menos uma vez
   - Depois o leaderboard aparecerá com dados

### Se está no Android (Google Play Games):

1. **Verificar Google Play Console:**
   - Ir em: Play Console > Company Idle > Sua aplicação > Play Games Services
   - Verificar se existe leaderboard com ID: `CgkI6LT5luoVEAIQAA`
   - Se não existir, criar um novo

2. **Verificar SHA-1:**
   - A assinatura (SHA-1) do app de debug pode ser diferente
   - Google Play Games precisa da SHA-1 correta

3. **Testar em Device Real:**
   - Google Play Games funciona melhor em dispositivo real
   - Emulador pode ter limitações

## Como Diagnosticar

Verifique os logs do console para mensagens como:

```
[GameCenterService] Autenticação bem-sucedida
[GameCenterService] Pontuação submetida: 12345
[GameCenterService] Placar aberto com sucesso
```

Se vir erros como:

```
[GameCenterService] Jogador não autenticado
[GameCenterService] Erro ao abrir placar: ...
```

Siga os passos acima para resolver.

## Teste Recomendado

```dart
// 1. Verificar autenticação
if (GameCenterService.isAuthenticated) {
  print('✅ Autenticado');
} else {
  print('❌ Não autenticado');
  await GameCenterService.resignIn();
}

// 2. Submeter pontuação
await GameCenterService.submitScore(10000);

// 3. Abrir leaderboard
await GameCenterService.showLeaderboard();
```

## Checklist de Configuração

- [ ] Leaderboard criado no App Store Connect (iOS) ou Google Play Console (Android)
- [ ] ID do leaderboard correto na constante
- [ ] Pontuação já foi submetida pelo menos uma vez
- [ ] Dispositivo está autenticado com conta de developer/teste
- [ ] App está usando certificado correto (para iOS)
- [ ] SHA-1 correto configurado (para Android)

---

**Data da Atualização:** 26 de março de 2026  
**Status:** ✅ Melhorias implementadas para diagnosticar problema
