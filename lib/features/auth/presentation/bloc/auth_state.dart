part of 'auth_bloc.dart';

// Represents the state of the authentication process.
// It holds the current status, the authenticated user (if any),
// and potential error messages. This state is consumed by the UI
// and the router to react to authentication changes.
enum AuthStatus { unknown, authenticated, unauthenticated, loading, failure }

// Specifies which login field caused an error, allowing the UI to highlight it.
enum LoginErrorField { none, username, password }

class AuthState extends Equatable {
  // The current authentication status of the application.
  final AuthStatus status;
  // The currently logged-in user. Null if unauthenticated.
  final User? user;
  // An error message to be displayed in case of a failure.
  final String? errorMessage;
  // The specific form field associated with a login error.
  final LoginErrorField errorField;

  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.errorMessage,
    this.errorField = LoginErrorField.none,
  });

  // A factory constructor for a successfully authenticated state.
  const AuthState.authenticated(User user)
      : this(status: AuthStatus.authenticated, user: user);

  // A factory constructor for an unauthenticated state.
  const AuthState.unauthenticated()
      : this(status: AuthStatus.unauthenticated);

  // Creates a copy of the current state with updated values.
  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
    LoginErrorField? errorField,
    bool clearUser = false, // Flag to explicitly nullify the user.
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      errorField: errorField ?? this.errorField,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage, errorField];
}
