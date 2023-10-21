import 'package:equatable/equatable.dart';

/// Represents a registration request object.
class RegistrationRequest extends Equatable {
  /// The firstname for the registration request.
  final String firstname;

  /// The lastname for the registration request.
  final String lastname;

  /// The username for the registration request.
  final String username;

  /// The password for the registration request.
  final String password;

  /// Constructs a RegistrationRequest object with the given parameters.
  const RegistrationRequest({
    required this.firstname,
    required this.lastname,
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [username, password];

  /// Converts the RegistrationRequest object to a JSON map.
  Map<String, dynamic> toMap() {
    return {
      'firstname': firstname,
      'lastname': lastname,
      'username': username,
      'password': password,
    };
  }

  @override
  bool get stringify => true;
}
