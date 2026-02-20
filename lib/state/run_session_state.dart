class RunTrackPoint {
  const RunTrackPoint({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;
}

class RunSessionState {
  const RunSessionState({
    this.activeRunId,
    this.isBusy = false,
    this.isTracking = false,
    this.durationSec = 0,
    this.distanceKm = 0,
    this.avgPaceSec = 0,
    this.calories = 0,
    this.routePoints = const [],
    this.errorMessage,
  });

  final String? activeRunId;
  final bool isBusy;
  final bool isTracking;
  final int durationSec;
  final double distanceKm;
  final int avgPaceSec;
  final int calories;
  final List<RunTrackPoint> routePoints;
  final String? errorMessage;

  bool get hasActiveRun => activeRunId != null;

  RunSessionState copyWith({
    String? activeRunId,
    bool? isBusy,
    bool? isTracking,
    int? durationSec,
    double? distanceKm,
    int? avgPaceSec,
    int? calories,
    List<RunTrackPoint>? routePoints,
    String? errorMessage,
    bool clearError = false,
  }) {
    return RunSessionState(
      activeRunId: activeRunId ?? this.activeRunId,
      isBusy: isBusy ?? this.isBusy,
      isTracking: isTracking ?? this.isTracking,
      durationSec: durationSec ?? this.durationSec,
      distanceKm: distanceKm ?? this.distanceKm,
      avgPaceSec: avgPaceSec ?? this.avgPaceSec,
      calories: calories ?? this.calories,
      routePoints: routePoints ?? this.routePoints,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
