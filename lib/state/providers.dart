import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runpet_app/config/app_config.dart';
import 'package:runpet_app/services/in_app_purchase_service.dart';
import 'package:runpet_app/services/location_service.dart';
import 'package:runpet_app/services/runpet_api_client.dart';
import 'package:runpet_app/state/run_session_controller.dart';
import 'package:runpet_app/state/run_session_state.dart';

const kUserId = 'user_001';

final apiClientProvider = Provider<RunpetApiClient>((ref) {
  return RunpetApiClient(baseUrl: AppConfig.apiBaseUrl);
});

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

final purchaseServiceProvider = Provider<PurchaseService>((ref) {
  return InAppPurchaseService();
});

final runSessionControllerProvider =
    StateNotifierProvider<RunSessionController, RunSessionState>((ref) {
  return RunSessionController(
    apiClient: ref.watch(apiClientProvider),
    locationService: ref.watch(locationServiceProvider),
    userId: kUserId,
  );
});
