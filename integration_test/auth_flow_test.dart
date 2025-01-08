import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:solutech_interview/main.dart';
import 'package:solutech_interview/data/repositories/auth_repository.dart';
import 'package:solutech_interview/data/repositories/habit_repository.dart';
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Flow Test', () {
    testWidgets('Complete auth flow - signup, login, and logout',
        (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(HabitTracker(
        authRepository: AuthRepository(),
        habitRepository: HabitRepository(),
      ));
      await tester.pumpAndSettle();

      // Verify we're on the login page
      expect(find.text('Welcome Back'), findsOneWidget);

      // Navigate to signup
      await tester.tap(find.text('Don\'t have an account? Sign up'));
      await tester.pumpAndSettle();

      // Verify we're on the signup page
      expect(find.text('Create Account'), findsOneWidget);

      // Fill in signup form
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'test_${DateTime.now().millisecondsSinceEpoch}@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'Password123!',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm Password'),
        'Password123!',
      );

      // Submit signup form
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
      await tester.pumpAndSettle();

      // Verify success dialog
      expect(find.text('Success!'), findsOneWidget);

      // Go to login
      await tester.tap(find.text('Go to Login'));
      await tester.pumpAndSettle();

      // Verify we're back on login page
      expect(find.text('Welcome Back'), findsOneWidget);

      // Fill in login form
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'Password123!',
      );

      // Submit login form
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();

      // Verify success dialog
      expect(find.text('Welcome Back!'), findsOneWidget);

      // Continue to home
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Verify we're on home page
      expect(find.text('Habit Tracker'), findsOneWidget);

      // Logout
      await tester.tap(find.byIcon(Icons.logout));
      await tester.pumpAndSettle();

      // Verify we're back on login page
      expect(find.text('Welcome Back'), findsOneWidget);
    });

    testWidgets('Login validation test', (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(HabitTracker(
        authRepository: AuthRepository(),
        habitRepository: HabitRepository(),
      ));
      await tester.pumpAndSettle();

      // Try to login without entering credentials
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pump();

      // Verify validation messages
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('Signup validation test', (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(HabitTracker(
        authRepository: AuthRepository(),
        habitRepository: HabitRepository(),
      ));
      await tester.pumpAndSettle();

      // Navigate to signup
      await tester.tap(find.text('Don\'t have an account? Sign up'));
      await tester.pumpAndSettle();

      // Try to signup without entering credentials
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
      await tester.pump();

      // Verify validation messages
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter a password'), findsOneWidget);
      expect(find.text('Please confirm your password'), findsOneWidget);

      // Test password mismatch
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'Password123!',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm Password'),
        'DifferentPassword123!',
      );
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
      await tester.pump();

      expect(find.text('Passwords do not match'), findsOneWidget);
    });
  });
} 