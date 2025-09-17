import 'package:equatable/equatable.dart';

enum UserRole { admin, standard, viewer }

class User extends Equatable {
  final String id;
  final String username;
  final String password;
  final UserRole role;

  const User({
    required this.id,
    required this.username,
    required this.password,
    required this.role,
  });

  @override
  List<Object> get props => [id, username, password, role];
}
