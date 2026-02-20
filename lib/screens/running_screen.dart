import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:runpet_app/state/run_session_state.dart';
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
    required this.routePoints,
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
  final List<RunTrackPoint> routePoints;
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
        if (hasActiveRun && routePoints.isNotEmpty) ...[
          RunpetCard(
            child: SizedBox(
              height: 240,
              child: _RunRouteMap(routePoints: routePoints),
            ),
          ),
          const SizedBox(height: 12),
        ],
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
          child: Text('GPS stable ? Background tracking enabled'),
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

class _RunRouteMap extends StatelessWidget {
  const _RunRouteMap({required this.routePoints});

  final List<RunTrackPoint> routePoints;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const Center(
        child: Text('Map preview is supported on Android/iOS for now.'),
      );
    }

    final latLngPoints = routePoints
        .map((p) => LatLng(p.latitude, p.longitude))
        .toList(growable: false);
    final current = latLngPoints.last;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: current,
          zoom: 17,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: false,
        polylines: {
          Polyline(
            polylineId: const PolylineId('run_path'),
            points: latLngPoints,
            width: 6,
            color: const Color(0xFF2563EB),
          ),
        },
        markers: {
          Marker(
            markerId: const MarkerId('current_pos'),
            position: current,
            infoWindow: const InfoWindow(title: 'Current position'),
          ),
        },
      ),
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
