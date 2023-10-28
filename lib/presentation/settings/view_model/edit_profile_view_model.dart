import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:run_flutter_run/data/model/response/user_response.dart';
import '../../../core/utils/storage_utils.dart';
import '../../../data/model/request/edit_profile_request.dart';

import '../../../data/repositories/user_repository_impl.dart';
import '../../../domain/entities/user.dart';
import '../../../main.dart';
import 'state/edit_profile_state.dart';

final editProfileViewModelProvider =
    StateNotifierProvider.autoDispose<EditProfileViewModel, EditProfileState>(
  (ref) => EditProfileViewModel(ref),
);

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
