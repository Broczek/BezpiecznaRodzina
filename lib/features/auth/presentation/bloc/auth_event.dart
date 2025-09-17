part of 'auth_bloc.dart';

// Defines the events that can be dispatched to the AuthBloc.
// These events represent user actions or system triggers related to authentication.
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

// Event dispatched when the user attempts to log in with credentials.
class AuthLoginRequested extends AuthEvent {
  final String username;
  final String password;
  const AuthLoginRequested({required this.username, required this.password});
}

// Event dispatched when the user requests to log out.
class AuthLogoutRequested extends AuthEvent {}
