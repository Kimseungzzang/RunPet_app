import 'package:flutter/material.dart';
import 'package:runpet_app/models/pet_shop_models.dart';
import 'package:runpet_app/models/shop_product.dart';
import 'package:runpet_app/widgets/runpet_card.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({
    super.key,
    required this.onPurchaseSubscription,
    required this.onBuyCosmetic,
    required this.onEquipCosmetic,
    required this.products,
    required this.cosmeticItems,
    required this.coinBalance,
    this.isBusy = false,
    this.message,
  });

  final Future<void> Function(String productId) onPurchaseSubscription;
  final Future<PetShopResponseModel> Function(String itemId) onBuyCosmetic;
  final Future<PetShopResponseModel> Function(String slotType, String itemId) onEquipCosmetic;
  final List<ShopProduct> products;
  final List<PetShopItemModel> cosmeticItems;
  final int coinBalance;
  final bool isBusy;
  final String? message;

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  late List<PetShopItemModel> _items;
  late int _coinBalance;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _items = widget.cosmeticItems;
    _coinBalance = widget.coinBalance;
  }

  Future<void> _applyAction(Future<PetShopResponseModel> future) async {
    setState(() => _busy = true);
    try {
      final updated = await future;
      if (!mounted) return;
      setState(() {
        _items = updated.items;
        _coinBalance = updated.coinBalance;
      });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final blocked = widget.isBusy || _busy;
    return Scaffold(
      appBar: AppBar(title: const Text('Shop')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (widget.message != null) RunpetCard(child: Text(widget.message!)),
          RunpetCard(
            child: Text('Coins: $_coinBalance', style: Theme.of(context).textTheme.titleMedium),
          ),
          RunpetCard(
            child: Text('Pet cosmetics', style: Theme.of(context).textTheme.titleMedium),
          ),
          for (final item in _items)
            _ProductTile(
              title: item.itemName,
              desc: '${item.slotType} item',
              price: item.owned ? (item.equipped ? 'Equipped' : 'Equip') : '${item.priceCoin} coins',
              isBusy: blocked || (item.owned && item.equipped),
              onTap: () async {
                if (item.owned) {
                  await _applyAction(widget.onEquipCosmetic(item.slotType, item.itemId));
                } else {
                  await _applyAction(widget.onBuyCosmetic(item.itemId));
                }
              },
            ),
          RunpetCard(
            child: Text('Premium', style: Theme.of(context).textTheme.titleMedium),
          ),
          for (final product in widget.products)
            _ProductTile(
              title: product.title,
              desc: product.description,
              price: product.priceLabel,
              isBusy: blocked || !product.available,
              onTap: () => widget.onPurchaseSubscription(product.id),
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
