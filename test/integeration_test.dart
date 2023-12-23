import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listify/src/presentation/HomePage.dart';
import 'package:listify/main.dart' as app;

void main() {
  testWidgets('Complete App Flow Test', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
  });

  group('WelcomeBack Integration Tests', () {
    testWidgets('should login with valid credentials',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final Finder emailField = find.byKey(const Key('Email'));
      final Finder passwordField = find.byKey(const Key('Password'));
      final Finder loginButton = find.byKey(const Key('Login'));

      // Enter valid email and password
      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'validPassword');

      // Tap on the login button
      await tester.tap(loginButton);
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
