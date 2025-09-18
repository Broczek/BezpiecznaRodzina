import 'package:bloc_test/bloc_test.dart';
import 'package:bezpieczna_rodzina/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bezpieczna_rodzina/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bezpieczna_rodzina/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Mock BLoC for testing UI reactions without real logic.
class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  late AuthBloc authBloc;

  setUp(() {
    authBloc = MockAuthBloc();
  });

  // Helper function to pump the widget with necessary providers.
  Future<void> pumpLoginScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'), // Use a specific locale for predictable text
        home: BlocProvider.value(
          value: authBloc,
          child: const LoginScreen(),
        ),
      ),
    );
  }

  group('LoginScreen', () {
    testWidgets('renders initial layout correctly', (WidgetTester tester) async {
      // Arrange: Set the initial state of the mock BLoC.
      when(() => authBloc.state).thenReturn(const AuthState.unauthenticated());
      
      // Act: Build the widget.
      await pumpLoginScreen(tester);

      // Assert: Verify that the expected widgets are on screen.
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Log In'), findsNWidgets(2)); // AppBar title and Button text
      expect(find.text('Login / Username'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('shows CircularProgressIndicator when status is loading', (WidgetTester tester) async {
      // Arrange: Set the state to loading.
      when(() => authBloc.state).thenReturn(const AuthState(status: AuthStatus.loading));

      // Act
      await pumpLoginScreen(tester);

      // Assert: Verify the loading indicator is shown and the button is disabled.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull); // onPressed is null when disabled
    });
    
    testWidgets('shows validation error when form is submitted with empty fields', (WidgetTester tester) async {
       // Arrange
      when(() => authBloc.state).thenReturn(const AuthState.unauthenticated());
      await pumpLoginScreen(tester);

      // Act: Tap the login button without entering text.
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump(); // Rebuild the widget to show validation messages.

      // Assert
      expect(find.text('Field required'), findsNWidgets(2));
    });

    testWidgets('adds AuthLoginRequested event when form is valid and submitted', (WidgetTester tester) async {
      // Arrange
      when(() => authBloc.state).thenReturn(const AuthState.unauthenticated());
      await pumpLoginScreen(tester);

      // Act: Enter text and tap the button.
      await tester.enterText(find.byKey(const Key('username_field')), 'testuser');
      await tester.enterText(find.byKey(const Key('password_field')), 'password');
      await tester.tap(find.byType(ElevatedButton));

      // Assert: Verify that the correct event was added to the BLoC.
      verify(() => authBloc.add(const AuthLoginRequested(username: 'testuser', password: 'password'))).called(1);
    });
  });
}
