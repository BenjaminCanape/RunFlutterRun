import 'dart:typed_data';

/// The state class for profile picture.
class ProfilePictureState {
  final bool loaded;
  final Uint8List? profilePicture; // the profile picture

  const ProfilePictureState(
      {required this.loaded, required this.profilePicture});

  /// Factory method to create the initial state.
  factory ProfilePictureState.initial() {
    return const ProfilePictureState(loaded: false, profilePicture: null);
  }

  /// Method to create a copy of the state with updated values.
  ProfilePictureState copyWith({bool? loaded, Uint8List? profilePicture}) {
    return ProfilePictureState(
        loaded: loaded ?? this.loaded,
        profilePicture: profilePicture ?? this.profilePicture);
  }
}
