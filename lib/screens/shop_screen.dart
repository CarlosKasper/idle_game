import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../services/game_service.dart';
import '../services/admob_service.dart';
import '../models/money.dart';
import '../config/admob_config.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  late AdMobService _adMobService;

  @override
  void initState() {
    super.initState();
    _adMobService = AdMobService();
    // Pré-carregar anúncios recompensados usando IDs da config
    _adMobService.loadRewardedAd(AdMobConfig.rewardedAdUnitId1);
    _adMobService.loadRewardedAd(AdMobConfig.rewardedAdUnitId2);
    _adMobService.loadRewardedAd(AdMobConfig.rewardedAdUnitId3);
  }

  @override
  void dispose() {
    _adMobService.dispose();
    super.dispose();
  }

  // Simulação de produtos que poderiam ser oferecidos via in-app purchase
  // Em produção, isso viria do Google Play/App Store
  final List<ShopProduct> products = [
    // ═══════════════════════════════════════════════════════════════════
    // PRODUTOS COM ANÚNCIOS (FREE)
    // ═══════════════════════════════════════════════════════════════════
    ShopProduct(
      id: 'ad_buff_income_x2',
      name: 'Multiplicador 2x (Anúncio)',
      description: 'Assista um anúncio para ganhar +100% renda por 30 min',
      emoji: '📺',
      price: 'GRÁTIS',
      duration: '30 min',
      bonus: 1.0,
      isAdVideo: true,
      adUnitId: AdMobConfig.rewardedAdUnitId1,
    ),
    ShopProduct(
      id: 'ad_buff_clicks_x2',
      name: 'Cliques 2x (Anúncio)',
      description: 'Assista um anúncio para ganhar +100% cliques por 20 min',
      emoji: '📺',
      price: 'GRÁTIS',
      duration: '20 min',
      bonus: 1.0,
      isAdVideo: true,
      adUnitId: AdMobConfig.rewardedAdUnitId2,
    ),
    ShopProduct(
      id: 'ad_money_bonus',
      name: 'Bônus de Dinheiro (Anúncio)',
      description: 'Assista um anúncio e receba \$500',
      emoji: '📺',
      price: 'GRÁTIS',
      duration: 'Permanente',
      bonus: 0.0,
      isAdVideo: true,
      adUnitId: AdMobConfig.rewardedAdUnitId3,
    ),
    ShopProduct(
      id: 'buff_income_x2',
      name: 'Multiplicador 2x',
      description: '+100% renda por 1 hora',
      emoji: '⚡',
      price: '\$0.99',
      duration: '1 hora',
      bonus: 1.0, // 100% bonus
    ),
    ShopProduct(
      id: 'buff_income_x3',
      name: 'Multiplicador 3x',
      description: '+200% renda por 2 horas',
      emoji: '⚡⚡',
      price: '\$1.99',
      duration: '2 horas',
      bonus: 2.0, // 200% bonus
    ),
    ShopProduct(
      id: 'buff_income_x5',
      name: 'Multiplicador 5x',
      description: '+400% renda por 6 horas',
      emoji: '⚡⚡⚡',
      price: '\$4.99',
      duration: '6 horas',
      bonus: 4.0, // 400% bonus
    ),
    ShopProduct(
      id: 'buff_clicks_x2',
      name: 'Cliques 2x',
      description: '+100% dinheiro por clique por 30 min',
      emoji: '🖱️',
      price: '\$0.99',
      duration: '30 min',
      bonus: 1.0,
    ),
    ShopProduct(
      id: 'buff_all_in_one',
      name: 'Buff Completo',
      description: '+200% renda e cliques por 1 hora',
      emoji: '🚀',
      price: '\$2.99',
      duration: '1 hora',
      bonus: 2.0,
    ),
    ShopProduct(
      id: 'money_bonus_1000',
      name: 'Bônus de Dinheiro',
      description: 'Receba \$1.000 em dinheiro do jogo',
      emoji: '💰',
      price: '\$0.99',
      duration: 'Permanente',
      bonus: 0.0, // Não é um multiplicador, é dinheiro direto
    ),
    ShopProduct(
      id: 'become_ceo',
      name: 'Me torne CEO',
      description: 'Eu vou comprar essa empresa',
      emoji: '👑',
      price: '\$49.99',
      duration: 'Permanente',
      bonus: 0.0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: Column(
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
                          adMobService: _adMobService,
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
        children: [
          const Text('🛍️', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Text(
            'LOJA',
            style: GoogleFonts.silkscreen(fontSize: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _ShopProductCard extends StatelessWidget {
  final ShopProduct product;
  final AdMobService adMobService;

  const _ShopProductCard({required this.product, required this.adMobService});

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

          // Botão de compra
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
    // Simular a compra (em produção, seria via in_app_purchase ou rewarded ads)
    Navigator.pop(context);

    if (product.isAdVideo && product.adUnitId != null) {
      // Mostrar anúncio com recompensa real via AdMob
      adMobService.showRewardedAd(product.adUnitId!, (RewardItem reward) {
        // Quando o usuário completa o anúncio
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
    } else if (product.isAdVideo) {
      // Fallback: simular exibição de anúncio se não tiver AdMob configurado
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
    } else {
      // Compra com dinheiro real
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
  });
}
