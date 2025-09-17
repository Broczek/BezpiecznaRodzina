// Defines custom exception types for the authentication feature.
// This allows for more specific error handling in the BLoC and UI layers
// compared to using generic Exception classes.

// A base class for all authentication-related exceptions.
class AuthException implements Exception {
  final String message;
  AuthException(this.message);
  @override
  String toString() => message;
}

// Thrown when a login attempt is made with a username that does not exist.
class UserNotFoundException extends AuthException {
  UserNotFoundException() : super('A user with the given login does not exist.');
}

// Thrown when a login attempt is made with an incorrect password.
class WrongPasswordException extends AuthException {
  WrongPasswordException() : super('The entered password is incorrect.');
}

// Thrown during account recovery if the provided email is not found.
class EmailNotFoundException extends AuthException {
  EmailNotFoundException() : super('The provided email is not associated with any account.');
}
