import 'dart:typed_data';

/// Represents the state of the edit profile screen.
class EditProfileState {
  final String firstname;
  final String lastname;
  final Uint8List? profilePicture;
  final bool isEditing;
  final bool errorOnRequest;

  /// Creates a new instance of [EditProfileState].
  const EditProfileState(
      {required this.firstname,
      required this.lastname,
      required this.profilePicture,
      required this.isEditing,
      required this.errorOnRequest});

  /// Creates the initial state for the edit profile screen.
  factory EditProfileState.initial() {
    return const EditProfileState(
        firstname: '',
        lastname: '',
        profilePicture: null,
        isEditing: false,
        errorOnRequest: false);
  }

  /// Creates a copy of this state object with the specified changes.
  EditProfileState copyWith(
      {String? firstname,
      String? lastname,
      Uint8List? profilePicture,
      bool? isEditing,
      bool? errorOnRequest}) {
    return EditProfileState(
        firstname: firstname ?? this.firstname,
        lastname: lastname ?? this.lastname,
        profilePicture: profilePicture ?? this.profilePicture,
        isEditing: isEditing ?? this.isEditing,
        errorOnRequest: errorOnRequest ?? this.errorOnRequest);
  }
}
