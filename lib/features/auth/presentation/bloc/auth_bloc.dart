import 'package:bezpieczna_rodzina/core/models/subuser_model.dart';
import 'package:bezpieczna_rodzina/core/models/user_model.dart';
import 'package:bezpieczna_rodzina/features/auth/data/auth_exceptions.dart';
import 'package:bezpieczna_rodzina/features/auth/data/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

// This BLoC manages the global authentication state of the application.
// It handles login and logout events, interacts with the AuthRepository,
// and emits AuthState changes that the UI and router can react to.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthState.unauthenticated()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  // Handles the AuthLoginRequested event.
  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Set state to loading while processing the request.
    emit(state.copyWith(status: AuthStatus.loading, errorField: LoginErrorField.none));
    try {
      // Attempt to log in via the repository.
      final dynamic loggedInUser = await _authRepository.login(
        username: event.username,
        password: event.password,
      );

      // Handle the user type returned by the repository.
      // This allows both main users and sub-users to log in.
      if (loggedInUser is User) {
        emit(AuthState.authenticated(loggedInUser));
      } else if (loggedInUser is SubUser) {
        // Convert SubUser to a generic User model for consistent state.
        final userFromSubUser = User(
          id: loggedInUser.id,
          username: loggedInUser.username,
          password: loggedInUser.password,

          role: loggedInUser.role == SubUserRole.standard
              ? UserRole.standard
              : UserRole.viewer,
        );
        emit(AuthState.authenticated(userFromSubUser));
      } else {
        throw Exception('Unknown user type during login.');
      }
    } on UserNotFoundException catch (e) {
      // Handle specific exceptions to provide targeted feedback.
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: e.message,
        errorField: LoginErrorField.username,
      ));
    } on WrongPasswordException catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: e.message,
        errorField: LoginErrorField.password,
      ));
    } catch (e) {
      // Handle generic errors.
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: 'An unknown error occurred.',
        errorField: LoginErrorField.none,
      ));
    }
    
    // If the login failed, reset the state back to unauthenticated after a delay
    // to allow the user to see the error message.
    if (state.status == AuthStatus.failure) {
      await Future.delayed(const Duration(seconds: 3));
      if (!isClosed) {
        emit(state.copyWith(status: AuthStatus.unauthenticated, errorField: LoginErrorField.none, errorMessage: null));
      }
    }
  }

  // Handles the AuthLogoutRequested event.
  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.logout();
    // Reset the state to unauthenticated and clear user data.
    emit(state.copyWith(status: AuthStatus.unauthenticated, clearUser: true));
  }
}
