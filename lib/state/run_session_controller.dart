import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:runpet_app/models/run_models.dart';
import 'package:runpet_app/services/location_service.dart';
import 'package:runpet_app/services/runpet_api_client.dart';
import 'package:runpet_app/state/run_session_state.dart';

class RunSessionController extends StateNotifier<RunSessionState> {
  RunSessionController({
    required RunpetApiClient apiClient,
    required LocationService locationService,
    required String userId,
  })  : _apiClient = apiClient,
        _locationService = locationService,
        _userId = userId,
        super(const RunSessionState());

  final RunpetApiClient _apiClient;
  final LocationService _locationService;
  final String _userId;

  StreamSubscription<Position>? _positionSub;
  Timer? _timer;
  Position? _lastPosition;

  Future<void> startRun() async {
    if (state.isBusy || state.hasActiveRun) return;
    if (_userId.isEmpty) {
      state = state.copyWith(errorMessage: 'Please login first');
      return;
    }
    state = state.copyWith(isBusy: true, clearError: true);

    try {
      await _locationService.ensurePermission();
      final started = await _apiClient.startRun(userId: _userId);

      state = const RunSessionState().copyWith(
        activeRunId: started.runId,
        isBusy: false,
        isTracking: true,
      );

      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        final durationSec = state.durationSec + 1;
        final avgPaceSec = state.distanceKm > 0
            ? ((durationSec / state.distanceKm).round())
            : 0;
        final calories = (state.distanceKm * 80).round();
        state = state.copyWith(
          durationSec: durationSec,
          avgPaceSec: avgPaceSec,
          calories: calories,
        );
      });

      _positionSub = _locationService.watchPosition().listen((position) {
        final previous = _lastPosition;
        _lastPosition = position;
        if (!state.isTracking) return;

        final currentPoint = RunTrackPoint(
          latitude: position.latitude,
          longitude: position.longitude,
        );
        if (previous == null) {
          state = state.copyWith(routePoints: [...state.routePoints, currentPoint]);
          return;
        }

        final deltaMeters = _locationService.distanceBetween(previous, position);
        if (deltaMeters <= 0) return;
        state = state.copyWith(
          distanceKm: state.distanceKm + (deltaMeters / 1000),
          routePoints: [...state.routePoints, currentPoint],
        );
      });
    } catch (e) {
      state = state.copyWith(
        isBusy: false,
        errorMessage: e.toString(),
      );
    }
  }

  void toggleTracking() {
    state = state.copyWith(isTracking: !state.isTracking);
  }

  Future<RunFinishResponseModel?> finishRun() async {
    final runId = state.activeRunId;
    if (runId == null || state.isBusy) return null;
    state = state.copyWith(isBusy: true, clearError: true);

    try {
      final result = await _apiClient.finishRun(
        runId: runId,
        distanceKm: state.distanceKm > 0 ? state.distanceKm : 0.1,
        durationSec: state.durationSec > 0 ? state.durationSec : 1,
        avgPaceSec: state.avgPaceSec > 0 ? state.avgPaceSec : 1,
        calories: state.calories > 0 ? state.calories : 1,
      );

      await _disposeTracking();
      state = const RunSessionState();
      return result;
    } catch (e) {
      state = state.copyWith(
        isBusy: false,
        errorMessage: e.toString(),
      );
      return null;
    }
  }

  Future<void> _disposeTracking() async {
    _timer?.cancel();
    _timer = null;
    await _positionSub?.cancel();
    _positionSub = null;
    _lastPosition = null;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _positionSub?.cancel();
    super.dispose();
  }
}
