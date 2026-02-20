import 'package:flutter/material.dart';
import 'package:runpet_app/widgets/runpet_card.dart';

class RunningScreen extends StatelessWidget {
  const RunningScreen({
    super.key,
    required this.isRunning,
    required this.hasActiveRun,
    required this.isBusy,
    required this.onStartRun,
    required this.onToggleRunning,
    required this.onFinish,
  });

  final bool isRunning;
  final bool hasActiveRun;
  final bool isBusy;
  final VoidCallback onStartRun;
  final VoidCallback onToggleRunning;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Running tracker', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        const RunpetCard(
          child: Column(
            children: [
              _MetricRow(label: 'Distance', value: '2.14 km'),
              _MetricRow(label: 'Duration', value: '18:42'),
              _MetricRow(label: 'Pace', value: '5\'12"'),
              _MetricRow(label: 'Calories', value: '178 kcal'),
            ],
          ),
        ),
        const RunpetCard(
          child: Text('GPS stable • Background tracking enabled'),
        ),
        if (!hasActiveRun)
          ElevatedButton(
            onPressed: isBusy ? null : onStartRun,
            child: Text(isBusy ? 'Starting...' : 'Start run session'),
          )
        else ...[
          ElevatedButton(
            onPressed: isBusy ? null : onToggleRunning,
            child: Text(isRunning ? 'Pause' : 'Resume'),
          ),
          const SizedBox(height: 8),
          FilledButton.tonal(
            onPressed: isBusy ? null : onFinish,
            child: Text(isBusy ? 'Finishing...' : 'Finish run'),
          ),
        ],
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
