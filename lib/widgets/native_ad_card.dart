import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Card que renderiza um NativeAd (AdMob).
///
/// Observações:
/// - Precisa de `nativeAdUnitIdIOS` e/ou `nativeAdUnitIdAndroid`.
/// - Exige configuração de Native Ad factories no iOS/Android.
///   Se não houver factory, o ad pode falhar ao exibir.
class NativeAdCard extends StatefulWidget {
  final String? nativeAdUnitIdIOS;
  final String? nativeAdUnitIdAndroid;

  /// `factoryId` deve bater com o que você registrar no iOS/Android.
  /// Ex.: 'smallNative' / 'mediumNative'
  final String factoryId;

  final EdgeInsets margin;

  const NativeAdCard({
    super.key,
    required this.factoryId,
    this.nativeAdUnitIdIOS,
    this.nativeAdUnitIdAndroid,
    this.margin = const EdgeInsets.only(top: 16),
  });

  @override
  State<NativeAdCard> createState() => _NativeAdCardState();
}

class _NativeAdCardState extends State<NativeAdCard> {
  NativeAd? _ad;
  bool _isLoaded = false;
  bool _failed = false;
  bool _missingUnitId = false;

  String? get _unitId {
    if (Platform.isIOS) return widget.nativeAdUnitIdIOS;
    if (Platform.isAndroid) return widget.nativeAdUnitIdAndroid;
    return null;
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant NativeAdCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.factoryId != widget.factoryId ||
        oldWidget.nativeAdUnitIdIOS != widget.nativeAdUnitIdIOS ||
        oldWidget.nativeAdUnitIdAndroid != widget.nativeAdUnitIdAndroid) {
      _disposeAd();
      _isLoaded = false;
      _failed = false;
      _load();
    }
  }

  void _load() {
    final unitId = _unitId;
    if (unitId == null || unitId.isEmpty) {
      setState(() {
        _missingUnitId = true;
      });
      return;
    }

    final ad = NativeAd(
      adUnitId: unitId,
      factoryId: widget.factoryId,
      request: const AdRequest(),
      nativeAdOptions: NativeAdOptions(
        mediaAspectRatio: MediaAspectRatio.any,
        adChoicesPlacement: AdChoicesPlacement.topRightCorner,
      ),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          if (!mounted) return;
          setState(() {
            _ad = ad as NativeAd;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (!mounted) return;
          setState(() {
            _failed = true;
          });
        },
      ),
    );

    // Em iOS, se a factory não tiver sido registrada no AppDelegate, o plugin lança PlatformException.
    // Não deixamos isso derrubar o app: marcamos como failed e escondemos o card.
    try {
      ad.load();
    } catch (e) {
      debugPrint('[NativeAdCard] Failed to load NativeAd: $e');
      ad.dispose();
      if (mounted) {
        setState(() {
          _isLoaded = false;
          _failed = true;
        });
      }
    }
  }

  void _disposeAd() {
    _ad?.dispose();
    _ad = null;
  }

  @override
  void dispose() {
    _disposeAd();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Em web/desktop não faz sentido mostrar.
    if (!(Platform.isIOS || Platform.isAndroid)) {
      return const SizedBox.shrink();
    }

    if (_missingUnitId) {
      return const SizedBox.shrink();
    }

    if (_failed) {
      return const SizedBox.shrink();
    }

    if (!_isLoaded || _ad == null) {
      // Placeholder (mantém layout limpo, sem “pular”).
      return Container(
        margin: widget.margin,
        height: 72,
        decoration: BoxDecoration(
          color: const Color(0xFF141418),
          border: Border.all(color: const Color(0xFF2A2A30), width: 2),
          boxShadow: const [
            BoxShadow(color: Color(0xCC000000), offset: Offset(4, 4)),
          ],
        ),
      );
    }

    return Container(
      margin: widget.margin,
      height: 120,
      decoration: BoxDecoration(
        color: const Color(0xFF141418),
        border: Border.all(color: const Color(0xFF2A2A30), width: 2),
        boxShadow: const [
          BoxShadow(color: Color(0xCC000000), offset: Offset(4, 4)),
        ],
      ),
      child: AdWidget(ad: _ad!),
    );
  }
}
