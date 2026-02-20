class RunStartResponseModel {
  const RunStartResponseModel({
    required this.runId,
    required this.userId,
    required this.status,
  });

  final String runId;
  final String userId;
  final String status;

  factory RunStartResponseModel.fromJson(Map<String, dynamic> json) {
    return RunStartResponseModel(
      runId: json['runId'] as String,
      userId: json['userId'] as String,
      status: json['status'] as String,
    );
  }
}

class RunFinishResponseModel {
  const RunFinishResponseModel({
    required this.runId,
    required this.userId,
    required this.distanceKm,
    required this.durationSec,
    required this.avgPaceSec,
    required this.calories,
    required this.expGained,
    required this.coinGained,
    required this.petLevel,
    required this.petExp,
  });

  final String runId;
  final String userId;
  final double distanceKm;
  final int durationSec;
  final int avgPaceSec;
  final int calories;
  final int expGained;
  final int coinGained;
  final int petLevel;
  final int petExp;

  factory RunFinishResponseModel.fromJson(Map<String, dynamic> json) {
    return RunFinishResponseModel(
      runId: json['runId'] as String,
      userId: json['userId'] as String,
      distanceKm: (json['distanceKm'] as num).toDouble(),
      durationSec: json['durationSec'] as int,
      avgPaceSec: json['avgPaceSec'] as int,
      calories: json['calories'] as int,
      expGained: json['expGained'] as int,
      coinGained: json['coinGained'] as int,
      petLevel: json['petLevel'] as int,
      petExp: json['petExp'] as int,
    );
  }
}

