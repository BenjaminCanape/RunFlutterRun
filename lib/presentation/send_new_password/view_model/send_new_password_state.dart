/// Represents the state of the send new password screen.
class SendNewPasswordState {
  /// The username entered by the user.
  final String email;

  /// Indicates whether the mail is sending
  final bool isSending;

  const SendNewPasswordState({
    required this.email,
    required this.isSending,
  });

  /// Creates an initial instance of [SendNewPasswordState].
  factory SendNewPasswordState.initial() {
    return const SendNewPasswordState(
      email: '',
      isSending: false,
    );
  }

  /// Creates a copy of [SendNewPasswordState] with the specified fields replaced with new values.
  SendNewPasswordState copyWith({
    String? email,
    bool? isSending,
  }) {
    return SendNewPasswordState(
      email: email ?? this.email,
      isSending: isSending ?? this.isSending,
    );
  }
}
