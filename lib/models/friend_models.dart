class FriendModel {
  const FriendModel({
    required this.userId,
    required this.username,
    required this.displayName,
    required this.since,
  });

  final String userId;
  final String username;
  final String displayName;
  final DateTime since;

  factory FriendModel.fromJson(Map<String, dynamic> json) {
    return FriendModel(
      userId: json['userId'] as String,
      username: json['username'] as String,
      displayName: json['displayName'] as String,
      since: DateTime.parse(json['since'] as String),
    );
  }
}

class FriendRequestModel {
  const FriendRequestModel({
    required this.requestId,
    required this.fromUserId,
    required this.fromUsername,
    required this.fromDisplayName,
    required this.toUserId,
    required this.toUsername,
    required this.status,
    required this.createdAt,
  });

  final int requestId;
  final String fromUserId;
  final String fromUsername;
  final String fromDisplayName;
  final String toUserId;
  final String toUsername;
  final String status;
  final DateTime createdAt;

  factory FriendRequestModel.fromJson(Map<String, dynamic> json) {
    return FriendRequestModel(
      requestId: json['requestId'] as int,
      fromUserId: json['fromUserId'] as String,
      fromUsername: json['fromUsername'] as String,
      fromDisplayName: json['fromDisplayName'] as String,
      toUserId: json['toUserId'] as String,
      toUsername: json['toUsername'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

class FriendSearchUserModel {
  const FriendSearchUserModel({
    required this.userId,
    required this.username,
    required this.displayName,
  });

  final String userId;
  final String username;
  final String displayName;

  factory FriendSearchUserModel.fromJson(Map<String, dynamic> json) {
    return FriendSearchUserModel(
      userId: json['userId'] as String,
      username: json['username'] as String,
      displayName: json['displayName'] as String,
    );
  }
}

class BlockedUserModel {
  const BlockedUserModel({
    required this.userId,
    required this.username,
    required this.displayName,
    required this.blockedAt,
  });

  final String userId;
  final String username;
  final String displayName;
  final DateTime blockedAt;

  factory BlockedUserModel.fromJson(Map<String, dynamic> json) {
    return BlockedUserModel(
      userId: json['userId'] as String,
      username: json['username'] as String,
      displayName: json['displayName'] as String,
      blockedAt: DateTime.parse(json['blockedAt'] as String),
    );
  }
}

class FriendActivityModel {
  const FriendActivityModel({
    required this.runId,
    required this.userId,
    required this.username,
    required this.displayName,
    required this.startedAt,
    required this.distanceKm,
    required this.durationSec,
    required this.avgPaceSec,
    required this.calories,
    required this.cheerCount,
    required this.cheeredByMe,
  });

  final String runId;
  final String userId;
  final String username;
  final String displayName;
  final DateTime startedAt;
  final double distanceKm;
  final int durationSec;
  final int avgPaceSec;
  final int calories;
  final int cheerCount;
  final bool cheeredByMe;

  factory FriendActivityModel.fromJson(Map<String, dynamic> json) {
    return FriendActivityModel(
      runId: json['runId'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
      displayName: json['displayName'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      distanceKm: (json['distanceKm'] as num).toDouble(),
      durationSec: json['durationSec'] as int,
      avgPaceSec: json['avgPaceSec'] as int,
      calories: json['calories'] as int,
      cheerCount: (json['cheerCount'] as num?)?.toInt() ?? 0,
      cheeredByMe: json['cheeredByMe'] as bool? ?? false,
    );
  }
}
