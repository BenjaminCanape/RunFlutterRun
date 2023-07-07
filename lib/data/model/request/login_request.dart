import 'package:equatable/equatable.dart';

/// Represents a login request object.
class LoginRequest extends Equatable {
  /// The username for the login request.
  final String username;

  /// The password for the login request.
  final String password;

  /// Constructs a LoginRequest object with the given parameters.
  const LoginRequest({
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [username, password];

  /// Converts the LoginRequest object to a JSON map.
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
    };
  }

  @override
  bool get stringify => true;
}
