# Como Testar Game Center no Seu Device iOS

## ✅ Agora Apenas iOS!

O código foi simplificado para usar **apenas iOS**. Android foi removido completamente.

## Pré-requisitos para Testar

### 1. **Apple Developer Account**

- Você precisa de uma conta Apple Developer ativa
- Necessário para provisionar o app no device

### 2. **Device iOS Real**

- ❌ Não funciona em simulator/emulador
- ✅ Funciona em iPhone/iPad real
- Seu device deve estar conectado ao computador

### 3. **Game Center Ativado no Device**

- Abra: Settings > [Seu Nome] > Game Center
- Verifique se está ativado
- Está logado com sua Apple ID

### 4. **Xcode Configurado**

- Xcode instalado
- Seu device registrado em "Devices and Simulators"

## Passo a Passo para Testar

### Passo 1: Preparar o Device

```bash
# 1. Conecte o device via USB
# 2. Confie no device (aparecerá prompt no iPhone)
# 3. No Xcode: Window > Devices and Simulators > conecte e confirme
```

### Passo 2: Compilar para o Device

```bash
cd /Users/carloseduardokasper/apps/idle_game

# Limpe builds anteriores
flutter clean

# Compile para device iOS
flutter run -v
```

Você vai ver algo como:

```
Launching lib/main.dart on [Device Name] in debug mode...
Xcode build done.
```

### Passo 3: Autorizar o App

Quando o app for instalado no device:

- Pode pedir permissões
- Game Center pode pedir para fazer login
- Confirme tudo

### Passo 4: Testar o Leaderboard

1. Abra o app no device
2. Faça alguns cliques (para gerar pontuação)
3. Vá para Estatísticas
4. Clique em "Placar"
5. Veja se o Game Center abre

## O Que Esperar

### ✅ Sucesso:

```
[GameCenterService] ✅ Autenticação bem-sucedida
[GameCenterService] ✅ Pontuação submetida: 1884
[GameCenterService] 📱 Tentando abrir leaderboard...
[GameCenterService] 🎮 Game Center Leaderboard ID: com.kasperlabs.companyIdle.money
[GameCenterService] ✅ Placar aberto com sucesso
```

E você verá a UI do Game Center abrindo com a tabela de pontuações.

### ❌ Se Não Abrir:

Verifique os logs para saber o motivo:

| Mensagem                       | Significado                | Solução                         |
| ------------------------------ | -------------------------- | ------------------------------- |
| `❌ Falha ao autenticar`       | Não conseguiu fazer login  | Verifique Game Center no device |
| `❌ Erro ao abrir placar: ...` | Leaderboard não encontrado | Verifique App Store Connect     |
| `🔄 Tentando reautenticar...`  | Primeira tentativa falhou  | Está tentando novamente         |

## App Store Connect - Verificar Leaderboard

Para que o leaderboard funcione, deve estar configurado:

1. Abra [App Store Connect](https://appstoreconnect.apple.com)
2. Vá em: **My Apps > Company Idle > Game Center**
3. Procure por leaderboard com ID: `com.kasperlabs.companyIdle.money`
4. Se não existe:
   - Clique em "+" para adicionar
   - Tipo: "Recurring" ou "Seasonal"
   - ID da referência: `com.kasperlabs.companyIdle.money`
   - Salve e ative

## Dicas Importantes

### 🎮 Game Center no Device

- Para abrir Game Center manualmente: Swipe down > Game Center
- Veja suas pontuações submetidas lá
- Verifique se está logado com a conta certa

### 🔄 Teste Múltiplos Cliques

Se o leaderboard parecer vazio:

- Submeta uma pontuação bem alta: `GameCenterService.submitScore(999999)`
- Aguarde alguns segundos
- Tente abrir o leaderboard novamente

### 📱 Device Real vs Simulator

- **Simulator:** Game Center não funciona bem
- **Device Real:** Game Center funciona perfeitamente
- **Recomendação:** Use sempre um device real para testar

### ⏰ Tempo de Propagação

Às vezes leva alguns minutos para:

- Pontuação aparecer no leaderboard
- Game Center reconhecer o app
- Configurações sincronizarem

Se não funcionar imediatamente, aguarde 2-3 minutos e tente novamente.

## Logs para Debug

Se tiver problemas, procure pelos logs:

```bash
# Veja logs em tempo real
flutter logs

# Ou com grep para filtrar Game Center
flutter logs | grep GameCenterService
```

## Se Ainda Não Funcionar

1. **Limpe tudo:**

   ```bash
   flutter clean
   rm -rf ios/Pods ios/Podfile.lock
   flutter pub get
   ```

2. **Tente novamente:**

   ```bash
   flutter run
   ```

3. **Reinicie o device:**
   - Desligue e ligue o iPhone
   - Tente novamente

4. **Verifique Certificados:**
   - Xcode > Preferences > Accounts
   - Selecione sua conta Apple
   - Clique "Manage Certificates..."
   - Verifique se há certificado válido

## Comando Rápido para Testar

```bash
cd /Users/carloseduardokasper/apps/idle_game
flutter clean
flutter pub get
flutter run -v
```

---

**📝 Nota:** Agora funciona apenas com iOS. Android foi removido.  
**✅ Status:** Pronto para testar no seu device!
