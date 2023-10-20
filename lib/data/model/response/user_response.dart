import 'package:equatable/equatable.dart';
import '../../../domain/entities/user.dart';

/// Represents a response object for a user.
class UserResponse extends Equatable {
  /// The ID of the user.
  final String id;

  /// The username of the user
  final String username;

  /// Constructs an UserResponse object with the given parameters.
  const UserResponse({required this.id, required this.username});

  @override
  List<Object?> get props => [id, username];

  /// Creates an UserResponse object from a JSON map.
  factory UserResponse.fromMap(Map<String, dynamic> map) {
    return UserResponse(id: map['id'].toString(), username: map['username']);
  }

  /// Converts the UserResponse object to a User entity.
  User toEntity() {
    return User(id: id, username: username);
  }
}
