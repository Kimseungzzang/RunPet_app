import 'package:flutter/material.dart';
import 'package:runpet_app/widgets/runpet_card.dart';

class RunningScreen extends StatelessWidget {
  const RunningScreen({
    super.key,
    required this.isRunning,
    required this.hasActiveRun,
    required this.isBusy,
    required this.distanceKm,
    required this.durationSec,
    required this.avgPaceSec,
    required this.calories,
    required this.onStartRun,
    required this.onToggleRunning,
    required this.onFinish,
  });

  final bool isRunning;
  final bool hasActiveRun;
  final bool isBusy;
  final double distanceKm;
  final int durationSec;
  final int avgPaceSec;
  final int calories;
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
        RunpetCard(
          child: Column(
            children: [
              _MetricRow(label: 'Distance', value: '${distanceKm.toStringAsFixed(2)} km'),
              _MetricRow(label: 'Duration', value: _formatDuration(durationSec)),
              _MetricRow(label: 'Pace', value: _formatPace(avgPaceSec)),
              _MetricRow(label: 'Calories', value: '$calories kcal'),
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

  String _formatDuration(int totalSec) {
    final m = (totalSec ~/ 60).toString().padLeft(2, '0');
    final s = (totalSec % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String _formatPace(int paceSec) {
    if (paceSec <= 0) return '--';
    final m = (paceSec ~/ 60).toString();
    final s = (paceSec % 60).toString().padLeft(2, '0');
    return '$m\'$s"';
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
