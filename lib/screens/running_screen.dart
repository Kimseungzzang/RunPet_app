import 'package:flutter/material.dart';
import 'package:runpet_app/widgets/runpet_card.dart';

class RunningScreen extends StatelessWidget {
  const RunningScreen({
    super.key,
    required this.isRunning,
    required this.onToggleRunning,
    required this.onFinish,
  });

  final bool isRunning;
  final VoidCallback onToggleRunning;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('러닝 기록 중', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        const RunpetCard(
          child: Column(
            children: [
              _MetricRow(label: '거리', value: '2.14 km'),
              _MetricRow(label: '시간', value: '18:42'),
              _MetricRow(label: '페이스', value: '5\'12"'),
              _MetricRow(label: '칼로리', value: '178 kcal'),
            ],
          ),
        ),
        const RunpetCard(
          child: Text('GPS 안정 · 백그라운드 기록 활성화'),
        ),
        ElevatedButton(
          onPressed: onToggleRunning,
          child: Text(isRunning ? '일시정지' : '재시작'),
        ),
        const SizedBox(height: 8),
        FilledButton.tonal(onPressed: onFinish, child: const Text('종료하기')),
      ],
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.label, required this.value});
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

