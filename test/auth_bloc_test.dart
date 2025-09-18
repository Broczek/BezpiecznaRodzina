import 'package:bloc_test/bloc_test.dart';
import 'package:bezpieczna_rodzina/features/auth/data/auth_repository.dart';
import 'package:bezpieczna_rodzina/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bezpieczna_rodzina/core/models/user_model.dart';
import 'package:bezpieczna_rodzina/features/auth/data/auth_exceptions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock implementation of AuthRepository for testing purposes.
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('AuthBloc', () {
    late AuthRepository authRepository;
    const mockUser = User(id: '1', username: 'testUser', password: 'password', role: UserRole.admin);

    setUp(() {
      authRepository = MockAuthRepository();
    });

    // Test the initial state of the AuthBloc.
    test('initial state is AuthState.unauthenticated()', () {
      expect(AuthBloc(authRepository: authRepository).state, const AuthState.unauthenticated());
    });

    // Test cases for the login functionality.
    group('AuthLoginRequested', () {
      // Test successful login.
      blocTest<AuthBloc, AuthState>(
        'emits [loading, authenticated] when login is successful',
        setUp: () {
          when(() => authRepository.login(username: 'testUser', password: 'password'))
              .thenAnswer((_) async => mockUser);
        },
        build: () => AuthBloc(authRepository: authRepository),
        act: (bloc) => bloc.add(const AuthLoginRequested(username: 'testUser', password: 'password')),
        expect: () => <AuthState>[
          const AuthState(status: AuthStatus.loading),
          const AuthState.authenticated(mockUser),
        ],
      );

      // Test login failure due to user not found.
      blocTest<AuthBloc, AuthState>(
        'emits [loading, failure, unauthenticated] when UserNotFoundException is thrown',
        setUp: () {
          when(() => authRepository.login(username: 'wrongUser', password: 'password'))
              .thenThrow(UserNotFoundException());
        },
        build: () => AuthBloc(authRepository: authRepository),
        act: (bloc) => bloc.add(const AuthLoginRequested(username: 'wrongUser', password: 'password')),
        wait: const Duration(seconds: 3), // Wait for the delayed state reset
        expect: () => <AuthState>[
          const AuthState(status: AuthStatus.loading),
          AuthState(
            status: AuthStatus.failure,
            errorMessage: UserNotFoundException().message,
            errorField: LoginErrorField.username,
          ),
          const AuthState(
            status: AuthStatus.unauthenticated,
            errorMessage: null,
            errorField: LoginErrorField.none,
          ),
        ],
      );

      // Test login failure due to wrong password.
      blocTest<AuthBloc, AuthState>(
        'emits [loading, failure, unauthenticated] when WrongPasswordException is thrown',
        setUp: () {
          when(() => authRepository.login(username: 'testUser', password: 'wrongPassword'))
              .thenThrow(WrongPasswordException());
        },
        build: () => AuthBloc(authRepository: authRepository),
        act: (bloc) => bloc.add(const AuthLoginRequested(username: 'testUser', password: 'wrongPassword')),
        wait: const Duration(seconds: 3), // Wait for the delayed state reset
        expect: () => <AuthState>[
          const AuthState(status: AuthStatus.loading),
          AuthState(
            status: AuthStatus.failure,
            errorMessage: WrongPasswordException().message,
            errorField: LoginErrorField.password,
          ),
           const AuthState(
            status: AuthStatus.unauthenticated,
            errorMessage: null,
            errorField: LoginErrorField.none,
          ),
        ],
      );
    });
    
    // Test case for the logout functionality.
    group('AuthLogoutRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [unauthenticated] when logout is successful',
        setUp: () {
          when(() => authRepository.logout()).thenAnswer((_) async {});
        },
        build: () => AuthBloc(authRepository: authRepository),
        seed: () => const AuthState.authenticated(mockUser), // Start from an authenticated state
        act: (bloc) => bloc.add(AuthLogoutRequested()),
        expect: () => <AuthState>[
          const AuthState.unauthenticated(),
        ],
      );
    });
  });
}

