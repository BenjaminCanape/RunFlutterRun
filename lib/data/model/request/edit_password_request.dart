import 'package:equatable/equatable.dart';

/// Represents a edit password request object.
class EditPasswordRequest extends Equatable {
  /// The currentPassword for the request.
  final String currentPassword;

  /// The password for the request.
  final String password;

  /// Constructs a EditPasswordRequest object with the given parameters.
  const EditPasswordRequest({
    required this.currentPassword,
    required this.password,
  });

  @override
  List<Object?> get props => [currentPassword, password];

  /// Converts the EditPasswordRequest object to a JSON map.
  Map<String, dynamic> toMap() {
    return {
      'currentPassword': currentPassword,
      'password': password,
    };
  }

  @override
  bool get stringify => true;
}
