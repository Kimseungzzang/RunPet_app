import 'package:flutter/material.dart';
import 'package:runpet_app/models/payment_model.dart';
import 'package:runpet_app/widgets/runpet_card.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({
    super.key,
    required this.onPurchase,
    this.isBusy = false,
  });

  final Future<PaymentVerifyResponseModel> Function(String productId) onPurchase;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shop')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ProductTile(
            title: 'No Ads Monthly',
            desc: 'Remove ads + bonus coins',
            price: '\$3.99',
            isBusy: isBusy,
            onTap: () => _buy(context, 'no_ads_monthly'),
          ),
          _ProductTile(
            title: 'Starter Coin Pack',
            desc: '2,000 coins',
            price: '\$0.99',
            isBusy: isBusy,
            onTap: () => _buy(context, 'coin_pack_starter'),
          ),
          _ProductTile(
            title: 'Costume Pack A',
            desc: '3 costume pieces',
            price: '\$2.99',
            isBusy: isBusy,
            onTap: () => _buy(context, 'costume_pack_a'),
          ),
        ],
      ),
    );
  }

  Future<void> _buy(BuildContext context, String productId) async {
    final result = await onPurchase(productId);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Purchase verified: ${result.productId}')),
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
  final VoidCallback onTap;
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
