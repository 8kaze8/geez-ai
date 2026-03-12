import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geez_ai/app.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: GeezApp()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
  });
}
