import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/models/request/LoginRequest.dart';
import '../../../data/repository/user_repository_impl.dart';
import '../../../main.dart';
import 'registration_state.dart';

final registrationViewModelProvider =
    StateNotifierProvider.autoDispose<RegistrationViewModel, RegistrationState>(
        (ref) => RegistrationViewModel(ref));

class RegistrationViewModel extends StateNotifier<RegistrationState> {
  Ref ref;

  RegistrationViewModel(this.ref) : super(RegistrationState.initial());

  void setUsername(String? username) {
    state = state.copyWith(username: username);
  }

  void setPassword(String? password) {
    state = state.copyWith(password: password);
  }

  void setCheckPassword(String? password) {
    state = state.copyWith(checkPassword: password);
  }

  Future<void> submitForm(BuildContext context) async {
    if (state.formKey.currentState!.validate()) {
      state.formKey.currentState!.save();

      state = state.copyWith(isLogging: true);

      final userRepository = ref.read(userRepositoryProvider);
      final loginRequest = LoginRequest(
        username: state.username,
        password: state.password,
      );

      try {
        await userRepository.register(loginRequest);
        state = state.copyWith(isLogging: false);
        navigatorKey.currentState?.pop();
      } catch (error) {
        // Handle login error
        state = state.copyWith(isLogging: false);
        // Show error message to the user
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('An error occurred during registration'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }
}
