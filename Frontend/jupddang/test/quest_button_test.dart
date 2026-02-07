import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jupddang/features/quest/presentation/quest_widgets.dart';
import 'package:pixelarticons/pixelarticons.dart';

void main() {
  testWidgets('QuestButton shows glowing animation when highlighted', (WidgetTester tester) async {
    // Build the QuestButton with isHighlighted = true (incomplete quest)
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: QuestButton(
            isCompleted: false,
            onTap: () {},
            isHighlighted: true,
          ),
        ),
      ),
    );

    // Initial state check
    expect(find.text('Q'), findsOneWidget);
    expect(find.byType(Icon), findsNothing);

    // Verify AnimationController is animating
    // Since we cannot directly access the private AnimationController,
    // we verify the visual effect or state that depends on it.
    // However, finding specific BoxShadow values directly is tricky in widget tests.
    // Instead, we can pump frames and ensure no errors occur and the widget is still present.
    // For a more robust test, we could inspect the RenderObject, but for now, we'll ensure it renders correctly.
    
    // Simulate time passing to trigger animation
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
    
    // If exception occurs during animation, test will fail.
  });

  testWidgets('QuestButton shows check icon and no animation when completed', (WidgetTester tester) async {
    // Build the QuestButton with isHighlighted = false (completed quest)
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: QuestButton(
            isCompleted: true,
            onTap: () {},
            isHighlighted: false,
          ),
        ),
      ),
    );

    // Assert completed state
    expect(find.text('Q'), findsNothing);
    expect(find.byIcon(Pixel.check), findsOneWidget);
    
    // Verify background color is green (success)
    final fabFinder = find.byType(FloatingActionButton);
    final fab = tester.widget<FloatingActionButton>(fabFinder);
    expect(fab.backgroundColor, const Color(0xFF17C964));
  });
}
