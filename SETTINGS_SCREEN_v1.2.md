# ⚙️ Settings Screen - Office Idle v1.2

**Data**: 10 de Março de 2026  
**Status**: ✅ Implementado e testado  
**Testes**: 33/33 passando

---

## 📋 O Que É

A **Settings Screen** é uma tela dedicada para configurações do app. Ela oferece uma UI moderna e organizada com:

- 🎨 **Seleção de Tema** (Sistema/Claro/Escuro)
- 🔄 **Reset do Jogo** com confirmação
- ℹ️ **Informações do App**

---

## 🎯 Features

### 1. Seleção de Tema

Três opções com cards interativos:

```
┌─────────────────────────────────────┐
│ 🔄 Automático                       │
│ Segue a configuração do dispositivo │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│ ☀️ Modo Claro                        │
│ Tema claro com fundo branco        │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│ 🌙 Modo Escuro         ✓            │ ← Selecionado
│ Tema escuro com fundo preto        │
└─────────────────────────────────────┘
```

**Como funciona:**

1. User toca em um card
2. Tema é aplicado instantaneamente
3. Check mark aparece no card
4. Volta ao HomeScreen

### 2. Reset do Jogo

```
┌─────────────────────────────────────┐
│ 🔄 Resetar Jogo              →     │
│ Voltar ao início com dados apagados│
└─────────────────────────────────────┘
```

**Confirmação:**

```
┌──────────────────────────────────┐
│ Resetar Jogo?                    │
│                                  │
│ Tem certeza que deseja resetar?  │
│ Todos os dados serão apagados.   │
│                                  │
│ [Cancelar] [Resetar]            │
└──────────────────────────────────┘
```

### 3. Informações

```
Version: v1.2
Developed with: Flutter + Dart
```

---

## 🏗️ Arquitetura

### SettingsScreen (StatefulWidget)

```dart
class SettingsScreen extends StatefulWidget {
  final ThemeMode currentTheme;
  final Function(ThemeMode) onThemeChanged;

  // ...
}
```

**Props:**

- `currentTheme`: Tema selecionado atualmente
- `onThemeChanged`: Callback para mudar tema

**Métodos principais:**

- `_buildThemeCard()`: Constrói cada card de tema
- `_applyTheme()`: Aplica tema e notifica parent
- `_showResetConfirmation()`: Mostra diálogo de confirmação

---

## 🔗 Integração com HomeScreen

### Navegação

```dart
// HomeScreen
IconButton(
  icon: const Icon(Icons.settings),
  onPressed: () async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SettingsScreen(
          currentTheme: ThemeMode.system,
          onThemeChanged: widget.onThemeChanged ?? (_) {},
        ),
      ),
    );

    // Se voltou com 'reset'
    if (result == 'reset' && mounted) {
      await context.read<GameService>().resetGame();
    }
  },
)
```

### Fluxo

```
HomeScreen
    ↓ (click settings button)
Navigator.push()
    ↓
SettingsScreen
    ├─ User selects theme
    │  └─ onThemeChanged callback
    │     └─ MainApp updates themeMode
    │        └─ App rebuilds with new theme
    │
    └─ User clicks reset
       └─ SettingsScreen pops with 'reset'
          └─ HomeScreen handles reset
```

---

## 🎨 Design Details

### Theme Card

```dart
_buildThemeCard(
  context,
  mode: ThemeMode.dark,
  title: 'Modo Escuro',
  subtitle: 'Tema escuro com fundo preto',
  icon: Icons.brightness_4,
  isSelected: true,
)
```

**Features:**

- Icon com fundo colorido
- Título em negrito
- Subtitle descritivo
- Check mark se selecionado
- Border mais grossa se selecionado
- Fundo com cor primária se selecionado

### Colors

```
Selected Border:    Primary color
Unselected Border:  Colors.grey[300]

Selected Background: Primary color with 10% opacity
Unselected Background: Surface color

Icon Color: Primary color
Icon Background: Primary color with 15% opacity
```

---

## 📱 Responsividade

- ✅ Funciona em qualquer tamanho de tela
- ✅ ListView permite scroll em telas pequenas
- ✅ Cards adaptam ao width disponível
- ✅ Safe area respeitada

---

## 🔌 API

### Constructor

```dart
SettingsScreen({
  required ThemeMode currentTheme,
  required Function(ThemeMode) onThemeChanged,
})
```

### Callbacks

```dart
// Chamado quando user seleciona novo tema
onThemeChanged(ThemeMode.dark);

// SettingsScreen pode retornar valores
Navigator.pop(context, 'reset');  // Se reset foi confirmado
Navigator.pop(context);           // Se voltou normalmente
```

---

## 🎯 User Flow

### Caso 1: Mudar Tema

```
1. User abre Settings
2. Vê 3 cards de tema
3. Clica em "Modo Escuro"
4. App muda para dark mode
5. Check mark aparece
6. User volta (< button ou back)
```

### Caso 2: Resetar Jogo

```
1. User abre Settings
2. Clica em "Resetar Jogo"
3. Confirmação aparece
4. User clica "Resetar"
5. SettingsScreen retorna 'reset'
6. HomeScreen recebe 'reset'
7. GameService.resetGame() é chamado
8. User volta ao HomeScreen do zero
```

---

## 🛠️ Desenvolvimento

### Adicionar nova opção

```dart
// Em SettingsScreen.build()
Card(
  child: ListTile(
    leading: const Icon(Icons.volume_up),
    title: const Text('Som'),
    subtitle: const Text('Ativar/desativar sons'),
    trailing: Switch(
      value: true,
      onChanged: (value) {
        setState(() {
          // Update sound setting
        });
      },
    ),
  ),
)
```

### Adicionar nova seção

```dart
Padding(
  padding: const EdgeInsets.symmetric(vertical: 8.0),
  child: Text(
    'MINHA SEÇÃO',
    style: Theme.of(context).textTheme.labelLarge?.copyWith(
      color: Theme.of(context).colorScheme.primary,
      fontWeight: FontWeight.bold,
    ),
  ),
)
```

---

## 📊 Comparação com Modal

### Modal (v1.1)

```
❌ Mal aproveitamento de espaço
❌ SegmentedButton apertado
❌ Difícil de ler
❌ Sem espaço para mais opções
✅ Rápido de acessar
```

### SettingsScreen (v1.2)

```
✅ Espaço generoso
✅ Cards bem organizados
✅ Fácil de ler
✅ Espaço para crescimento
✅ UI moderna e bonita
✅ Seções claramente definidas
```

---

## 🚀 Futuras Melhorias

1. **Persistência**
   - Salvar tema em SharedPreferences
   - Carregar ao iniciar app

2. **Mais opções**
   - Som/Música (ativa/desativa)
   - Notificações
   - Idioma
   - Dificuldade

3. **Links**
   - Termos de Serviço
   - Política de Privacidade
   - Contato/Email
   - Rate app

4. **Animações**
   - Fade in/out ao entrar
   - Slide transition
   - Card selection animation

---

## 🐛 Troubleshooting

### Tema não muda quando volta

**Causa**: `onThemeChanged` não está sendo passado

**Solução**:

```dart
SettingsScreen(
  currentTheme: themeMode,
  onThemeChanged: (mode) {
    setState(() => _themeMode = mode);  // ✅ Necessário
  },
)
```

### Reset não funciona

**Causa**: HomeScreen não está tratando retorno

**Solução**:

```dart
final result = await Navigator.push(...);
if (result == 'reset' && mounted) {
  await context.read<GameService>().resetGame();  // ✅ Necessário
}
```

### Tema reverte ao voltar

**Causa**: App usando ThemeMode hardcoded

**Solução**: Usar `Theme.of(context)` sempre

---

## ✅ Checklist

- [x] SettingsScreen criada
- [x] Cards de tema implementados
- [x] onThemeChanged funcional
- [x] Reset com confirmação
- [x] Integrada com HomeScreen
- [x] Testes passando
- [x] Dark mode funcional
- [x] Documentação completa

---

**Status Final**: ✅ Production Ready  
**Versão**: v1.2  
**Release Date**: 2026-03-10
