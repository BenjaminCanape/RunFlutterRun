import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/utils/storage_utils.dart';
import '../../../data/model/request/edit_profile_request.dart';
import '../../../data/model/response/user_response.dart';
import '../../../data/repositories/user_repository_impl.dart';
import '../../../domain/entities/user.dart';
import '../../../main.dart';
import '../../common/user/view_model/profile_picture_view_model.dart';
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

  Future<User?> getCurrentUser() async {
    User? user = await StorageUtils.getUser();
    if (user != null) {
      state =
          state.copyWith(firstname: user.firstname, lastname: user.lastname);
    }
    return user;
  }

  Future<void> chooseNewProfilePicture(Uint8List image) async {
    state = state.copyWith(isUploading: true);
    ref
        .read(userRepositoryProvider)
        .uploadProfilePicture(image)
        .then((_) async {
      User? currentUser = await StorageUtils.getUser();
      if (currentUser != null) {
        ref
            .watch(profilePictureViewModelProvider(currentUser.id).notifier)
            .editProfilePicture(image);
      }
      state = state.copyWith(isUploading: false);
    });
  }

  Future<void> getProfilePicture(FutureProviderRef<void> ref) async {
    User? currentUser = await StorageUtils.getUser();
    if (currentUser != null) {
      ref
          .read(profilePictureViewModelProvider(currentUser.id).notifier)
          .getProfilePicture(currentUser.id);
    }
  }

  /// Submits the edit profile form.
  Future<void> submitForm(
      BuildContext context, GlobalKey<FormState> formKey) async {
    state = state.copyWith(errorOnRequest: false);
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      state = state.copyWith(isEditing: true);

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
