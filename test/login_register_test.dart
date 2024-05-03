import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mp5/main.dart';

void main() {
  testWidgets('Initial state - Login and Register UI',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: MyApp(),
    ));

    // Find widgets present on the initial screen
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Register'), findsOneWidget);
    expect(find.byType(TextField),
        findsNWidgets(2)); // Assuming two text fields exist
  });

  testWidgets('Enter username and password', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: LoginRegisterScreen(isDarkMode: true),
    ));

    final usernameField = find.byWidgetPredicate(
      (widget) =>
          widget is TextField && widget.decoration?.labelText == 'Username',
    );
    final passwordField = find.byWidgetPredicate(
      (widget) =>
          widget is TextField && widget.decoration?.labelText == 'Password',
    );

    await tester.enterText(usernameField, 'vijay');
    await tester.enterText(passwordField, 'bharvad');

    expect(find.text('vijay'), findsOneWidget);
    expect(find.text('bharvad'), findsOneWidget);
  });

  testWidgets('Tap Register button', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: LoginRegisterScreen(isDarkMode: true),
    ));

    final registerButton = find.text('Register');
    await tester.tap(registerButton);
    await tester.pump();

    // Add expectations based on the expected behavior after tapping the Register button
    // For example:
    expect(find.text('Enter your registration details'), findsOneWidget);
  });

  testWidgets('Tap Login button', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: LoginRegisterScreen(isDarkMode: true),
    ));

    final loginButton = find.text('Login');
    await tester.tap(loginButton);
    await tester.pump();

    // Add expectations based on the expected behavior after tapping the Login button
    // For example:
    expect(find.text('Enter your login credentials'), findsOneWidget);
  });
}
