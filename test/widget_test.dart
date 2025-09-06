// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:jihudumie_customer_app/main.dart';

void main() {
  testWidgets('App loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const JihudumieApp());

    // Verify that our app loads with the welcome text.
    expect(find.text('Welcome to Jihudumie'), findsOneWidget);
    expect(
      find.text('Your one-stop shop for everything you need'),
      findsOneWidget,
    );
  });
}
