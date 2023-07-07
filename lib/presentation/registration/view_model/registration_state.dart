/// Represents the state of the registration screen.
class RegistrationState {
  final String username;
  final String password;
  final String checkPassword;
  final bool isLogging;

  /// Creates a new instance of [RegistrationState].
  const RegistrationState({
    required this.username,
    required this.password,
    required this.checkPassword,
    required this.isLogging,
  });

  /// Creates the initial state for the registration screen.
  factory RegistrationState.initial() {
    return const RegistrationState(
      username: '',
      password: '',
      checkPassword: '',
      isLogging: false,
    );
  }

  /// Creates a copy of this state object with the specified changes.
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
