import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Main menu shows and has Text Field button', (
    WidgetTester tester,
  ) async {
    // Build the app

    // Ensure the main menu title is shown
    expect(find.text('Main Menu'), findsOneWidget);

    // Ensure the navigation button exists
    expect(find.text('Text Field'), findsOneWidget);

    // Tap the navigation button and navigate to the Text Field page
    await tester.tap(find.text('Text Field'));
    await tester.pumpAndSettle();

    // After navigation, there should be at least one TextField on the page
    expect(find.byType(TextField), findsWidgets);
  });
}
