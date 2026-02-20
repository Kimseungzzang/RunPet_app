import 'package:flutter/material.dart';
import 'package:runpet_app/widgets/runpet_card.dart';

class RunResultScreen extends StatelessWidget {
  const RunResultScreen({
    super.key,
    required this.onConfirm,
    required this.onWatchRewardAd,
  });

  final VoidCallback onConfirm;
  final VoidCallback onWatchRewardAd;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('러닝 완료')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const RunpetCard(
            child: Column(
              children: [
                _RewardRow(label: '획득 EXP', value: '+54'),
                _RewardRow(label: '획득 코인', value: '+31'),
                _RewardRow(label: '스트릭', value: '5일'),
              ],
            ),
          ),
          const RunpetCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('펫 반응', style: TextStyle(fontWeight: FontWeight.w700)),
                SizedBox(height: 8),
                Text('주인님 최고! 더 달리고 싶어!'),
              ],
            ),
          ),
          ElevatedButton(onPressed: onConfirm, child: const Text('확인')),
          const SizedBox(height: 8),
          FilledButton.tonal(
            onPressed: onWatchRewardAd,
            child: const Text('광고 보고 +30% 코인'),
          ),
        ],
      ),
    );
  }
}

class _RewardRow extends StatelessWidget {
  const _RewardRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label),
          const Spacer(),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}

