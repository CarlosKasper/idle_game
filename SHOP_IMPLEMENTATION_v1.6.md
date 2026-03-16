# 🛍️ Nova Tela de Loja - Substituição de Configurações

## Resumo das Mudanças

### ✅ Implementado

1. **Nova Tela de Loja** (`lib/screens/shop_screen.dart`)
   - 6 produtos disponíveis para compra com dinheiro real
   - Interface pixel-perfect com design consistente
   - Cada produto com emoji, nome, descrição e preço
   - Botão "COMPRAR" em cada item
   - Dialog de confirmação antes da compra

2. **Atualização do Root Screen** (`lib/screens/root_screen.dart`)
   - Substitui `SettingsScreen` por `ShopScreen` na página 4
   - Remove o botão de configurações do AppBar
   - Import da nova tela adicionado

3. **Atualização do Menu de Navegação** (`lib/widgets/ui_components.dart`)
   - Muda o ícone de ⚙️ (Settings) para 🛒 (Shopping Bag)
   - Muda o label de "Configurações" para "Loja"
   - Mantém a mesma posição (índice 4)

4. **Dependência Adicionada** (`pubspec.yaml`)
   - `in_app_purchase: ^0.14.5` para suportar compras in-app

## Produtos Disponíveis

| Emoji  | Nome              | Preço | Descrição                        |
| ------ | ----------------- | ----- | -------------------------------- |
| ⚡     | Multiplicador 2x  | $0.99 | +100% renda por 1 hora           |
| ⚡⚡   | Multiplicador 3x  | $1.99 | +200% renda por 2 horas          |
| ⚡⚡⚡ | Multiplicador 5x  | $4.99 | +400% renda por 6 horas          |
| 🖱️     | Cliques 2x        | $0.99 | +100% cliques por 30 min         |
| 🚀     | Buff Completo     | $2.99 | +200% renda e cliques por 1 hora |
| 💰     | Bônus de Dinheiro | $0.99 | Receba $1.000 em dinheiro        |

## Próximas Etapas

1. **Implementar In-App Purchase Real**
   - Configurar no Google Play Console
   - Configurar no Apple App Store Connect
   - Usar o package `in_app_purchase` para processar pagamentos

2. **Sistema de Buffs Temporários**
   - Criar modelo `ActiveBuff` com duração
   - Implementar timer para buffs em `GameService`
   - Mostrar buffs ativos na tela principal

3. **Persistência de Compras**
   - Salvar compras no `SaveService`
   - Rastrear histórico de compras
   - Validar com servidor (segurança)

4. **Analytics**
   - Rastrear tentativas de compra
   - Rastrear compras bem-sucedidas
   - Monitorar produtos mais vendidos

---

**Status: 🟢 Interface Completa - Pronta para integração de in-app purchase**
