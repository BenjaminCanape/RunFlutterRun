import 'package:equatable/equatable.dart';

/// Represents a user.
class User extends Equatable {
  /// The ID of the user.
  final String id;

  /// The firstname of the user.
  final String? firstname;

  /// The lastname of the user.
  final String? lastname;

  /// The username of the user.
  final String username;

  /// Constructs a User object with the given parameters.
  const User(
      {required this.id,
      required this.username,
      required this.firstname,
      required this.lastname});

  @override
  List<Object?> get props => [id, username, firstname, lastname];
}
