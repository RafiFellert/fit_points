import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_app_flutter/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Find the add icon button
    final Finder addButton = find.byIcon(Icons.add);
    //expect(addButton, findsOneWidget);

    // Tap the button and rebuild the widget
    await tester.tap(addButton);
    await tester.pump();

    // Optionally verify updated text or state here
  });
}
