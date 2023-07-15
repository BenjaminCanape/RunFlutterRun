import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/model/request/send_new_password_request.dart';
import '../../../data/repositories/user_repository_impl.dart';
import '../../../main.dart';
import 'send_new_password_state.dart';

/// Provides the view model for the send new password screen.
final sendNewPasswordViewModelProvider = StateNotifierProvider.autoDispose<
    SendNewPasswordViewModel, SendNewPasswordState>(
  (ref) => SendNewPasswordViewModel(ref),
);

/// The view model class for the send new password screen.
class SendNewPasswordViewModel extends StateNotifier<SendNewPasswordState> {
  final Ref ref;

  SendNewPasswordViewModel(this.ref) : super(SendNewPasswordState.initial());

  /// Sets the email in the state.
  void setEmail(String? email) {
    state = state.copyWith(email: email ?? '');
  }

  /// Submits the send mail form.
  Future<void> submitForm(
      BuildContext context, GlobalKey<FormState> formKey) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      state = state.copyWith(isSending: true);

      final userRepository = ref.read(userRepositoryProvider);
      final sendNewPasswordRequest = SendNewPasswordRequest(email: state.email);

      try {
        await userRepository.sendNewPasswordByMail(sendNewPasswordRequest);

        state = state.copyWith(isSending: false);

        navigatorKey.currentState?.pop();
      } catch (error) {
        // Handle send mail error
        state = state.copyWith(isSending: false);
        navigatorKey.currentState?.pop();
      }
    }
  }
}
