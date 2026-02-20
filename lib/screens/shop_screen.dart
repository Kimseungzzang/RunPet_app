import 'package:flutter/material.dart';
import 'package:runpet_app/models/shop_product.dart';
import 'package:runpet_app/widgets/runpet_card.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({
    super.key,
    required this.onPurchase,
    required this.products,
    this.isBusy = false,
    this.message,
  });

  final Future<void> Function(String productId) onPurchase;
  final List<ShopProduct> products;
  final bool isBusy;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shop')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (message != null)
            RunpetCard(
              child: Text(message!),
            ),
          for (final product in products)
            _ProductTile(
              title: product.title,
              desc: product.description,
              price: product.priceLabel,
              isBusy: isBusy || !product.available,
              onTap: () => onPurchase(product.id),
            ),
        ],
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({
    required this.title,
    required this.desc,
    required this.price,
    required this.onTap,
    required this.isBusy,
  });

  final String title;
  final String desc;
  final String price;
  final Future<void> Function() onTap;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    return RunpetCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(desc),
              ],
            ),
          ),
          const SizedBox(width: 12),
          FilledButton(
            onPressed: isBusy ? null : onTap,
            child: Text(price),
          ),
        ],
      ),
    );
  }
}
