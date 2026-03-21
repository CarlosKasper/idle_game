# Guia de Configuração de Compras In-App na Apple Store

## Bundle ID

```
com.kasperlabs.companyIdle
```

## Produtos a Configurar

Todos os produtos devem ser configurados como **Consumíveis** (Consumable) ou **Não-Consumíveis** (Non-Consumable) conforme indicado abaixo.

### 1. Bônus de Renda (Consumíveis)

#### Multiplicador 2x

- **Product ID**: `com.kasperlabs.companyIdle.buff_income_x2`
- **Type**: Consumable
- **Price**: $0.99
- **Name**: Multiplicador 2x
- **Description**: +100% renda por 1 hora

#### Multiplicador 3x

- **Product ID**: `com.kasperlabs.companyIdle.buff_income_x3`
- **Type**: Consumable
- **Price**: $1.99
- **Name**: Multiplicador 3x
- **Description**: +200% renda por 2 horas

#### Multiplicador 5x

- **Product ID**: `com.kasperlabs.companyIdle.buff_income_x5`
- **Type**: Consumable
- **Price**: $4.99
- **Name**: Multiplicador 5x
- **Description**: +400% renda por 6 horas

### 2. Bônus de Cliques (Consumíveis)

#### Cliques 2x

- **Product ID**: `com.kasperlabs.companyIdle.buff_clicks_x2`
- **Type**: Consumable
- **Price**: $0.99
- **Name**: Cliques 2x
- **Description**: +100% dinheiro por clique por 30 min

### 3. Bônus Completo (Consumível)

#### Buff Completo

- **Product ID**: `com.kasperlabs.companyIdle.buff_all_in_one`
- **Type**: Consumable
- **Price**: $2.99
- **Name**: Buff Completo
- **Description**: +200% renda e cliques por 1 hora

### 4. Bônus de Dinheiro (Não-Consumível)

#### Bônus de Dinheiro $1000

- **Product ID**: `com.kasperlabs.companyIdle.money_bonus_1000`
- **Type**: Non-Consumable
- **Price**: $0.99
- **Name**: Bônus de Dinheiro
- **Description**: Receba $1.000 em dinheiro do jogo

### 5. Itens Premium (Não-Consumível)

#### Me torne CEO

- **Product ID**: `com.kasperlabs.companyIdle.become_ceo`
- **Type**: Non-Consumable
- **Price**: $49.99
- **Name**: Me torne CEO
- **Description**: Eu vou comprar essa empresa

## Instruções de Configuração

### No App Store Connect:

1. **Ir para**: App Store Connect > Seu App > In-App Purchases
2. **Clicar em**: "+ Criar um novo"
3. **Selecionar tipo**:
   - **Consumable** para: buff_income_x2, buff_income_x3, buff_income_x5, buff_clicks_x2, buff_all_in_one
   - **Non-Consumable** para: money_bonus_1000, become_ceo
4. **Preencher informações**:
   - Product ID (exatamente como acima - use UNDERSCORES, não hífens)
   - Nome legível
   - Descrição
   - Preço
5. **Salvar e submeter para review**

### ⚠️ IMPORTANTE - Regras do Product ID:

- ✅ Permitido: letras, números, pontos (.), underscores (\_)
- ❌ NÃO permitido: hífens (-), espaços, caracteres especiais

**Sempre use underscores no lugar de hífens!**

### Teste Antes de Publicar:

1. Usar **Sandbox Test Accounts** no TestFlight
2. A aplicação automaticamente usará o sandbox da Apple para testes
3. Os testes não cobram real money

## Código no Flutter

A integração está em `/lib/services/in_app_purchase_service.dart`:

- **Initialize**: Chama automaticamente no `ShopScreen.initState()`
- **Purchase**: `iapService.buyProduct(productId)`
- **Callback**: Implementar quando necessário tratar compra bem-sucedida

## Arquitetura

```
ShopScreen
├── InAppPurchaseService
│   ├── Gerencia produtos
│   ├── Processa compras
│   └── Persiste estado
└── GameService
    └── Aplica benefícios do produto
```

## Troubleshooting

Se os produtos não aparecerem:

1. ✅ Verificar se o Product ID está **exato** (use underscores, não hífens)
2. Aguardar até 24 horas para sincronização do App Store Connect
3. Verificar Bundle ID do app (`com.kasperlabs.companyIdle`)
4. Fazer logout e login novamente no App Store Connect

## Status dos Bônus

- ✅ Multiplicadores de renda (Consumíveis) - Se usados múltiplas vezes
- ✅ Multiplicadores de cliques (Consumíveis) - Se usados múltiplos
- ✅ Dinheiro bônus (Não-Consumível) - Compra única
- ✅ CEO Premium (Não-Consumível) - Compra única
