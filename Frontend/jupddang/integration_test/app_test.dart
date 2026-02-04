import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:jupddang/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App launch test', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Check for Splash Screen
    expect(find.text('Loading...'), findsOneWidget);

    // Wait for Splash Timer (2 seconds)
    await tester.pump(const Duration(seconds: 3));
    // IntroScreen has a repeating animation, so pumpAndSettle will hang.
    // Instead, we just pump a few frames to let the entrance animation start/progress.
    await tester.pump(); 

    // Check for Intro Screen
    expect(find.text('JUPDDANG'), findsOneWidget);
  });
}
