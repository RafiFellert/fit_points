import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_app_flutter/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Find all add icon buttons
    final Finder addButtons = find.byIcon(Icons.add);
    expect(addButtons, findsWidgets);

    // Tap the first add button and rebuild the widget
    await tester.tap(addButtons.first);
    await tester.pump();

    // Optionally verify updated text or state here
  });

  testWidgets('All add buttons are present', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // There should be at least one add button
    final Finder addButtons = find.byIcon(Icons.add);
    expect(addButtons, findsAtLeastNWidgets(1));
  });

  testWidgets('Tapping all add buttons does not throw', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final Finder addButtons = find.byIcon(Icons.add);
    final int count = addButtons.evaluate().length;

    for (int i = 0; i < count; i++) {
      await tester.tap(addButtons.at(i));
      await tester.pump();
    }

    // Optionally verify updated text or state here
  });
}
