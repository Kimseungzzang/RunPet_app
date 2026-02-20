import 'package:flutter/material.dart';
import 'package:runpet_app/models/run_models.dart';
import 'package:runpet_app/widgets/runpet_card.dart';

class RunResultScreen extends StatelessWidget {
  const RunResultScreen({
    super.key,
    required this.result,
    required this.onConfirm,
    required this.onWatchRewardAd,
  });

  final RunFinishResponseModel result;
  final VoidCallback onConfirm;
  final VoidCallback onWatchRewardAd;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Run complete')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          RunpetCard(
            child: Column(
              children: [
                _RewardRow(label: 'EXP gained', value: '+${result.expGained}'),
                _RewardRow(label: 'Coin gained', value: '+${result.coinGained}'),
                _RewardRow(label: 'Pet level', value: 'Lv.${result.petLevel}'),
              ],
            ),
          ),
          const RunpetCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pet reaction', style: TextStyle(fontWeight: FontWeight.w700)),
                SizedBox(height: 8),
                Text('Great run. Keep going!'),
              ],
            ),
          ),
          ElevatedButton(onPressed: onConfirm, child: const Text('Confirm')),
          const SizedBox(height: 8),
          FilledButton.tonal(
            onPressed: onWatchRewardAd,
            child: const Text('Watch ad for +30% coins'),
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
