import 'package:equatable/equatable.dart';

/// Represents a send new password request object.
class SendNewPasswordRequest extends Equatable {
  /// The email for the send new password request.
  final String email;

  /// Constructs a SendNewPasswordRequest object with the given parameters.
  const SendNewPasswordRequest({required this.email});

  @override
  List<Object?> get props => [email];

  /// Converts the SendNewPasswordRequest object to a JSON map.
  Map<String, dynamic> toMap() {
    return {'email': email};
  }

  @override
  bool get stringify => true;
}
