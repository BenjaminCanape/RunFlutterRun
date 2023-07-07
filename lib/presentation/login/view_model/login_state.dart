/// Represents the state of the login screen.
class LoginState {
  /// The username entered by the user.
  final String username;

  /// The password entered by the user.
  final String password;

  /// Indicates whether the user is currently logging in.
  final bool isLogging;

  const LoginState({
    required this.username,
    required this.password,
    required this.isLogging,
  });

  /// Creates an initial instance of [LoginState].
  factory LoginState.initial() {
    return const LoginState(
      username: '',
      password: '',
      isLogging: false,
    );
  }

  /// Creates a copy of [LoginState] with the specified fields replaced with new values.
  LoginState copyWith({
    String? username,
    String? password,
    bool? isLogging,
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      isLogging: isLogging ?? this.isLogging,
    );
  }
}
