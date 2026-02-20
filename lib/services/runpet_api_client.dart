import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:runpet_app/models/auth_models.dart';
import 'package:runpet_app/models/friend_models.dart';
import 'package:runpet_app/models/payment_model.dart';
import 'package:runpet_app/models/pet_model.dart';
import 'package:runpet_app/models/run_models.dart';

class ApiException implements Exception {
  ApiException(this.message);
  final String message;

  @override
  String toString() => 'ApiException: $message';
}

class RunpetApiClient {
  RunpetApiClient({
    required this.baseUrl,
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  final String baseUrl;
  final http.Client _httpClient;
  AuthSessionModel? _session;
  Future<AuthSessionModel?> Function()? _onUnauthorized;

  void setAuthSession(AuthSessionModel? session) {
    _session = session;
  }

  void setUnauthorizedHandler(Future<AuthSessionModel?> Function()? handler) {
    _onUnauthorized = handler;
  }

  Future<UserProfileModel> register({
    required String username,
    required String password,
    required String displayName,
  }) async {
    final json = await _post(
      '/api/v1/auth/register',
      body: {
        'username': username,
        'password': password,
        'displayName': displayName,
      },
      needsAuth: false,
    );
    return UserProfileModel.fromJson(json);
  }

  Future<AuthSessionModel> login({
    required String username,
    required String password,
  }) async {
    final json = await _post(
      '/api/v1/auth/login',
      body: {
        'username': username,
        'password': password,
      },
      needsAuth: false,
    );
    return AuthSessionModel.fromJson(json);
  }

  Future<AuthSessionModel> refresh({
    required String sessionId,
    required String refreshToken,
  }) async {
    final json = await _post(
      '/api/v1/auth/refresh',
      body: {
        'sessionId': sessionId,
        'refreshToken': refreshToken,
      },
      needsAuth: false,
    );
    return AuthSessionModel.fromJson(json);
  }

  Future<void> logout({
    String? sessionId,
    String? refreshToken,
  }) async {
    await _post(
      '/api/v1/auth/logout',
      body: {
        if (sessionId != null) 'sessionId': sessionId,
        if (refreshToken != null) 'refreshToken': refreshToken,
      },
    );
  }

  Future<void> logoutAll() async {
    await _post('/api/v1/auth/logout-all', body: const {});
  }

  Future<List<FriendModel>> getFriends() async {
    final response = await _request('GET', '/api/v1/friends');
    final list = _decodeListOrThrow(response);
    return list.map((e) => FriendModel.fromJson(e)).toList();
  }

  Future<List<FriendRequestModel>> getIncomingFriendRequests() async {
    final response = await _request('GET', '/api/v1/friends/requests/incoming');
    final list = _decodeListOrThrow(response);
    return list.map((e) => FriendRequestModel.fromJson(e)).toList();
  }

  Future<List<FriendRequestModel>> getOutgoingFriendRequests() async {
    final response = await _request('GET', '/api/v1/friends/requests/outgoing');
    final list = _decodeListOrThrow(response);
    return list.map((e) => FriendRequestModel.fromJson(e)).toList();
  }

  Future<List<FriendSearchUserModel>> searchFriendUsers({
    required String query,
  }) async {
    final encoded = Uri.encodeQueryComponent(query);
    final response = await _request('GET', '/api/v1/friends/search?query=$encoded');
    final list = _decodeListOrThrow(response);
    return list.map((e) => FriendSearchUserModel.fromJson(e)).toList();
  }

  Future<FriendRequestModel> sendFriendRequest({
    required String targetUsername,
  }) async {
    final json = await _post(
      '/api/v1/friends/requests',
      body: {'targetUsername': targetUsername},
    );
    return FriendRequestModel.fromJson(json);
  }

  Future<FriendRequestModel> acceptFriendRequest({
    required int requestId,
  }) async {
    final json = await _post('/api/v1/friends/requests/$requestId/accept', body: const {});
    return FriendRequestModel.fromJson(json);
  }

  Future<FriendRequestModel> rejectFriendRequest({
    required int requestId,
  }) async {
    final json = await _post('/api/v1/friends/requests/$requestId/reject', body: const {});
    return FriendRequestModel.fromJson(json);
  }

  Future<FriendRequestModel> cancelFriendRequest({
    required int requestId,
  }) async {
    final json = await _post('/api/v1/friends/requests/$requestId/cancel', body: const {});
    return FriendRequestModel.fromJson(json);
  }

  Future<void> removeFriend({
    required String friendUserId,
  }) async {
    final response = await _request('DELETE', '/api/v1/friends/$friendUserId');
    if (response.statusCode < 200 || response.statusCode >= 300) {
      _decodeOrThrow(response);
    }
  }

  Future<RunStartResponseModel> startRun({String? userId}) async {
    final json = await _post(
      '/api/v1/runs/start',
      body: {
        if (userId != null) 'userId': userId,
      },
    );
    return RunStartResponseModel.fromJson(json);
  }

  Future<RunFinishResponseModel> finishRun({
    required String runId,
    required double distanceKm,
    required int durationSec,
    required int avgPaceSec,
    required int calories,
  }) async {
    final json = await _post(
      '/api/v1/runs/$runId/finish',
      body: {
        'distanceKm': distanceKm,
        'durationSec': durationSec,
        'avgPaceSec': avgPaceSec,
        'calories': calories,
      },
    );
    return RunFinishResponseModel.fromJson(json);
  }

  Future<PetModel> getPet({String? userId}) async {
    final query = (userId == null || userId.isEmpty) ? '' : '?userId=$userId';
    final response = await _request('GET', '/api/v1/pet$query');
    final json = _decodeOrThrow(response);
    return PetModel.fromJson(json);
  }

  Future<PetModel> equipPet({
    String? userId,
    required String slotType,
    required String itemId,
  }) async {
    final json = await _post(
      '/api/v1/pet/equip',
      body: {
        if (userId != null) 'userId': userId,
        'slotType': slotType,
        'itemId': itemId,
      },
    );
    return PetModel.fromJson(json);
  }

  Future<PaymentVerifyResponseModel> verifyPayment({
    String? userId,
    required String productId,
    required String platform,
    required String transactionId,
    required String receiptToken,
  }) async {
    final json = await _post(
      '/api/v1/payments/verify',
      body: {
        if (userId != null) 'userId': userId,
        'productId': productId,
        'platform': platform,
        'transactionId': transactionId,
        'receiptToken': receiptToken,
      },
    );
    return PaymentVerifyResponseModel.fromJson(json);
  }

  Future<Map<String, dynamic>> _post(
    String path, {
    required Map<String, dynamic> body,
    bool needsAuth = true,
  }) async {
    final response = await _request(
      'POST',
      path,
      body: body,
      needsAuth: needsAuth,
    );
    return _decodeOrThrow(response);
  }

  Future<http.Response> _request(
    String method,
    String path, {
    Map<String, dynamic>? body,
    bool needsAuth = true,
    bool hasRetried = false,
  }) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      if (needsAuth && _session?.accessToken != null)
        'Authorization': 'Bearer ${_session!.accessToken}',
    };
    final uri = Uri.parse('$baseUrl$path');
    final payload = body == null ? null : jsonEncode(body);

    late final http.Response response;
    if (method == 'GET') {
      response = await _httpClient.get(uri, headers: headers);
    } else if (method == 'DELETE') {
      response = await _httpClient.delete(uri, headers: headers);
    } else {
      response = await _httpClient.post(
        uri,
        headers: headers,
        body: payload,
      );
    }

    if (!needsAuth || hasRetried || response.statusCode != 401 || _onUnauthorized == null) {
      return response;
    }

    final refreshed = await _onUnauthorized!.call();
    if (refreshed == null) {
      return response;
    }
    _session = refreshed;

    return _request(
      method,
      path,
      body: body,
      needsAuth: needsAuth,
      hasRetried: true,
    );
  }

  Map<String, dynamic> _decodeOrThrow(http.Response response) {
    final body = response.body.isEmpty
        ? <String, dynamic>{}
        : jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException((body['message'] ?? 'Request failed').toString());
    }
    return body;
  }

  List<Map<String, dynamic>> _decodeListOrThrow(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final body = response.body.isEmpty
          ? <String, dynamic>{}
          : jsonDecode(response.body) as Map<String, dynamic>;
      throw ApiException((body['message'] ?? 'Request failed').toString());
    }
    if (response.body.isEmpty) return const [];
    final decoded = jsonDecode(response.body) as List<dynamic>;
    return decoded.cast<Map<String, dynamic>>();
  }
}
