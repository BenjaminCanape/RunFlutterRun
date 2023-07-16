import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/model/request/edit_password_request.dart';
import '../../../data/repositories/user_repository_impl.dart';
import '../../../main.dart';
import 'edit_password_state.dart';

final editPasswordViewModelProvider =
    StateNotifierProvider.autoDispose<EditPasswordViewModel, EditPasswordState>(
  (ref) => EditPasswordViewModel(ref),
);

class EditPasswordViewModel extends StateNotifier<EditPasswordState> {
  Ref ref;

  /// Creates a new instance of [EditPasswordViewModel].
  EditPasswordViewModel(this.ref) : super(EditPasswordState.initial());

  /// Sets the currentPassword in the state.
  void setCurrentPassword(String? currentPassword) {
    state = state.copyWith(currentPassword: currentPassword);
  }

  /// Sets the password in the state.
  void setPassword(String? password) {
    state = state.copyWith(password: password);
  }

  /// Sets the check password in the state.
  void setCheckPassword(String? checkPassword) {
    state = state.copyWith(checkPassword: checkPassword);
  }

  /// Submits the edit password form.
  Future<void> submitForm(
      BuildContext context, GlobalKey<FormState> formKey) async {
    state = state.copyWith(errorOnRequest: false);
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      state = state.copyWith(isEditing: true);

      final userRepository = ref.read(userRepositoryProvider);
      final editPasswordRequest = EditPasswordRequest(
        currentPassword: state.currentPassword,
        password: state.password,
      );

      try {
        await userRepository.editPassword(editPasswordRequest);
        navigatorKey.currentState?.pop();
      } catch (e) {
        state = state.copyWith(errorOnRequest: true);
      } finally {
        state = state.copyWith(isEditing: false);
      }
    }
  }
}
