import 'dart:convert';

import 'package:http/http.dart' as http;
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

  Future<RunStartResponseModel> startRun({required String userId}) async {
    final json = await _post(
      '/api/v1/runs/start',
      body: {'userId': userId},
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

  Future<PetModel> getPet({required String userId}) async {
    final uri = Uri.parse('$baseUrl/api/v1/pet?userId=$userId');
    final response = await _httpClient.get(uri);
    final json = _decodeOrThrow(response);
    return PetModel.fromJson(json);
  }

  Future<PetModel> equipPet({
    required String userId,
    required String slotType,
    required String itemId,
  }) async {
    final json = await _post(
      '/api/v1/pet/equip',
      body: {
        'userId': userId,
        'slotType': slotType,
        'itemId': itemId,
      },
    );
    return PetModel.fromJson(json);
  }

  Future<PaymentVerifyResponseModel> verifyPayment({
    required String userId,
    required String productId,
    required String platform,
    required String transactionId,
    required String receiptToken,
  }) async {
    final json = await _post(
      '/api/v1/payments/verify',
      body: {
        'userId': userId,
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
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await _httpClient.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    return _decodeOrThrow(response);
  }

  Map<String, dynamic> _decodeOrThrow(http.Response response) {
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException((body['message'] ?? 'Request failed').toString());
    }
    return body;
  }
}

