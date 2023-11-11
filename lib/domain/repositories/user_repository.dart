import 'dart:typed_data';

import '../../data/model/request/edit_password_request.dart';
import '../../data/model/request/edit_profile_request.dart';
import '../../data/model/request/login_request.dart';
import '../../data/model/request/registration_request.dart';
import '../../data/model/request/send_new_password_request.dart';
import '../../data/model/response/login_response.dart';
import '../entities/user.dart';

/// Abstract class representing the user repository.
abstract class UserRepository {
  /// Registers a new user.
  Future<int> register(RegistrationRequest request);

  /// Performs user login.
  Future<LoginResponse> login(LoginRequest request);

  /// Logs out the user.
  Future<void> logout();

  /// Deletes the user account.
  Future<void> delete();

  /// Send new password by mail
  Future<void> sendNewPasswordByMail(SendNewPasswordRequest request);

  /// Edit the password
  Future<void> editPassword(EditPasswordRequest request);

  /// Edit the profile
  Future<void> editProfile(EditProfileRequest request);

  /// Search users based on a text value
  Future<List<User>> search(String text);

  /// Download the profile picture of a user
  Future<Uint8List?> downloadProfilePicture(String id);

  /// Upload the profile picture of the current user
  Future<void> uploadProfilePicture(Uint8List file);
}
