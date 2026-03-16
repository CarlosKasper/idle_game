# 🎬 Anúncios (Rewarded Videos) - Loja v1.6

## ✅ Implementado

### Novos Produtos com Anúncios (Grátis!)

Adicionados 3 produtos que os jogadores podem destravar assistindo a anúncios:

| Produto                        | Descrição     | Duração    | Ganho  |
| ------------------------------ | ------------- | ---------- | ------ |
| 📺 Multiplicador 2x (Anúncio)  | +100% renda   | 30 min     | Grátis |
| 📺 Cliques 2x (Anúncio)        | +100% cliques | 20 min     | Grátis |
| 📺 Bônus de Dinheiro (Anúncio) | Ganhe $500    | Permanente | Grátis |

### Funcionalidades

1. **Produtos Diferenciados**
   - Produtos com anúncios mostram o emoji 📺
   - Preço aparece como "GRÁTIS"
   - Botão muda para "ASSISTIR" em vez de "COMPRAR"

2. **Fluxo de Anúncio**
   - Jogador clica "ASSISTIR"
   - Dialog de confirmação diferente para anúncios
   - Simula exibição do anúncio (3 segundos)
   - Após 3 segundos, benefício é aplicado

3. **Benefícios**
   - Multiplicadores temporários (30 min / 20 min)
   - Bônus de dinheiro ($500)
   - Sem limite de anúncios (diferente de in-app purchase)

### Arquitetura

**Classe ShopProduct** agora tem:

```dart
final bool isAdVideo; // Indica se é um produto com anúncio
```

**Métodos de Processamento**:

- `_showPurchaseDialog()` - Diferencia entre anúncio e compra
- `_processPurchase()` - Simula exibição de anúncio
- `_applyProductBenefit()` - Aplica o benefício ao jogador

### Próximas Etapas

Para produção, você precisará:

1. **Integrar com Google AdMob** (Android)

   ```dart
   import 'package:google_mobile_ads/google_mobile_ads.dart';
   ```

2. **Integrar com Facebook Audience Network** (opcional)

3. **Implementar Rewarded Ad Real**

   ```dart
   RewardedAd.load(
     adUnitId: 'ca-app-pub-xxxxxxxxxxxxxxxx/yyyyyyyyyy',
     // ... configurar anúncio
   );
   ```

4. **Adicionar Callback de Reward**
   - Aplicar benefício apenas após anúncio ser completado
   - Rastrear conclusão de anúncios

5. **Analytics**
   - Rastrear quantos anúncios foram assistidos
   - Monitorar taxa de conclusão
   - Rastrear benefícios ganhos

---

**Status: 🟢 Pronto para integração com Google AdMob**

A estrutura permite fácil integração com serviços reais de rewarded ads!
