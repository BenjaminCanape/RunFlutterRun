import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../data/model/response/user_response.dart';
import '../../../core/utils/storage_utils.dart';
import '../../../data/model/request/edit_profile_request.dart';

import '../../../data/repositories/user_repository_impl.dart';
import '../../../domain/entities/user.dart';
import '../../../main.dart';
import 'state/edit_profile_state.dart';

final editProfileViewModelProvider =
    StateNotifierProvider<EditProfileViewModel, EditProfileState>(
        (ref) => EditProfileViewModel(ref));

class EditProfileViewModel extends StateNotifier<EditProfileState> {
  Ref ref;

  /// Creates a new instance of [EditProfileViewModel].
  EditProfileViewModel(this.ref) : super(EditProfileState.initial());

  /// Sets the firstname in the state.
  void setFirstname(String? firstname) {
    state = state.copyWith(firstname: firstname);
  }

  /// Sets the lastname in the state.
  void setLastname(String? lastname) {
    state = state.copyWith(lastname: lastname);
  }

  Future<void> getCurrentUser() async {
    User? user = await StorageUtils.getUser();
    if (user != null) {
      state =
          state.copyWith(firstname: user.firstname, lastname: user.lastname);
    }
  }

  Future<void> chooseNewProfilePicture(Uint8List image) async {
    ref
        .read(userRepositoryProvider)
        .uploadProfilePicture(image)
        .then((_) => state = state.copyWith(profilePicture: image));
  }

  Future<void> getProfilePicture() async {
    User? currentUser = await StorageUtils.getUser();
    if (currentUser != null) {
      ref
          .read(userRepositoryProvider)
          .downloadProfilePicture(currentUser.id)
          .then((value) => {state = state.copyWith(profilePicture: value)});
    }
  }

  /// Submits the edit profile form.
  Future<void> submitForm(
      BuildContext context, GlobalKey<FormState> formKey) async {
    state = state.copyWith(errorOnRequest: false);
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      state.copyWith(isEditing: true);

      final userRepository = ref.read(userRepositoryProvider);
      final editProfileRequest = EditProfileRequest(
        firstname: state.firstname,
        lastname: state.lastname,
      );

      try {
        await userRepository.editProfile(editProfileRequest);
        User? currentUser = await StorageUtils.getUser();

        UserResponse user = UserResponse(
            id: currentUser?.id ?? '',
            username: currentUser?.username ?? '',
            firstname: state.firstname,
            lastname: state.lastname);

        await StorageUtils.setUser(user);

        navigatorKey.currentState?.pop();
      } catch (e) {
        state = state.copyWith(errorOnRequest: true);
      } finally {
        state = state.copyWith(isEditing: false);
      }
    }
  }
}
