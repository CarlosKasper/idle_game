import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../services/game_service.dart';
import '../services/in_app_purchase_service.dart';
import '../services/purchase_state_service.dart';
import '../services/rewarded_ads_service.dart';
import '../models/money.dart';

// ─────────────────────────────────────────────────
// HELPER FUNCTION FOR LOCALIZED PRODUCT NAMES
// ─────────────────────────────────────────────────

String getLocalizedProductName(BuildContext context, String productId) {
  final l10n = AppLocalizations.of(context);

  switch (productId) {
    case 'ad_income_x2_30m':
      return l10n.multiplier2x;
    case 'ad_clicks_x2_20m':
      return l10n.clicks2x;
    case 'ad_money_bonus':
      return l10n.moneyBonus;
    case 'buff_income_x2':
      return l10n.multiplier2x;
    case 'buff_income_x3':
      return l10n.multiplier3x;
    case 'buff_income_x5':
      return l10n.multiplier5x;
    case 'buff_clicks_x2':
      return l10n.clicks2x;
    case 'buff_all_in_one':
      return l10n.buffAllInOne;
    case 'money_bonus_1000':
      return l10n.moneyBonus;
    case 'become_ceo':
      return l10n.becomeCEO;
    default:
      return productId;
  }
}

String getLocalizedProductDescription(BuildContext context, String productId) {
  final l10n = AppLocalizations.of(context);

  switch (productId) {
    case 'ad_income_x2_30m':
      return l10n.multiplier2xDesc;
    case 'ad_clicks_x2_20m':
      return l10n.clicks2xDesc;
    case 'ad_money_bonus':
      return l10n.moneyBonusDesc;
    case 'buff_income_x2':
      return l10n.multiplier2xDesc;
    case 'buff_income_x3':
      return l10n.multiplier3xDesc;
    case 'buff_income_x5':
      return l10n.multiplier5xDesc;
    case 'buff_clicks_x2':
      return l10n.clicks2xDesc;
    case 'buff_all_in_one':
      return l10n.buffAllInOneDesc;
    case 'money_bonus_1000':
      return l10n.moneyBonusDesc;
    case 'become_ceo':
      return l10n.becomeCEODesc;
    default:
      return productId;
  }
}

String getLocalizedDuration(BuildContext context, String duration) {
  final l10n = AppLocalizations.of(context);

  switch (duration.toLowerCase()) {
    case '1 hora':
    case '1 hour':
      return l10n.oneHour;
    case '2 horas':
    case '2 hours':
      return l10n.twoHours;
    case '6 horas':
    case '6 hours':
      return l10n.sixHours;
    case '30 min':
      return l10n.thirtyMin;
    case '20 min':
      return '20 min';
    case 'permanente':
    case 'permanent':
      return l10n.permanent;
    default:
      return duration;
  }
}

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  late InAppPurchaseService _iapService;
  late PurchaseStateService _purchaseStateService;
  bool _showingSuccessModal = false; // Guard para evitar modals duplicadas
  bool _showProcessingOverlay =
      false; // Controla visibilidade do overlay de processamento

  @override
  void initState() {
    super.initState();
    _iapService = InAppPurchaseService();
    _purchaseStateService = context.read<PurchaseStateService>();

    // Inicializar IAP
    _iapService.initialize();

    // Configurar callback para quando uma compra IAP é completada
    _iapService.setOnPurchaseCompleted((productId) {
      _handleIAPPurchaseComplete(productId);
    });
  }

  /// Chamado quando uma compra IAP é completada com sucesso
  void _handleIAPPurchaseComplete(String productId) {
    debugPrint('[ShopScreen] Compra IAP concluída: $productId');

    if (!mounted || _showingSuccessModal)
      return; // Guard contra modals duplicadas

    final gameService = context.read<GameService>();

    // Encontrar o produto que foi comprado
    ShopProduct? purchasedProduct;
    for (final product in products) {
      if (product.iapProductId == productId) {
        purchasedProduct = product;
        break;
      }
    }

    if (purchasedProduct != null) {
      debugPrint(
        '[ShopScreen] Aplicando benefício: ${getLocalizedProductName(context, purchasedProduct.id)}',
      );
      _applyProductBenefit(purchasedProduct, gameService);

      // Mostrar modal de sucesso bloqueando a interação
      _showSuccessModal(purchasedProduct);
    }
  }

  /// Mostra modal de sucesso da compra (bloqueia interação até fechar)
  void _showSuccessModal(ShopProduct product) {
    _showingSuccessModal = true;

    String statusText =
        '✅ ${getLocalizedProductName(context, product.id)} ativado! ${product.emoji}';

    // Adicionar informação de duração se for bônus temporal
    if (product.id.startsWith('buff_')) {
      statusText += '\n${getLocalizedDuration(context, product.duration)}';
    }

    showDialog(
      context: context,
      barrierDismissible: false, // Não pode fechar clicando fora
      barrierColor: Colors.black.withOpacity(
        0.8,
      ), // Barrier mais escuro e opaco
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false, // Bloqueia botão de voltar
          child: AlertDialog(
            backgroundColor: const Color(0xFF141418),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: Color(0xFF4ADE80), width: 2),
            ),
            title: Text(
              AppLocalizations.of(context).purchaseSuccessful,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 14,
                color: const Color(0xFF4ADE80),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            content: Text(
              statusText,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 12,
                color: Colors.white70,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    _showingSuccessModal = false;
                    Navigator.of(context).pop();
                    _purchaseStateService.setPurchasing(false);
                    setState(() {
                      _showProcessingOverlay = false;
                    });
                    _hideSnackBar(); // Remove SnackBar de processamento
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF4ADE80),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    'OK',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 12,
                      color: const Color(0xFF0A0A0F),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Aplica o benefício do produto comprado
  void _applyProductBenefit(ShopProduct product, GameService gameService) {
    if (product.id == 'buff_income_x2') {
      gameService.activateIncomeBonus(
        product.id,
        getLocalizedProductName(context, product.id),
        1.0, // 100% bonus
        const Duration(hours: 1),
        product.emoji,
      );
    } else if (product.id == 'buff_income_x3') {
      gameService.activateIncomeBonus(
        product.id,
        getLocalizedProductName(context, product.id),
        2.0, // 200% bonus
        const Duration(hours: 2),
        product.emoji,
      );
    } else if (product.id == 'buff_income_x5') {
      gameService.activateIncomeBonus(
        product.id,
        getLocalizedProductName(context, product.id),
        4.0, // 400% bonus
        const Duration(hours: 6),
        product.emoji,
      );
    } else if (product.id == 'buff_clicks_x2') {
      gameService.activateClickBonus(
        product.id,
        getLocalizedProductName(context, product.id),
        1.0, // 100% bonus
        const Duration(minutes: 30),
        product.emoji,
      );
    } else if (product.id == 'buff_all_in_one') {
      // Ativar ambos os bônus
      gameService.activateIncomeBonus(
        '${product.id}_income',
        '${getLocalizedProductName(context, product.id)} (Renda)',
        2.0, // 200% bonus
        const Duration(hours: 1),
        product.emoji,
      );
      gameService.activateClickBonus(
        '${product.id}_clicks',
        '${getLocalizedProductName(context, product.id)} (Cliques)',
        2.0, // 200% bonus
        const Duration(hours: 1),
        product.emoji,
      );
    } else if (product.id == 'money_bonus_1000') {
      gameService.state.money = gameService.state.money + Money(1000);
    } else if (product.id == 'ad_money_bonus') {
      gameService.state.money = gameService.state.money + Money(500);
    } else if (product.id == 'become_ceo') {
      gameService.becomeCEO();
    }
  }

  /// Define o estado de processamento de compra
  void setPurchasing(bool value) {
    _purchaseStateService.setPurchasing(value);
  }

  /// Mostra/esconde o overlay de processamento
  void setShowProcessingOverlay(bool value) {
    setState(() {
      _showProcessingOverlay = value;
    });
  }

  /// Remove o SnackBar
  void _hideSnackBar() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  @override
  void dispose() {
    // Não dispose do InAppPurchaseService pois é um singleton
    // que persiste para toda a aplicação
    super.dispose();
  }

  // Simulação de produtos que poderiam ser oferecidos via in-app purchase
  // Em produção, isso viria do Google Play/App Store
  final List<ShopProduct> products = [
    // ═══════════════════════════════════════════════════════════════════
    // PRODUTOS COM ANÚNCIOS (FREE)
    // ═══════════════════════════════════════════════════════════════════
    ShopProduct(
      id: 'ad_income_x2_30m',
      name: 'Multiplicador 2x (Anúncio)',
      description: '+100% renda por 30 min (assistindo anúncio)',
      emoji: '🎬',
      price: 'FREE',
      duration: '30 min',
      bonus: 1.0,
      isAdVideo: true,
      adUnitId: 'ca-app-pub-3940256099942544/1712485313',
    ),
    ShopProduct(
      id: 'ad_clicks_x2_20m',
      name: 'Cliques 2x (Anúncio)',
      description: '+100% dinheiro por clique por 20 min (assistindo anúncio)',
      emoji: '🎬',
      price: 'FREE',
      duration: '20 min',
      bonus: 1.0,
      isAdVideo: true,
      adUnitId: 'ca-app-pub-3940256099942544/1712485313',
    ),
    ShopProduct(
      id: 'ad_money_bonus',
      name: 'Bônus de Dinheiro (Anúncio)',
      description: 'Ganhe \$500 (assistindo anúncio)',
      emoji: '🎬',
      price: 'FREE',
      duration: 'Permanente',
      bonus: 0.0,
      isAdVideo: true,
      adUnitId: 'ca-app-pub-3940256099942544/1712485313',
    ),
    ShopProduct(
      id: 'buff_income_x2',
      name: 'Multiplicador 2x',
      description: '+100% renda por 1 hora',
      emoji: '⚡',
      price: '\$0.29',
      duration: '1 hora',
      bonus: 1.0, // 100% bonus
      iapProductId: 'com.kasperlabs.companyIdle.buff_income_x2',
    ),
    ShopProduct(
      id: 'buff_income_x3',
      name: 'Multiplicador 3x',
      description: '+200% renda por 2 horas',
      emoji: '⚡',
      price: '\$0.39',
      duration: '2 horas',
      bonus: 2.0, // 200% bonus
      iapProductId: 'com.kasperlabs.companyIdle.buff_income_x3',
    ),
    ShopProduct(
      id: 'buff_income_x5',
      name: 'Multiplicador 5x',
      description: '+400% renda por 6 horas',
      emoji: '⚡',
      price: '\$0.39',
      duration: '6 horas',
      bonus: 4.0, // 400% bonus
      iapProductId: 'com.kasperlabs.companyIdle.buff_income_x5',
    ),
    ShopProduct(
      id: 'buff_clicks_x2',
      name: 'Cliques 2x',
      description: '+100% dinheiro por clique por 30 min',
      emoji: '🖱️',
      price: '\$0.29',
      duration: '30 min',
      bonus: 1.0,
      iapProductId: 'com.kasperlabs.companyIdle.buff_clicks_x2',
    ),
    ShopProduct(
      id: 'buff_all_in_one',
      name: 'Buff Completo',
      description: '+200% renda e cliques por 1 hora',
      emoji: '🚀',
      price: '\$0.39',
      duration: '1 hora',
      bonus: 2.0,
      iapProductId: 'com.kasperlabs.companyIdle.buff_all_in_one',
    ),
    ShopProduct(
      id: 'money_bonus_1000',
      name: 'Bônus de Dinheiro',
      description: 'Receba \$1.000 em dinheiro do jogo',
      emoji: '💰',
      price: '\$0.29',
      duration: 'Permanente',
      bonus: 0.0, // Não é um multiplicador, é dinheiro direto
      iapProductId: 'com.kasperlabs.companyIdle.money_bonus_1000',
      isNonConsumable: false,
    ),
    ShopProduct(
      id: 'become_ceo',
      name: 'Me torne CEO',
      description: 'Eu vou comprar essa empresa',
      emoji: '👑',
      price: '\$29.99',
      duration: 'Permanente',
      bonus: 0.0,
      iapProductId: 'com.kasperlabs.companyIdle.become_ceo',
      isNonConsumable: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _ScreenHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Buffs & Recompensas',
                          style: GoogleFonts.silkscreen(
                            fontSize: 14,
                            color: Colors.white54,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...products.map(
                          (product) => Column(
                            children: [
                              _ShopProductCard(
                                product: product,
                                iapService: _iapService,
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1A20),
                            border: Border.all(
                              color: Colors.orange.withOpacity(0.3),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ℹ️ Informação',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 12,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Compre buffs com dinheiro real para potencializar seu progresso!',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 10,
                                  color: Colors.white54,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Overlay de bloqueio quando compra está sendo processada
          if (_showProcessingOverlay)
            Container(
              color: Colors.black.withOpacity(0.6),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF4ADE80),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Processando compra...',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 14,
                        color: const Color(0xFF4ADE80),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ScreenHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF141418),
        border: Border(bottom: BorderSide(color: Color(0xFF2A2A30), width: 2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text('🛍️', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Text(
                AppLocalizations.of(context).shopTitle,
                style: GoogleFonts.silkscreen(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ShopProductCard extends StatelessWidget {
  final ShopProduct product;
  final InAppPurchaseService iapService;

  const _ShopProductCard({required this.product, required this.iapService});

  @override
  Widget build(BuildContext context) {
    final gameService = context.read<GameService>();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF141418),
        border: Border.all(color: const Color(0xFF2A2A30), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Emoji
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A20),
              border: Border.all(color: const Color(0xFF2A2A30), width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(product.emoji, style: const TextStyle(fontSize: 32)),
            ),
          ),
          const SizedBox(width: 12),

          // Informações do produto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getLocalizedProductName(context, product.id),
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  getLocalizedProductDescription(context, product.id),
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 9,
                    color: Colors.white54,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A30),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        getLocalizedDuration(context, product.duration),
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 8,
                          color: Colors.white38,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Botão de compra / Restore
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                product.price,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 12,
                  color: const Color(0xFF4ADE80),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              // Mostrar dois botões se for não-consumível (restore + comprar)
              if (product.isNonConsumable && product.iapProductId != null)
                Row(
                  children: [
                    // Botão Restaurar
                    GestureDetector(
                      onTap: () {
                        iapService.restorePurchases();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '🔄 Restaurando compras... ${product.emoji}',
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4A7C7E),
                          border: Border.all(
                            color: const Color(0xFF4A7C7E),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'RESTAURAR',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 7,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    // Botão Comprar
                    GestureDetector(
                      onTap: () {
                        _showPurchaseDialog(context, product, gameService);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4ADE80),
                          border: Border.all(
                            color: const Color(0xFF4ADE80),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          AppLocalizations.of(context).buyButton,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 7,
                            color: const Color(0xFF0A0A0F),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              else
                // Botão único para outros produtos
                GestureDetector(
                  onTap: () {
                    _showPurchaseDialog(context, product, gameService);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4ADE80),
                      border: Border.all(
                        color: const Color(0xFF4ADE80),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      product.isAdVideo
                          ? AppLocalizations.of(context).watchButton
                          : AppLocalizations.of(context).buyButton,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 8,
                        color: const Color(0xFF0A0A0F),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showPurchaseDialog(
    BuildContext context,
    ShopProduct product,
    GameService gameService,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF141418),
          title: Text(
            getLocalizedProductName(context, product.id),
            style: GoogleFonts.jetBrainsMono(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            product.isAdVideo
                ? AppLocalizations.of(context).watchAd
                : '${AppLocalizations.of(context).buyFor} ${product.price}?',
            style: GoogleFonts.jetBrainsMono(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context).cancel),
            ),
            TextButton(
              onPressed: () {
                _processPurchase(context, product, gameService);
              },
              child: Text(
                product.isAdVideo
                    ? AppLocalizations.of(context).watch
                    : AppLocalizations.of(context).confirm,
                style: TextStyle(color: const Color(0xFF4ADE80)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _processPurchase(
    BuildContext context,
    ShopProduct product,
    GameService gameService,
  ) {
    Navigator.pop(context);

    if (product.isAdVideo) {
      final adUnitId = product.adUnitId;
      if (adUnitId == null || adUnitId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('⚠️ Ad unit id não configurado.'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🎬 Carregando anúncio... ${product.emoji}'),
          duration: const Duration(seconds: 2),
        ),
      );

      RewardedAdsService.instance.show(
        adUnitId: adUnitId,
        onRewarded: () {
          _applyProductBenefit(context, product, gameService);
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '✅ ${getLocalizedProductName(context, product.id)} ativado! ${product.emoji}',
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        onFailed: (msg) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ $msg'),
              duration: const Duration(seconds: 2),
            ),
          );
        },
      );
    } else if (product.iapProductId != null) {
      // Compra via Apple Store - marca início do processamento
      final shopScreenState = context
          .findAncestorStateOfType<_ShopScreenState>();
      shopScreenState?.setPurchasing(true);
      shopScreenState?.setShowProcessingOverlay(true);

      // Mostrar SnackBar que persiste até a modal ser fechada
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🛒 Processando pagamento... ${product.emoji}'),
          duration: const Duration(minutes: 5), // Persiste até fechar modal
          backgroundColor: const Color(0xFF1A1A20),
        ),
      );

      iapService.buyProduct(product.iapProductId!);
    } else {
      // Compra com dinheiro real (fallback)

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${getLocalizedProductName(context, product.id)} ativado! ${product.emoji}',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      _applyProductBenefit(context, product, gameService);
    }
  }

  void _applyProductBenefit(
    BuildContext context,
    ShopProduct product,
    GameService gameService,
  ) {
    // Aplicar o benefício do produto
    if (product.id == 'money_bonus_1000') {
      // Adiciona $1000
      gameService.state.money = gameService.state.money + Money(1000);
    } else if (product.id == 'ad_income_x2_30m') {
      gameService.activateIncomeBonus(
        product.id,
        getLocalizedProductName(context, product.id),
        1.0,
        const Duration(minutes: 30),
        product.emoji,
      );
    } else if (product.id == 'ad_clicks_x2_20m') {
      gameService.activateClickBonus(
        product.id,
        getLocalizedProductName(context, product.id),
        1.0,
        const Duration(minutes: 20),
        product.emoji,
      );
    } else if (product.id == 'ad_money_bonus') {
      // Adiciona $500
      gameService.state.money = gameService.state.money + Money(500);
    } else if (product.id == 'become_ceo') {
      // Tornar o jogador um CEO
      gameService.becomeCEO();
    }
  }
}

class ShopProduct {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final String price;
  final String duration;
  final double bonus;
  final bool isAdVideo;
  final String? adUnitId; // ID do anúncio no Google AdMob
  final String? iapProductId; // ID do produto na Apple Store
  final bool isNonConsumable; // true = não-consumível

  ShopProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.price,
    required this.duration,
    required this.bonus,
    this.isAdVideo = false,
    this.adUnitId,
    this.iapProductId,
    this.isNonConsumable = false,
  });
}
