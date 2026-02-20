import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runpet_app/app/runpet_app.dart';
import 'package:runpet_app/models/auth_models.dart';
import 'package:runpet_app/services/auth_session_storage.dart';
import 'package:runpet_app/services/runpet_api_client.dart';
import 'package:runpet_app/state/auth_controller.dart';
import 'package:runpet_app/state/auth_state.dart';
import 'package:runpet_app/state/providers.dart';

class _FakeAuthSessionStorage implements AuthSessionStorage {
  @override
  Future<void> clear() async {}

  @override
  Future<AuthSessionModel?> read() async => null;

  @override
  Future<void> write(AuthSessionModel session) async {}
}

class _FakeAuthController extends AuthController {
  _FakeAuthController({
    required RunpetApiClient apiClient,
    required AuthSessionModel session,
  }) : super(apiClient: apiClient, sessionStorage: _FakeAuthSessionStorage()) {
    state = AuthState(
      isInitialized: true,
      isLoading: false,
      session: session,
      errorMessage: null,
    );
    apiClient.setAuthSession(session);
  }

  @override
  Future<void> initialize() async {}
}

void main() {
  testWidgets('shows bottom tabs for MVP shell', (WidgetTester tester) async {
    final apiClient = RunpetApiClient(baseUrl: 'http://localhost:8080');
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

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          apiClientProvider.overrideWithValue(apiClient),
          authControllerProvider.overrideWith((ref) => _FakeAuthController(apiClient: apiClient, session: session)),
        ],
        child: const RunpetApp(),
      ),
    );

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Running'), findsOneWidget);
    expect(find.text('Pet'), findsOneWidget);
    expect(find.text('Report'), findsOneWidget);
  });
}
