import 'package:runpet_app/models/auth_models.dart';

class AuthState {
  const AuthState({
    required this.isInitialized,
    required this.isLoading,
    required this.session,
    required this.errorMessage,
  });

  const AuthState.initial()
      : isInitialized = false,
        isLoading = false,
        session = null,
        errorMessage = null;

  final bool isInitialized;
  final bool isLoading;
  final AuthSessionModel? session;
  final String? errorMessage;

  bool get isAuthenticated => session != null;

  AuthState copyWith({
    bool? isInitialized,
    bool? isLoading,
    AuthSessionModel? session,
    bool clearSession = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState(
      isInitialized: isInitialized ?? this.isInitialized,
      isLoading: isLoading ?? this.isLoading,
      session: clearSession ? null : (session ?? this.session),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
