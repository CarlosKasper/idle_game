import 'package:flutter/foundation.dart';

/// Serviço que rastreia o estado global de uma compra em andamento
/// Permite que múltiplas partes da UI saibam quando uma compra está sendo processada
class PurchaseStateService extends ChangeNotifier {
  static final PurchaseStateService _instance =
      PurchaseStateService._internal();

  factory PurchaseStateService() => _instance;
  PurchaseStateService._internal();

  bool _isPurchasing = false;
  bool get isPurchasing => _isPurchasing;

  /// Marca que uma compra está começando
  void setPurchasing(bool value) {
    if (_isPurchasing != value) {
      _isPurchasing = value;
      notifyListeners();
      debugPrint('[PurchaseState] isPurchasing = $_isPurchasing');
    }
  }

  /// Reset para garantir que não fica travado
  void reset() {
    _isPurchasing = false;
    notifyListeners();
  }
}
