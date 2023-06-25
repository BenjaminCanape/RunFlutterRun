class LoginState {
  final String username;
  final String password;
  final bool isLogging;

  const LoginState({
    required this.username,
    required this.password,
    required this.isLogging,
  });

  factory LoginState.initial() {
    return LoginState(
      username: '',
      password: '',
      isLogging: false,
    );
  }

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
