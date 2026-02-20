import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:runpet_app/models/shop_product.dart';

class InAppPurchaseService {
  InAppPurchaseService({InAppPurchase? inAppPurchase})
      : _inAppPurchase = inAppPurchase ?? InAppPurchase.instance;

  final InAppPurchase _inAppPurchase;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSub;

  Future<bool> isAvailable() => _inAppPurchase.isAvailable();

  void startListening({
    required Future<void> Function(PurchaseDetails detail) onPurchasedOrRestored,
    required void Function(String message) onError,
  }) {
    _purchaseSub ??= _inAppPurchase.purchaseStream.listen(
      (purchases) async {
        for (final detail in purchases) {
          try {
            if (detail.status == PurchaseStatus.purchased ||
                detail.status == PurchaseStatus.restored) {
              await onPurchasedOrRestored(detail);
            } else if (detail.status == PurchaseStatus.error) {
              onError(detail.error?.message ?? 'Purchase failed');
            }
          } finally {
            if (detail.pendingCompletePurchase) {
              await _inAppPurchase.completePurchase(detail);
            }
          }
        }
      },
      onError: (Object e) => onError(e.toString()),
    );
  }

  Future<List<ShopProduct>> loadProducts(Set<String> productIds) async {
    final response = await _inAppPurchase.queryProductDetails(productIds);
    if (response.error != null) {
      throw Exception(response.error!.message);
    }

    final productsById = {
      for (final p in response.productDetails) p.id: p,
    };

    return productIds.map((id) {
      final p = productsById[id];
      if (p == null) {
        return ShopProduct(
          id: id,
          title: id,
          description: 'Not available in store',
          priceLabel: '-',
          available: false,
        );
      }
      return ShopProduct(
        id: p.id,
        title: p.title,
        description: p.description,
        priceLabel: p.price,
        available: true,
      );
    }).toList();
  }

  Future<void> buy(String productId) async {
    final response = await _inAppPurchase.queryProductDetails({productId});
    if (response.productDetails.isEmpty) {
      throw Exception('Product not found: $productId');
    }
    final details = response.productDetails.first;
    final purchaseParam = PurchaseParam(productDetails: details);
    final requested = await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    if (!requested) {
      throw Exception('Purchase request was not started');
    }
  }

  Future<void> dispose() async {
    await _purchaseSub?.cancel();
    _purchaseSub = null;
  }
}

