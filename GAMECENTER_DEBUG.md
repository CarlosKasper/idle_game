# Debug e Correção do Game Center Leaderboard

## Problema Encontrado

⚠️ **`showLeaderboard()` retorna "sucesso" mas a UI não abre**

Mensagens de log:

```
[GameCenterService] Placar aberto com sucesso
[GameCenterService] Pontuação submetida: 1884
```

Mas nenhuma tela é exibida.

## Causas Possíveis

1. **Função não estava sendo aguardada** - `await` faltando na chamada
2. **Exceção silenciosa** - Erro ocorre mas é capturado
3. **ID do leaderboard inválido** - Leaderboard não existe na plataforma
4. **Permissões não concedidas** - App não tem permissão para acessar Game Center
5. **Leaderboard vazio** - Nenhuma pontuação no leaderboard

## Correções Implementadas

### 1. Agora Usando `await` em stats_screen.dart

**Antes:**

```dart
void _viewRanking(BuildContext context) {
  GameCenterService.showLeaderboard();  // ❌ Não aguarda
}
```

**Depois:**

```dart
void _viewRanking(BuildContext context) async {
  await GameCenterService.showLeaderboard();  // ✅ Aguarda
}
```

### 2. Logs Detalhados em GameCenterService

Agora exibe:

- IDs dos leaderboards sendo usados
- Tipo de erro específico
- Mensagens de tentativa de recuperação

```dart
print('[GameCenterService] Tentando abrir leaderboard...');
print('[GameCenterService] iOS ID: $_iOSLeaderboardId');
print('[GameCenterService] Android ID: $_androidLeaderboardId');
```

### 3. Tentativa Automática de Recuperação

Se falhar na primeira vez, tenta:

1. Reautenticar (`resignIn()`)
2. Tentar abrir novamente

```dart
print('[GameCenterService] Tentando reautenticar e abrir novamente...');
await resignIn();

if (_isAuthenticated) {
  try {
    await GamesServices.showLeaderboards(...);
    print('[GameCenterService] Placar aberto com sucesso (segunda tentativa)');
  } catch (e2) {
    print('[GameCenterService] Erro novamente ao abrir placar: $e2');
  }
}
```

## Como Diagnosticar

Veja os logs e procure por:

### ✅ Sucesso (esperado):

```
[GameCenterService] iOS ID: com.kasperlabs.companyIdle.money
[GameCenterService] Android ID: CgkI6LT5luoVEAIQAA
[GameCenterService] Placar aberto com sucesso
```

### ❌ Erro - Precisa Investigar:

**"Placar aberto com sucesso" mas nada aparece:**

- Pode ser bug do device/SO
- Tente fechar e reabrir app
- Tente em outro device

**Erro "Platform Exception":**

- ID do leaderboard pode estar errado
- Leaderboard não está configurado na plataforma

**Erro "Authentication":**

- Usuário não conseguiu autenticar
- Tente fazer login manualmente

**Erro "Not found":**

- Leaderboard não existe
- Verifique App Store Connect ou Google Play Console

## Próximos Passos para Resolver

### Se está no iOS:

1. **Verificar Game Center no device:**
   - Abra Configurações > Game Center
   - Verifique se está logado com uma conta
   - Tente logout e login novamente

2. **Verificar App Store Connect:**

   ```
   App Store Connect > My Apps > Company Idle > Game Center
   ```

   - Deve ter um leaderboard com ID: `com.kasperlabs.companyIdle.money`
   - Status deve estar "Active"
   - Deve ter pelo menos uma pontuação submetida

3. **Testar Reset:**
   - Delete app do device
   - Rebuild e instale novamente
   - Tente abrir leaderboard

### Se está no Android:

1. **Verificar Google Play Console:**

   ```
   Google Play Console > Company Idle > Play Games Services
   ```

   - Deve ter um leaderboard com ID: `CgkI6LT5luoVEAIQAA`
   - Leaderboard deve estar publicado

2. **Verificar Assinatura:**
   - SHA-1 da assinatura deve estar correto
   - Se trocou a assinatura, precisa atualizar no Console

3. **Testar em Device Real:**
   - Google Play Games funciona melhor em device real
   - Emulador pode ter limitações

## Informações de Debug

Execute este código para ver mais detalhes:

```dart
// No console do app
print('Autenticado: ${GameCenterService.isAuthenticated}');

// Submeta uma pontuação de teste
await GameCenterService.submitScore(99999);

// Espere 2 segundos
await Future.delayed(Duration(seconds: 2));

// Tente abrir
await GameCenterService.showLeaderboard();
```

Verifique os logs e procure por mensagens informativas.

## Teste com Outro ID (Experimental)

Se suspeitar que o ID está errado, pode tentar:

1. Criar um novo leaderboard com um ID diferente
2. Atualizar as constantes:
   ```dart
   static const String _iOSLeaderboardId = 'novo.id.aqui';
   static const String _androidLeaderboardId = 'NovoIDAndroid';
   ```
3. Recompilar e testar

## Checklist Final

- [ ] Device tem conta Game Center/Google Play Games ativa
- [ ] App foi rebuild e reinstalado
- [ ] Leaderboard existe na plataforma
- [ ] Pelo menos uma pontuação foi submetida
- [ ] Logs mostram "Placar aberto com sucesso"
- [ ] Tentou fechar e reabrir app
- [ ] Tentou em device real (não emulador)

---

**Data:** 26 de março de 2026  
**Status:** ✅ Melhorias de debug implementadas
