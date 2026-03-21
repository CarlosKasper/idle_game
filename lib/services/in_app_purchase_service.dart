import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Serviço de compras in-app para a Apple Store
/// Gerencia produtos e compras de bônus do jogo
class InAppPurchaseService extends ChangeNotifier {
  // ── Singleton ─────────────────────────────────────────────────────────────
  static final InAppPurchaseService _instance =
      InAppPurchaseService._internal();
  factory InAppPurchaseService() => _instance;
  InAppPurchaseService._internal();

  // IDs dos produtos na Apple Store
  static const String bundleId = 'com.kasperlabs.companyIdle';

  static const String productBuff2xIncome = '$bundleId.buff_income_x2';
  static const String productBuff3xIncome = '$bundleId.buff_income_x3';
  static const String productBuff5xIncome = '$bundleId.buff_income_x5';
  static const String productBuff2xClicks = '$bundleId.buff_clicks_x2';
  static const String productBuffAllInOne = '$bundleId.buff_all_in_one';
  static const String productMoneyBonus1000 = '$bundleId.money_bonus_1000';
  static const String productBecomeCEO = '$bundleId.become_ceo';

  static const Set<String> kProductIds = {
    productBuff2xIncome,
    productBuff3xIncome,
    productBuff5xIncome,
    productBuff2xClicks,
    productBuffAllInOne,
    productMoneyBonus1000,
    productBecomeCEO,
  };

  static const String _prefKeyPurchasedProducts = 'purchased_products';

  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  bool _isAvailable = false;
  bool _isPurchasing = false;
  Map<String, ProductDetails> _products = {};
  Set<String> _purchasedProducts = {};
  String? _errorMessage;
  bool _initialized = false;

  // Callback para quando uma compra é completada
  Function(String productId)? _onPurchaseCompleted;

  // ── Getters ───────────────────────────────────────────────────────────────
  bool get isAvailable => _isAvailable;
  bool get isPurchasing => _isPurchasing;
  Map<String, ProductDetails> get products => _products;
  Set<String> get purchasedProducts => _purchasedProducts;
  String? get errorMessage => _errorMessage;
  bool get initialized => _initialized;

  // ── Initialisation ────────────────────────────────────────────────────────

  Future<void> initialize({Function(String)? onPurchaseCompleted}) async {
    if (!Platform.isIOS || _initialized) return;
    _initialized = true;
    _onPurchaseCompleted = onPurchaseCompleted;

    debugPrint('[IAP] Inicializando InAppPurchaseService...');

    // Carregar compras anteriores
    await _loadPurchasedProducts();

    // Registrar listener ANTES de qualquer query — obrigatório pelo StoreKit
    _purchaseSubscription = InAppPurchase.instance.purchaseStream.listen(
      _onPurchaseUpdate,
      onError: (e) {
        debugPrint('[IAP] ❌ purchaseStream error: $e');
        _isPurchasing = false;
        _errorMessage = 'Erro: $e';
        notifyListeners();
      },
    );
    debugPrint('[IAP] ✅ purchaseStream listener registrado');

    await _loadProducts();
  }

  void setOnPurchaseCompleted(Function(String) callback) {
    _onPurchaseCompleted = callback;
  }

  // ── Public helpers ────────────────────────────────────────────────────────

  Future<void> buyProduct(String productId) async {
    debugPrint('[IAP] === buyProduct($productId) ===');

    if (!_isAvailable) {
      debugPrint('[IAP] Store não disponível');
      _errorMessage = 'Compras não disponíveis neste dispositivo';
      notifyListeners();
      return;
    }

    final product = _products[productId];
    if (product == null) {
      debugPrint('[IAP] ❌ Produto não encontrado: $productId');
      _errorMessage = 'Produto não encontrado';
      notifyListeners();
      return;
    }

    try {
      _isPurchasing = true;
      _errorMessage = null;
      notifyListeners();

      final purchaseParam = PurchaseParam(productDetails: product);
      debugPrint('[IAP] Iniciando compra de: ${product.title}');

      // Consumable vs Non-consumable
      // Para bônus temporários (consumíveis): buyConsumable
      // Para itens únicos: buyNonConsumable
      if (productId == productBecomeCEO || productId == productMoneyBonus1000) {
        // Itens únicos
        await InAppPurchase.instance.buyNonConsumable(
          purchaseParam: purchaseParam,
        );
      } else {
        // Bônus temporários (consumíveis)
        await InAppPurchase.instance.buyConsumable(
          purchaseParam: purchaseParam,
        );
      }

      debugPrint('[IAP] Compra iniciada. Aguardando purchaseStream...');

      // Timeout de segurança
      Future.delayed(const Duration(seconds: 90), () {
        if (_isPurchasing) {
          debugPrint('[IAP] ⚠️ Timeout: resetando isPurchasing');
          _isPurchasing = false;
          notifyListeners();
        }
      });
    } catch (e) {
      debugPrint('[IAP] ❌ Erro na compra: $e');
      _isPurchasing = false;
      _errorMessage = 'Erro: $e';
      notifyListeners();
    }
  }

  Future<void> restorePurchases() async {
    debugPrint('[IAP] === restorePurchases() ===');
    try {
      _isPurchasing = true;
      notifyListeners();

      await InAppPurchase.instance.restorePurchases();

      debugPrint('[IAP] Compras restauradas');
      _isPurchasing = false;
      notifyListeners();
    } catch (e) {
      debugPrint('[IAP] ❌ Erro ao restaurar: $e');
      _isPurchasing = false;
      _errorMessage = 'Erro ao restaurar: $e';
      notifyListeners();
    }
  }

  // ── Private ───────────────────────────────────────────────────────────────

  Future<void> _loadProducts() async {
    try {
      debugPrint('[IAP] Verificando disponibilidade da store...');
      final available = await InAppPurchase.instance.isAvailable();
      debugPrint('[IAP] Store disponível: $available');

      if (!available) {
        _errorMessage = 'Compras não disponíveis neste dispositivo';
        notifyListeners();
        return;
      }

      _isAvailable = true;

      debugPrint('[IAP] Consultando ${kProductIds.length} produtos...');
      final response = await InAppPurchase.instance.queryProductDetails(
        kProductIds,
      );

      debugPrint(
        '[IAP] Produtos encontrados: ${response.productDetails.length}',
      );
      if (response.notFoundIDs.isNotEmpty) {
        debugPrint('[IAP] IDs não encontrados: ${response.notFoundIDs}');
      }
      if (response.error != null) {
        debugPrint('[IAP] Erro na query: ${response.error!.message}');
      }

      _products.clear();
      for (final product in response.productDetails) {
        _products[product.id] = product;
        debugPrint(
          '[IAP] ✅ ${product.title} – ${product.price} (${product.id})',
        );
      }

      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      debugPrint('[IAP] ❌ Erro ao carregar produtos: $e');
      _errorMessage = 'Erro: $e';
      notifyListeners();
    }
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchases) {
    debugPrint('[IAP] === purchaseStream update: ${purchases.length} ===');
    for (final purchase in purchases) {
      debugPrint('[IAP] ID: ${purchase.productID}, Status: ${purchase.status}');

      // Verificar se é um dos nossos produtos
      if (!kProductIds.contains(purchase.productID)) {
        debugPrint('[IAP] Produto não reconhecido, completando compra');
        if (purchase.pendingCompletePurchase) {
          InAppPurchase.instance.completePurchase(purchase);
        }
        continue;
      }

      switch (purchase.status) {
        case PurchaseStatus.pending:
          _isPurchasing = true;
          debugPrint('[IAP] ⏳ Compra pendente');
          notifyListeners();
          break;

        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          debugPrint(
            '[IAP] ✅ SUCESSO! Produto comprado: ${purchase.productID}',
          );
          _isPurchasing = false;
          _errorMessage = null;

          // Salvar produto comprado
          _purchasedProducts.add(purchase.productID);
          _savePurchasedProducts();

          // Chamar callback
          _onPurchaseCompleted?.call(purchase.productID);

          if (purchase.pendingCompletePurchase) {
            InAppPurchase.instance.completePurchase(purchase);
          }
          notifyListeners();
          break;

        case PurchaseStatus.error:
          debugPrint('[IAP] ❌ Erro: ${purchase.error?.message}');
          _isPurchasing = false;
          final code = purchase.error?.code ?? '';
          _errorMessage = (code == '2') ? null : 'Erro na compra';
          if (purchase.pendingCompletePurchase) {
            InAppPurchase.instance.completePurchase(purchase);
          }
          notifyListeners();
          break;

        case PurchaseStatus.canceled:
          debugPrint('[IAP] Cancelada');
          _isPurchasing = false;
          _errorMessage = null;
          if (purchase.pendingCompletePurchase) {
            InAppPurchase.instance.completePurchase(purchase);
          }
          notifyListeners();
          break;
      }
    }
  }

  Future<void> _loadPurchasedProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedProducts =
          prefs.getStringList(_prefKeyPurchasedProducts) ?? [];
      _purchasedProducts = Set.from(savedProducts);
      debugPrint('[IAP] Produtos carregados do cache: $_purchasedProducts');
    } catch (e) {
      debugPrint('[IAP] Erro ao carregar produtos: $e');
    }
  }

  Future<void> _savePurchasedProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        _prefKeyPurchasedProducts,
        _purchasedProducts.toList(),
      );
      debugPrint('[IAP] Produtos salvos: $_purchasedProducts');
    } catch (e) {
      debugPrint('[IAP] Erro ao salvar produtos: $e');
    }
  }

  bool isPurchased(String productId) {
    return _purchasedProducts.contains(productId);
  }

  @override
  void dispose() {
    _purchaseSubscription?.cancel();
    super.dispose();
  }
}
