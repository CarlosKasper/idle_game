import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/game_service.dart';
import '../services/in_app_purchase_service.dart';
import '../services/purchase_state_service.dart';
import '../models/money.dart';

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
      debugPrint('[ShopScreen] Aplicando benefício: ${purchasedProduct.name}');
      _applyProductBenefit(purchasedProduct, gameService);

      // Mostrar modal de sucesso bloqueando a interação
      _showSuccessModal(purchasedProduct);
    }
  }

  /// Mostra modal de sucesso da compra (bloqueia interação até fechar)
  void _showSuccessModal(ShopProduct product) {
    _showingSuccessModal = true;

    String statusText = '✅ ${product.name} ativado! ${product.emoji}';

    // Adicionar informação de duração se for bônus temporal
    if (product.id.startsWith('buff_')) {
      statusText += '\n${product.duration}';
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
              '🎉 Compra Realizada',
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
        product.name,
        1.0, // 100% bonus
        const Duration(hours: 1),
        product.emoji,
      );
    } else if (product.id == 'buff_income_x3') {
      gameService.activateIncomeBonus(
        product.id,
        product.name,
        2.0, // 200% bonus
        const Duration(hours: 2),
        product.emoji,
      );
    } else if (product.id == 'buff_income_x5') {
      gameService.activateIncomeBonus(
        product.id,
        product.name,
        4.0, // 400% bonus
        const Duration(hours: 6),
        product.emoji,
      );
    } else if (product.id == 'buff_clicks_x2') {
      gameService.activateClickBonus(
        product.id,
        product.name,
        1.0, // 100% bonus
        const Duration(minutes: 30),
        product.emoji,
      );
    } else if (product.id == 'buff_all_in_one') {
      // Ativar ambos os bônus
      gameService.activateIncomeBonus(
        '${product.id}_income',
        '${product.name} (Renda)',
        2.0, // 200% bonus
        const Duration(hours: 1),
        product.emoji,
      );
      gameService.activateClickBonus(
        '${product.id}_clicks',
        '${product.name} (Cliques)',
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
      id: 'buff_income_x2',
      name: 'Multiplicador 2x',
      description: '+100% renda por 1 hora',
      emoji: '⚡',
      price: '\$0.99',
      duration: '1 hora',
      bonus: 1.0, // 100% bonus
      iapProductId: 'com.kasperlabs.companyIdle.buff_income_x2',
    ),
    ShopProduct(
      id: 'buff_income_x3',
      name: 'Multiplicador 3x',
      description: '+200% renda por 2 horas',
      emoji: '⚡⚡',
      price: '\$1.99',
      duration: '2 horas',
      bonus: 2.0, // 200% bonus
      iapProductId: 'com.kasperlabs.companyIdle.buff_income_x3',
    ),
    ShopProduct(
      id: 'buff_income_x5',
      name: 'Multiplicador 5x',
      description: '+400% renda por 6 horas',
      emoji: '⚡⚡⚡',
      price: '\$4.99',
      duration: '6 horas',
      bonus: 4.0, // 400% bonus
      iapProductId: 'com.kasperlabs.companyIdle.buff_income_x5',
    ),
    ShopProduct(
      id: 'buff_clicks_x2',
      name: 'Cliques 2x',
      description: '+100% dinheiro por clique por 30 min',
      emoji: '🖱️',
      price: '\$0.99',
      duration: '30 min',
      bonus: 1.0,
      iapProductId: 'com.kasperlabs.companyIdle.buff_clicks_x2',
    ),
    ShopProduct(
      id: 'buff_all_in_one',
      name: 'Buff Completo',
      description: '+200% renda e cliques por 1 hora',
      emoji: '🚀',
      price: '\$2.99',
      duration: '1 hora',
      bonus: 2.0,
      iapProductId: 'com.kasperlabs.companyIdle.buff_all_in_one',
    ),
    ShopProduct(
      id: 'money_bonus_1000',
      name: 'Bônus de Dinheiro',
      description: 'Receba \$1.000 em dinheiro do jogo',
      emoji: '💰',
      price: '\$0.99',
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
      price: '\$49.99',
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
                'LOJA',
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
                  product.name,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product.description,
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
                        product.duration,
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
                          'COMPRAR',
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
                      product.isAdVideo ? 'ASSISTIR' : 'COMPRAR',
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
            product.name,
            style: GoogleFonts.jetBrainsMono(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            product.isAdVideo
                ? 'Assistir um anúncio para ganhar recompensa?'
                : 'Comprar por ${product.price}?',
            style: GoogleFonts.jetBrainsMono(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _processPurchase(context, product, gameService);
              },
              child: Text(
                product.isAdVideo ? 'Assistir' : 'Confirmar',
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
      // Anúncios removidos - apenas simular
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🎬 Exibindo anúncio... ${product.emoji}'),
          duration: const Duration(seconds: 2),
        ),
      );

      // Após "assistir" o anúncio, aplicar benefício
      Future.delayed(const Duration(seconds: 3), () {
        _applyProductBenefit(product, gameService);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '✅ Obrigado! ${product.name} ativado! ${product.emoji}',
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      });
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
          content: Text('${product.name} ativado! ${product.emoji}'),
          duration: const Duration(seconds: 2),
        ),
      );
      _applyProductBenefit(product, gameService);
    }
  }

  void _applyProductBenefit(ShopProduct product, GameService gameService) {
    // Aplicar o benefício do produto
    if (product.id == 'money_bonus_1000') {
      // Adiciona $1000
      gameService.state.money = gameService.state.money + Money(1000);
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
