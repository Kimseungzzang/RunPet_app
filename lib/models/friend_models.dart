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
