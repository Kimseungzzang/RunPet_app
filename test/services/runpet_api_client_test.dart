import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:runpet_app/models/auth_models.dart';
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

    test('retries once after refresh when protected call returns 401', () async {
      var runStartCall = 0;
      final client = RunpetApiClient(
        baseUrl: 'http://localhost:8080',
        httpClient: MockClient((request) async {
          if (request.url.path == '/api/v1/runs/start') {
            runStartCall += 1;
            if (runStartCall == 1) {
              return http.Response(jsonEncode({'message': 'unauthorized'}), 401);
            }
            return http.Response(
              jsonEncode({
                'runId': 'run_retry_ok',
                'userId': 'user_001',
                'status': 'started',
              }),
              200,
            );
          }
          return http.Response(jsonEncode({'message': 'not found'}), 404);
        }),
      );
      client.setAuthSession(
        const AuthSessionModel(
          accessToken: 'access_old',
          refreshToken: 'refresh_old',
          sessionId: 'session_old',
          user: UserProfileModel(
            userId: 'user_001',
            username: 'user',
            displayName: 'User',
          ),
        ),
      );
      client.setUnauthorizedHandler(() async {
        return const AuthSessionModel(
          accessToken: 'access_new',
          refreshToken: 'refresh_new',
          sessionId: 'session_old',
          user: UserProfileModel(
            userId: 'user_001',
            username: 'user',
            displayName: 'User',
          ),
        );
      });

      final result = await client.startRun(userId: 'user_001');
      expect(result.runId, 'run_retry_ok');
      expect(runStartCall, 2);
    });
  });
}
