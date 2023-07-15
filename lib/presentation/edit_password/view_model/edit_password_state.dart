/// Represents the state of the edit password screen.
class EditPasswordState {
  final String currentPassword;
  final String password;
  final String checkPassword;
  final bool isEditing;

  /// Creates a new instance of [EditPasswordState].
  const EditPasswordState({
    required this.currentPassword,
    required this.password,
    required this.checkPassword,
    required this.isEditing,
  });

  /// Creates the initial state for the edit password screen.
  factory EditPasswordState.initial() {
    return const EditPasswordState(
      currentPassword: '',
      password: '',
      checkPassword: '',
      isEditing: false,
    );
  }

  /// Creates a copy of this state object with the specified changes.
  EditPasswordState copyWith({
    String? currentPassword,
    String? password,
    String? checkPassword,
    bool? isEditing,
  }) {
    return EditPasswordState(
      currentPassword: currentPassword ?? this.currentPassword,
      password: password ?? this.password,
      checkPassword: checkPassword ?? this.checkPassword,
      isEditing: isEditing ?? this.isEditing,
    );
  }
}
