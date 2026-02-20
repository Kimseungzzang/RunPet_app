import 'package:flutter/material.dart';
import 'package:runpet_app/widgets/runpet_card.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('상점')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _ProductTile(
            title: 'No Ads Monthly',
            desc: '광고 제거 + 보너스 코인',
            price: '₩4,400',
          ),
          _ProductTile(
            title: 'Starter Coin Pack',
            desc: '2,000 코인',
            price: '₩1,100',
          ),
          _ProductTile(
            title: 'Costume Pack A',
            desc: '의상 3종 세트',
            price: '₩3,300',
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
  });

  final String title;
  final String desc;
  final String price;

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
          FilledButton(onPressed: () {}, child: Text(price)),
        ],
      ),
    );
  }
}

