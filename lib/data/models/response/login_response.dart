class LoginResponse {
  final String refreshToken;
  final String token;
  final String message;

  const LoginResponse({
    required this.refreshToken,
    required this.token,
    required this.message,
  });

  factory LoginResponse.fromMap(Map<String, dynamic> map) {
    return LoginResponse(
      refreshToken: map['refreshToken']?.toString() ?? '',
      token: map['token']?.toString() ?? '',
      message: map['message']?.toString() ?? '',
    );
  }
}
