import 'dart:ffi';

import 'package:equatable/equatable.dart';

/// Represents a user.
class User extends Equatable {
  /// The ID of the user.
  final Long id;

  /// The username of the user.
  final String username;

  /// Constructs a User object with the given parameters.
  const User({required this.id, required this.username});

  @override
  List<Object?> get props => [id, username];
}
