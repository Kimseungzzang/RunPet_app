import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:runpet_app/app/runpet_app.dart';
import 'package:runpet_app/models/auth_models.dart';
import 'package:runpet_app/models/shop_product.dart';
import 'package:runpet_app/models/run_models.dart';
import 'package:runpet_app/services/in_app_purchase_service.dart';
import 'package:runpet_app/services/location_service.dart';
import 'package:runpet_app/services/runpet_api_client.dart';
import 'package:runpet_app/state/auth_controller.dart';
import 'package:runpet_app/state/auth_state.dart';
import 'package:runpet_app/state/providers.dart';
import 'package:runpet_app/state/run_session_controller.dart';
import 'package:runpet_app/state/run_session_state.dart';

class _FakePurchaseService implements PurchaseService {
  Future<void> Function(PurchaseEvent event)? _onPurchasedOrRestored;
  void Function(String message)? _onError;

  @override
  Future<void> buy(String productId) async {}

  @override
  Future<void> dispose() async {}

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<List<ShopProduct>> loadProducts(Set<String> productIds) async {
    return const [
      ShopProduct(
        id: 'no_ads_monthly',
        title: 'No Ads Monthly',
        description: 'Remove ads + bonus coins',
        priceLabel: '\$3.99',
        available: true,
      ),
    ];
  }

  @override
  void startListening({
    required Future<void> Function(PurchaseEvent event) onPurchasedOrRestored,
    required void Function(String message) onError,
  }) {
    _onPurchasedOrRestored = onPurchasedOrRestored;
    _onError = onError;
  }

  Future<void> emitPurchased({
    required String productId,
    required String transactionId,
    required String receiptToken,
  }) async {
    await _onPurchasedOrRestored?.call(
      PurchaseEvent(
        productId: productId,
        transactionId: transactionId,
        receiptToken: receiptToken,
        status: 'purchased',
      ),
    );
  }

  void emitError(String message) {
    _onError?.call(message);
  }
}

class _FakeRunSessionController extends RunSessionController {
  _FakeRunSessionController()
      : super(
          apiClient: RunpetApiClient(
            baseUrl: 'http://localhost:8080',
            httpClient: MockClient((_) async => http.Response('{}', 200)),
          ),
          locationService: LocationService(),
          userId: 'user_001',
        );

  @override
  Future<void> startRun() async {
    state = state.copyWith(
      activeRunId: 'run_test_001',
      isTracking: true,
      isBusy: false,
      durationSec: 65,
      distanceKm: 1.2,
      avgPaceSec: 54,
      calories: 96,
      clearError: true,
    );
  }

  @override
  Future<RunFinishResponseModel?> finishRun() async {
    final result = RunFinishResponseModel(
      runId: 'run_test_001',
      userId: 'user_001',
      distanceKm: 1.2,
      durationSec: 65,
      avgPaceSec: 54,
      calories: 96,
      expGained: 20,
      coinGained: 10,
      petLevel: 2,
      petExp: 20,
    );
    state = const RunSessionState();
    return result;
  }
}

class _FakeAuthController extends AuthController {
  _FakeAuthController({
    required RunpetApiClient apiClient,
    required AuthSessionModel session,
  }) : super(apiClient: apiClient) {
    state = AuthState(
      isLoading: false,
      session: session,
      errorMessage: null,
    );
    apiClient.setAuthSession(session);
  }
}

RunpetApiClient _apiClient({
  bool petLoadFail = false,
  bool paymentFail = false,
}) {
  return RunpetApiClient(
    baseUrl: 'http://localhost:8080',
    httpClient: MockClient((request) async {
      if (request.method == 'GET' && request.url.path == '/api/v1/pet') {
        if (petLoadFail) return http.Response(jsonEncode({'message': 'server down'}), 500);
        return http.Response(
          jsonEncode({
            'userId': 'user_001',
            'petLevel': 1,
            'petExp': 10,
            'petMood': 'happy',
            'equippedHatId': null,
            'equippedOutfitId': null,
            'equippedBgId': null,
          }),
          200,
        );
      }

      if (request.method == 'POST' && request.url.path == '/api/v1/pet/equip') {
        return http.Response(
          jsonEncode({
            'userId': 'user_001',
            'petLevel': 1,
            'petExp': 10,
            'petMood': 'happy',
            'equippedHatId': 'hat_leaf_cap',
            'equippedOutfitId': null,
            'equippedBgId': null,
          }),
          200,
        );
      }

      if (request.method == 'POST' && request.url.path == '/api/v1/payments/verify') {
        if (paymentFail) {
          return http.Response(
            jsonEncode({
              'status': 'failed',
              'userId': 'user_001',
              'productId': 'no_ads_monthly',
              'transactionId': 'txn_test',
              'noAdsActivated': false,
              'coinGranted': 0,
              'failureReason': 'invalid receipt',
              'verifiedAt': null,
            }),
            200,
          );
        }
        return http.Response(
          jsonEncode({
            'status': 'verified',
            'userId': 'user_001',
            'productId': 'no_ads_monthly',
            'transactionId': 'txn_test',
            'noAdsActivated': true,
            'coinGranted': 0,
            'failureReason': null,
            'verifiedAt': DateTime.now().toIso8601String(),
          }),
          200,
        );
      }

      return http.Response(jsonEncode({'message': 'not found'}), 404);
    }),
  );
}

Widget _appWithOverrides({
  required RunpetApiClient apiClient,
  required _FakePurchaseService purchaseService,
}) {
  const session = AuthSessionModel(
    accessToken: 'access_test',
    refreshToken: 'refresh_test',
    sessionId: 'session_test',
    user: UserProfileModel(
      userId: 'user_001',
      username: 'test_user',
      displayName: 'Test User',
    ),
  );

  return ProviderScope(
    overrides: [
      apiClientProvider.overrideWithValue(apiClient),
      authControllerProvider.overrideWith((ref) => _FakeAuthController(apiClient: apiClient, session: session)),
      purchaseServiceProvider.overrideWithValue(purchaseService),
      runSessionControllerProvider.overrideWith((ref) => _FakeRunSessionController()),
    ],
    child: const RunpetApp(),
  );
}

void main() {
  group('App user scenarios', () {
    testWidgets('Scenario 1: launch and base navigation', (tester) async {
      final purchaseService = _FakePurchaseService();
      await tester.pumpWidget(
        _appWithOverrides(apiClient: _apiClient(), purchaseService: purchaseService),
      );
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Running'), findsOneWidget);
      expect(find.text('Pet'), findsOneWidget);
      expect(find.text('Report'), findsOneWidget);
    });

    testWidgets('Scenario 2: start run session', (tester) async {
      final purchaseService = _FakePurchaseService();
      await tester.pumpWidget(
        _appWithOverrides(apiClient: _apiClient(), purchaseService: purchaseService),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Start run'));
      await tester.pumpAndSettle();

      expect(find.text('Running tracker'), findsOneWidget);
      expect(find.text('Finish run'), findsOneWidget);
    });

    testWidgets('Scenario 3: finish run and show result', (tester) async {
      final purchaseService = _FakePurchaseService();
      await tester.pumpWidget(
        _appWithOverrides(apiClient: _apiClient(), purchaseService: purchaseService),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Start run'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Finish run'));
      await tester.pumpAndSettle();

      expect(find.text('Run complete'), findsOneWidget);
      expect(find.textContaining('EXP gained'), findsOneWidget);
    });

    testWidgets('Scenario 4: equip pet item', (tester) async {
      final purchaseService = _FakePurchaseService();
      await tester.pumpWidget(
        _appWithOverrides(apiClient: _apiClient(), purchaseService: purchaseService),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Pet'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Equip sample hat'));
      await tester.pumpAndSettle();

      expect(find.text('hat_leaf_cap'), findsOneWidget);
    });

    testWidgets('Scenario 5: shop product load', (tester) async {
      final purchaseService = _FakePurchaseService();
      await tester.pumpWidget(
        _appWithOverrides(apiClient: _apiClient(), purchaseService: purchaseService),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Pet'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Open shop'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Open shop'));
      await tester.pumpAndSettle();

      expect(find.text('Shop'), findsOneWidget);
    });

    testWidgets('Scenario 6: purchase verify success', (tester) async {
      final purchaseService = _FakePurchaseService();
      await tester.pumpWidget(
        _appWithOverrides(apiClient: _apiClient(), purchaseService: purchaseService),
      );
      await tester.pumpAndSettle();

      await purchaseService.emitPurchased(
        productId: 'no_ads_monthly',
        transactionId: 'txn_ok',
        receiptToken: 'token_ok_123456',
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Purchase verified'), findsOneWidget);
    });

    testWidgets('Scenario 7: purchase verify failure', (tester) async {
      final purchaseService = _FakePurchaseService();
      await tester.pumpWidget(
        _appWithOverrides(apiClient: _apiClient(paymentFail: true), purchaseService: purchaseService),
      );
      await tester.pumpAndSettle();

      await purchaseService.emitPurchased(
        productId: 'no_ads_monthly',
        transactionId: 'txn_fail',
        receiptToken: 'token_fail_123456',
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Purchase not verified'), findsOneWidget);
    });

    testWidgets('Scenario 8: API down handling on pet load', (tester) async {
      final purchaseService = _FakePurchaseService();
      await tester.pumpWidget(
        _appWithOverrides(apiClient: _apiClient(petLoadFail: true), purchaseService: purchaseService),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Failed to load pet'), findsOneWidget);
    });
  });
}
