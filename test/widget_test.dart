import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runpet_app/app/runpet_app.dart';

void main() {
  testWidgets('shows bottom tabs for MVP shell', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: RunpetApp()));
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Running'), findsOneWidget);
    expect(find.text('Pet'), findsOneWidget);
    expect(find.text('Report'), findsOneWidget);
  });
}
