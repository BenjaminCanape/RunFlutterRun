import 'user_response.dart';

/// Represents a response object for a login request.
class LoginResponse {
  /// The refresh token received in the login response.
  final String refreshToken;

  /// The access token (JWT token) received in the login response.
  final String token;

  /// The user received in the login response.
  final UserResponse user;

  /// A message associated with the login response.
  final String message;

  /// Constructs a LoginResponse object with the given parameters.
  const LoginResponse({
    required this.refreshToken,
    required this.token,
    required this.user,
    required this.message,
  });

  /// Creates a LoginResponse object from a JSON map.
  factory LoginResponse.fromMap(Map<String, dynamic> map) {
    return LoginResponse(
      refreshToken: map['refreshToken']?.toString() ?? '',
      token: map['token']?.toString() ?? '',
      user: UserResponse.fromMap(map['user']),
      message: map['message']?.toString() ?? '',
    );
  }
}
