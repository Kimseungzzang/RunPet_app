import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:runpet_app/services/runpet_api_client.dart';

void main() {
  group('RunpetApiClient', () {
    test('startRun returns run id', () async {
      final client = RunpetApiClient(
        baseUrl: 'http://localhost:8080',
        httpClient: MockClient((request) async {
          expect(request.url.path, '/api/v1/runs/start');
          return http.Response(
            jsonEncode({
              'runId': 'run_123',
              'userId': 'user_001',
              'status': 'started',
            }),
            200,
          );
        }),
      );

      final result = await client.startRun(userId: 'user_001');
      expect(result.runId, 'run_123');
      expect(result.status, 'started');
    });

    test('getPet throws ApiException on error', () async {
      final client = RunpetApiClient(
        baseUrl: 'http://localhost:8080',
        httpClient: MockClient((request) async {
          return http.Response(
            jsonEncode({'message': 'not found'}),
            404,
          );
        }),
      );

      expect(
        () => client.getPet(userId: 'missing_user'),
        throwsA(isA<ApiException>()),
      );
    });
  });
}

