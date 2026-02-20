import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runpet_app/models/auth_models.dart';
import 'package:runpet_app/services/auth_session_storage.dart';
import 'package:runpet_app/services/runpet_api_client.dart';
import 'package:runpet_app/state/auth_state.dart';

class AuthController extends StateNotifier<AuthState> {
  AuthController({
    required RunpetApiClient apiClient,
    required AuthSessionStorage sessionStorage,
  })  : _apiClient = apiClient,
        _sessionStorage = sessionStorage,
        super(const AuthState.initial());

  final RunpetApiClient _apiClient;
  final AuthSessionStorage _sessionStorage;

  Future<void> initialize() async {
    if (state.isInitialized) return;
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final saved = await _sessionStorage.read();
      if (saved == null) {
        state = state.copyWith(
          isInitialized: true,
          isLoading: false,
          clearSession: true,
          clearError: true,
        );
        return;
      }

      _apiClient.setAuthSession(saved);
      state = state.copyWith(session: saved, clearError: true);
      await refreshSession();
      state = state.copyWith(
        isInitialized: true,
        isLoading: false,
        clearError: true,
      );
    } catch (e) {
      _apiClient.setAuthSession(null);
      await _sessionStorage.clear();
      state = state.copyWith(
        isInitialized: true,
        isLoading: false,
        clearSession: true,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final session = await _apiClient.login(
        username: username,
        password: password,
      );
      _apiClient.setAuthSession(session);
      await _sessionStorage.write(session);
      state = state.copyWith(
        isLoading: false,
        session: session,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> registerAndLogin({
    required String username,
    required String password,
    required String displayName,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _apiClient.register(
        username: username,
        password: password,
        displayName: displayName,
      );
      final session = await _apiClient.login(
        username: username,
        password: password,
      );
      _apiClient.setAuthSession(session);
      await _sessionStorage.write(session);
      state = state.copyWith(
        isLoading: false,
        session: session,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<AuthSessionModel?> refreshSession() async {
    final session = state.session;
    if (session == null) return null;

    try {
      final refreshed = await _apiClient.refresh(
        sessionId: session.sessionId,
        refreshToken: session.refreshToken,
      );
      _apiClient.setAuthSession(refreshed);
      await _sessionStorage.write(refreshed);
      state = state.copyWith(session: refreshed, clearError: true);
      return refreshed;
    } catch (_) {
      _apiClient.setAuthSession(null);
      await _sessionStorage.clear();
      state = state.copyWith(clearSession: true, clearError: true);
      return null;
    }
  }

  Future<void> logout({bool allSessions = false}) async {
    final session = state.session;
    if (session != null) {
      try {
        if (allSessions) {
          await _apiClient.logoutAll();
        } else {
          await _apiClient.logout(
            sessionId: session.sessionId,
            refreshToken: session.refreshToken,
          );
        }
      } catch (_) {
        // Intentionally ignore to allow local logout.
      }
    }

    _apiClient.setAuthSession(null);
    await _sessionStorage.clear();
    state = state.copyWith(
      clearSession: true,
      clearError: true,
      isLoading: false,
    );
  }
}
