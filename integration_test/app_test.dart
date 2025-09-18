import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:bezpieczna_rodzina/main.dart' as app;
import 'package:bezpieczna_rodzina/features/auth/presentation/screens/login_screen.dart';
import 'package:bezpieczna_rodzina/features/zones/presentation/screens/zones_screen.dart';
import 'package:bezpieczna_rodzina/features/family/presentation/screens/family_list_screen.dart';
import 'package:bezpieczna_rodzina/features/menu/presentation/screens/menu_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    testWidgets('Full Login and Navigation Flow', (WidgetTester tester) async {
      // Arrange: Start the application.
      app.main();
      await tester.pumpAndSettle();

      // --- Step 1: Navigate to Login Screen ---
      // Use the key we added to find the button reliably.
      final loginButtonFinder = find.byKey(const ValueKey('home_login_button'));
      expect(loginButtonFinder, findsOneWidget);
      await tester.tap(loginButtonFinder);
      await tester.pumpAndSettle(); // Wait for navigation to complete.

      // --- Step 2: Perform Login ---
      // Verify we are on the login screen.
      expect(find.byType(LoginScreen), findsOneWidget);

      // Enter credentials using the keys we added.
      // NOTE: This assumes a mock user 'admin' with 'password' exists in your AuthRepository.
      await tester.enterText(find.byKey(const ValueKey('username_field')), 'admin');
      await tester.enterText(find.byKey(const ValueKey('password_field')), 'password');

      // Tap the login button.
      final submitButtonFinder = find.byKey(const ValueKey('login_submit_button'));
      await tester.tap(submitButtonFinder);
      await tester.pumpAndSettle(const Duration(seconds: 2)); // Wait for mock login and navigation.

      // --- Step 3: Verify Successful Navigation to ZonesScreen ---
      // After successful login, the app should redirect to the main screen.
      expect(find.byType(ZonesScreen), findsOneWidget);
      // Check for a known element on the ZonesScreen, like the title in the search bar.
      expect(find.text('Strefy Bezpieczeństwa'), findsOneWidget);

      // --- Step 4: Navigate using BottomNavigationBar ---
      // Tap on the 'Users' tab. Using text is more reliable than icons for nav items.
      await tester.tap(find.text('Użytkownicy'));
      await tester.pumpAndSettle();
      // Verify navigation to FamilyListScreen.
      expect(find.byType(FamilyListScreen), findsOneWidget);
      // The text "Użytkownicy" will be found twice: in AppBar and BottomNavBar.
      expect(find.text('Użytkownicy'), findsWidgets);

      // Tap on the 'Menu' tab.
      await tester.tap(find.text('Menu'));
      await tester.pumpAndSettle();
      // Verify navigation to MenuScreen.
      expect(find.byType(MenuScreen), findsOneWidget);
      expect(find.text('Menu'), findsWidgets);
    });
  });
}

