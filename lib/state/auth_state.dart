import 'package:runpet_app/models/auth_models.dart';

class AuthState {
  const AuthState({
    required this.isLoading,
    required this.session,
    required this.errorMessage,
  });

  const AuthState.initial()
      : isLoading = false,
        session = null,
        errorMessage = null;

  final bool isLoading;
  final AuthSessionModel? session;
  final String? errorMessage;

  bool get isAuthenticated => session != null;

  AuthState copyWith({
    bool? isLoading,
    AuthSessionModel? session,
    bool clearSession = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      session: clearSession ? null : (session ?? this.session),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
