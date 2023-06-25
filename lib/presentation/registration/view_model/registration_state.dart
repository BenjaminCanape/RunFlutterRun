class RegistrationState {
  final String username;
  final String password;
  final String checkPassword;
  final bool isLogging;

  const RegistrationState({
    required this.username,
    required this.password,
    required this.checkPassword,
    required this.isLogging,
  });

  factory RegistrationState.initial() {
    return const RegistrationState(
      username: '',
      password: '',
      checkPassword: '',
      isLogging: false,
    );
  }

  RegistrationState copyWith({
    String? username,
    String? password,
    String? checkPassword,
    bool? isLogging,
  }) {
    return RegistrationState(
      username: username ?? this.username,
      password: password ?? this.password,
      checkPassword: checkPassword ?? this.checkPassword,
      isLogging: isLogging ?? this.isLogging,
    );
  }
}
