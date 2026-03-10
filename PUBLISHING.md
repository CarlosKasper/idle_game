# Guia de Publicação - Office Idle

Instruções passo-a-passo para publicar o jogo na Google Play e App Store.

## 📋 Pré-Requisitos

### Geral

- [ ] Google Play Developer Account ($25 USD one-time)
- [ ] Apple Developer Program ($99 USD/year)
- [ ] Flutter 3.11+ instalado
- [ ] Xcode 14+ (macOS/iOS)
- [ ] Android Studio (Android)
- [ ] Git para versionamento

### Preparação do Jogo

- [ ] v1.0 testado completamente
- [ ] Sem crashes ou bugs críticos
- [ ] Analytics implementado
- [ ] Privacy Policy pronto
- [ ] Ícones em alta resolução

## 🎨 Preparando Assets

### Ícone do Jogo

Criar em 1024x1024px (PNG):

```
1. Abrir design tool (Figma, Illustrator)
2. Criar ícone corporativo com tema azul (#1565C0)
3. Adicionar emoji/símbolo (💼 ou 💰)
4. Exportar em:
   - 1024x1024 (Play Store)
   - 192x192 (Android)
   - 128x128 (iOS)
```

Colocar em:

```
android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png
ios/Runner/Assets.xcassets/AppIcon.appiconset/
```

### Screenshots

Criar 4-5 screenshots em 1280x720 (portrait):

1. Tela inicial com UI bonita
2. Carreira progredindo
3. Upgrades sendo comprados
4. Estatísticas sendo mostradas
5. (Opcional) Humor corporativo

## 📱 Build Android

### 1. Configurar Assinatura

Criar keystore (uma única vez):

```bash
keytool -genkey -v -keystore ~/idle_game.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias idle_game_key
```

Será solicitado:

- First and last name: (Seu Nome)
- Organizational Unit: (Engineering)
- Organization: (Sua Empresa)
- City: (Sua Cidade)
- State: (UF)
- Country Code: BR
- Password: (guardar em local seguro!)

### 2. Configurar Gradle

Criar `android/key.properties`:

```properties
storePassword=<password do keystore>
keyPassword=<password da key>
keyAlias=idle_game_key
storeFile=/Users/username/idle_game.jks
```

Modificar `android/app/build.gradle`:

```gradle
android {
    compileSdkVersion 34

    signingConfigs {
        release {
            keyAlias System.getenv("KEY_ALIAS") ?: keyProperties['keyAlias']
            keyPassword System.getenv("KEY_PASSWORD") ?: keyProperties['keyPassword']
            storeFile System.getenv("KEYSTORE_PATH") ? new File(System.getenv("KEYSTORE_PATH")) : new File(keyProperties['storeFile'])
            storePassword System.getenv("STORE_PASSWORD") ?: keyProperties['storePassword']
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### 3. Atualizar Versão

Em `pubspec.yaml`:

```yaml
version: 1.0.0+1 # 1.0.0 = version, +1 = build number
```

Em `android/app/build.gradle`:

```gradle
defaultConfig {
    applicationId "com.seu_dominio.idle_game"  // Ex: com.carloskasper.office_idle
    minSdkVersion 21  // Android 5.0+
    targetSdkVersion 34
    versionCode 1
    versionName "1.0.0"
}
```

### 4. Gerar APK/Bundle

```bash
# APK (para testes)
flutter build apk --release

# App Bundle (para Google Play - recomendado)
flutter build appbundle --release

# Arquivo gerado em:
# build/app/outputs/bundle/release/app-release.aab
# ou
# build/app/outputs/apk/release/app-release.apk
```

## 🍎 Build iOS

### 1. Configurar Certificados

```bash
# Abrir Xcode para setup automático
open ios/Runner.xcworkspace

# Em Xcode:
# - Runner → Signing & Capabilities
# - Marcar "Automatically manage signing"
# - Selecionar Team
```

### 2. Atualizar Info

Em `ios/Runner/Info.plist`:

```xml
<dict>
    <key>CFBundleName</key>
    <string>Office Idle</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    ...
</dict>
```

### 3. Gerar Build

```bash
# Build para App Store
flutter build ios --release

# Arquivo gerado em:
# build/ios/iphoneos/Runner.app
```

Depois publicar via Xcode ou Transporter.

## 📱 Google Play Console

### 1. Criar Aplicação

1. Acessar [Google Play Console](https://play.google.com/console)
2. Clique em "Create App"
3. Nome: "Office Idle"
4. Categoria: "Games → Casual"
5. Tipo de app: "Games"

### 2. Adicionar Informações

**Store Listing:**

- Título: "Office Idle - Clicker Game"
- Descrição curta: "Climb the corporate ladder one click at a time!"
- Descrição completa:

  ```
  Office Idle is a relaxing clicker game where you work your way
  up from intern to CEO. Click to earn money, buy upgrades, and
  watch your income grow exponentially!

  Features:
  - Click to earn or let passive income do the work
  - 6 career levels from Intern to CEO
  - 5 unique upgrades with synergy
  - Automatic saving
  - Offline rewards (coming in v2!)

  Perfect for short gaming sessions or AFK gameplay.
  ```

**Conteúdo do App:**

- Rating: 3+ (ESRB) / 3+ (PEGI)
- Content rating: Não há conteúdo impróprio
- Privacidade: Marcar "This app does NOT collect personal data"

**Preço e Distribuição:**

- Tipo: Grátis
- Países: Selecionar todos (ou específicos)
- Conteúdo comercial: Marcar "Contains ads" (para v2+ com AdMob)

### 3. Versão de Lançamento

1. Menu esquerdo → "Release" → "Production"
2. Clique em "Create new release"
3. Upload do AAB (bundle Android)
4. Review do jogo (~2-4 horas)

## 🍎 App Store Connect

### 1. Criar App

1. Acessar [App Store Connect](https://appstoreconnect.apple.com)
2. "My Apps" → "+"
3. Nome: "Office Idle"
4. Categoria primária: "Games"
5. Subcategoria: "Casual Games"

### 2. Adicionar Informações

**App Store Metadata:**

- Descrição: (similar ao Google Play)
- Suporte:
  - URL: (seu site ou GitHub)
  - Email: (seu email)
- Privacidade:
  - URL da Privacy Policy
  - Data de Contato

**Classificação:**

- Sem conteúdo de risco
- Marcar "Does Not Require Kids Category"

### 3. Versão de Lançamento

1. Menu esquerdo → "TestFlight" (teste interno)
2. Upload do build iOS
3. Testar em múltiplos devices
4. "Prepare for Submission" quando pronto
5. App Review (~24-48 horas)

## 🔒 Privacy Policy

Criar em [terms.iubenda.com](https://www.iubenda.com):

Pontos importantes:

- Dados coletados: Apenas analytics (playtime, events)
- Ads: Informar sobre Google AdMob (v2+)
- Redes sociais: Nenhuma integração
- Compartilhamento: Não compartilhamos dados
- Retenção: Local storage apenas, sem servidor

Salvar em:

- Seu site: `/privacy-policy`
- E referenciar na Play Store e App Store

## ✅ Checklist Pré-Lançamento

### Código

- [ ] Todos os testes passam (`flutter test`)
- [ ] Sem warnings de análise (`flutter analyze`)
- [ ] Sem console errors
- [ ] Performance teste: 60fps em idle
- [ ] Memory não vaza (teste 1+ hora)

### UX/Design

- [ ] Todas as screens responsivas
- [ ] Sem text overflow
- [ ] Icons visíveis e claros
- [ ] Dark mode testado (se suportado)
- [ ] Sem hardcoded strings (i18n ready)

### Assets

- [ ] Ícone do app em alta res
- [ ] Screenshots bonitas (4-5)
- [ ] Feature graphic (1024x500) para Play Store
- [ ] App Preview video (opcional)

### Legal

- [ ] Privacy Policy pronto
- [ ] Terms of Service pronto (se necessário)
- [ ] Licenças de dependências listadas
- [ ] Não há conteúdo copyrighted

### Build

- [ ] Versão incrementada (`version: 1.0.0+1`)
- [ ] Ícone gerado para Android e iOS
- [ ] Assinatura do keystore configurada
- [ ] Build release roda sem erros
- [ ] Build é menor que 100MB

## 🚀 Após Publicação

### Dia 1

- [ ] Monitorar crash reports
- [ ] Responder reviews negativos
- [ ] Incrementar downloads manual

### Semana 1

- [ ] Ajustar balanceamento baseado em analytics
- [ ] Implementar fixes de bugs reportados
- [ ] Preparar v1.1 (hotfix)

### Semana 2-4

- [ ] Começar implementação v2.0
- [ ] Integrar AdMob
- [ ] Adicionar mais upgrades

## 📊 Métricas para Monitorar

Google Play Console e Firebase:

```
DAU (Daily Active Users)
MAU (Monthly Active Users)
Retention: 1-day, 7-day, 30-day
Crash Rate: < 1%
Average Session: 15-30 minutos
Rating: Target 4.0+
Reviews: Responder todas
```

## 💡 Dicas Finais

1. **Beta Primeiro**: Use TestFlight (iOS) ou Open Testing (Android) antes de produção
2. **Localização**: Se possível, adicione português (PT-BR) em v1.1
3. **Monetização**: AdMob em v2.0, não force em v1.0
4. **Community**: Responda reviews, crie Discord/subreddit
5. **Updates**: Lançar atualizações regularmente (mensais)

## 🔗 Links Úteis

- [Flutter Build Guide](https://flutter.dev/docs/deployment/android)
- [Google Play Console](https://play.google.com/console)
- [App Store Connect](https://appstoreconnect.apple.com)
- [Firebase Console](https://console.firebase.google.com)
- [Privacy Policy Generator](https://www.iubenda.com)

---

**Estimado**:

- Preparação: 2-3 dias
- Build + Test: 1 dia
- Submissão: 30 minutos
- Aprovação: 1-2 dias (Google Play), 1-3 dias (App Store)
- **Total**: ~1 semana até primeira publicação ✅

Boa sorte no lançamento! 🚀
