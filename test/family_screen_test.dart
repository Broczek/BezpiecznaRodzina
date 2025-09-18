import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bezpieczna_rodzina/core/models/user_model.dart';
import 'package:bezpieczna_rodzina/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bezpieczna_rodzina/features/family/presentation/bloc/family_bloc.dart';
import 'package:bezpieczna_rodzina/features/family/presentation/screens/family_list_screen.dart';
import 'package:bezpieczna_rodzina/l10n/app_localizations.dart';

// Mocks for BLoCs
class MockAuthBloc extends Mock implements AuthBloc {}
class MockFamilyBloc extends Mock implements FamilyBloc {}

void main() {
  // Declare late final variables for the mock BLoCs
  late MockAuthBloc mockAuthBloc;
  late MockFamilyBloc mockFamilyBloc;

  // This setup runs before each test
  setUp(() {
    mockAuthBloc = MockAuthBloc();
    mockFamilyBloc = MockFamilyBloc();
  });

  // Helper function to pump the widget with all necessary providers
  Future<void> pumpWidget(
    WidgetTester tester, {
    required AuthState authState,
    required FamilyState familyState,
  }) async {
    // Stub the initial states and streams of the BLoCs
    when(() => mockAuthBloc.state).thenReturn(authState);
    when(() => mockFamilyBloc.state).thenReturn(familyState);
    
    // CRITICAL FIX: Stub the streams for BOTH blocs to prevent null errors.
    when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockFamilyBloc.stream).thenAnswer((_) => const Stream.empty());
    
    // The key change is to wrap MaterialApp with MultiBlocProvider
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>.value(value: mockAuthBloc),
          BlocProvider<FamilyBloc>.value(value: mockFamilyBloc),
        ],
        child: const MaterialApp(
          locale: Locale('pl'), // Explicitly set the locale to Polish
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: FamilyListScreen(),
        ),
      ),
    );
  }

  group('FamilyListScreen', () {
    const adminUser = User(id: '1', username: 'admin', password: 'password', role: UserRole.admin);
    const viewerUser = User(id: '2', username: 'viewer', password: 'password', role: UserRole.viewer);

    testWidgets('shows "Add User" button for admin users when list is empty', (tester) async {
      // Arrange
      await pumpWidget(
        tester,
        authState: const AuthState(status: AuthStatus.authenticated, user: adminUser),
        familyState: const FamilyLoaded([]), // Empty list of family members
      );
      
      // Act & Assert
      // After pumping, the UI should reflect the empty state.
      expect(find.text('Dodaj pierwszego użytkownika'), findsOneWidget);
    });

    testWidgets('does NOT show "Add User" button for viewer users when list is empty', (tester) async {
      // Arrange
      await pumpWidget(
        tester,
        authState: const AuthState(status: AuthStatus.authenticated, user: viewerUser),
        familyState: const FamilyLoaded([]),
      );

      // Act & Assert
      // Verify the empty state text is present
      expect(find.text('Brak dodanych użytkowników'), findsOneWidget);
      // Verify that no "Add User" buttons are present for a viewer
      expect(find.byType(ElevatedButton), findsNothing);
      expect(find.byType(OutlinedButton), findsNothing);
    });

     testWidgets('shows loading indicator when family state is loading', (tester) async {
      // Arrange
      await pumpWidget(
        tester,
        authState: const AuthState(status: AuthStatus.authenticated, user: adminUser),
        familyState: FamilyLoading(), // Set state to loading
      );

      // Act & Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

     testWidgets('shows initial loading indicator when family state is initial', (tester) async {
      // Arrange
      await pumpWidget(
        tester,
        authState: const AuthState(status: AuthStatus.authenticated, user: adminUser),
        familyState: FamilyInitial(), // Set state to initial
      );
      
      // Act & Assert
      // The widget will show a loading indicator while it dispatches the fetch event.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}