import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runpet_app/config/app_config.dart';
import 'package:runpet_app/services/auth_session_storage.dart';
import 'package:runpet_app/services/in_app_purchase_service.dart';
import 'package:runpet_app/services/location_service.dart';
import 'package:runpet_app/services/runpet_api_client.dart';
import 'package:runpet_app/state/auth_controller.dart';
import 'package:runpet_app/state/auth_state.dart';
import 'package:runpet_app/state/run_session_controller.dart';
import 'package:runpet_app/state/run_session_state.dart';

final apiClientProvider = Provider<RunpetApiClient>((ref) {
  return RunpetApiClient(baseUrl: AppConfig.apiBaseUrl);
});

final authSessionStorageProvider = Provider<AuthSessionStorage>((ref) {
  return LocalAuthSessionStorage();
});

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final sessionStorage = ref.watch(authSessionStorageProvider);
  final controller = AuthController(
    apiClient: apiClient,
    sessionStorage: sessionStorage,
  );
  apiClient.setUnauthorizedHandler(controller.refreshSession);
  return controller;
});

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

final purchaseServiceProvider = Provider<PurchaseService>((ref) {
  return InAppPurchaseService();
});

final runSessionControllerProvider =
    StateNotifierProvider<RunSessionController, RunSessionState>((ref) {
  final authState = ref.watch(authControllerProvider);
  return RunSessionController(
    apiClient: ref.watch(apiClientProvider),
    locationService: ref.watch(locationServiceProvider),
    userId: authState.session?.user.userId ?? '',
  );
});
