/// Represents the state of the registration screen.
class RegistrationState {
  final String firstname;
  final String lastname;
  final String username;
  final String password;
  final String checkPassword;
  final bool isLogging;

  /// Creates a new instance of [RegistrationState].
  const RegistrationState({
    required this.firstname,
    required this.lastname,
    required this.username,
    required this.password,
    required this.checkPassword,
    required this.isLogging,
  });

  /// Creates the initial state for the registration screen.
  factory RegistrationState.initial() {
    return const RegistrationState(
      firstname: '',
      lastname: '',
      username: '',
      password: '',
      checkPassword: '',
      isLogging: false,
    );
  }

  /// Creates a copy of this state object with the specified changes.
  RegistrationState copyWith({
    String? firstname,
    String? lastname,
    String? username,
    String? password,
    String? checkPassword,
    bool? isLogging,
  }) {
    return RegistrationState(
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      username: username ?? this.username,
      password: password ?? this.password,
      checkPassword: checkPassword ?? this.checkPassword,
      isLogging: isLogging ?? this.isLogging,
    );
  }
}
