import 'package:equatable/equatable.dart';

/// Represents a edit profile request object.
class EditProfileRequest extends Equatable {
  /// The firstname for the request.
  final String firstname;

  /// The lastname for the request.
  final String lastname;

  /// Constructs a EditProfileRequest object with the given parameters.
  const EditProfileRequest({
    required this.firstname,
    required this.lastname,
  });

  @override
  List<Object?> get props => [firstname, lastname];

  /// Converts the EditProfileRequest object to a JSON map.
  Map<String, dynamic> toMap() {
    return {
      'firstname': firstname,
      'lastname': lastname,
    };
  }

  @override
  bool get stringify => true;
}
