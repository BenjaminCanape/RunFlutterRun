import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/model/request/login_request.dart';
import '../../../data/repositories/user_repository_impl.dart';
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

  void setCheckPassword(String? checkPassword) {
    state = state.copyWith(checkPassword: checkPassword);
  }

  Future<void> submitForm(
      BuildContext context, GlobalKey<FormState> formKey) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      state = state.copyWith(isLogging: true);

      final userRepository = ref.read(userRepositoryProvider);
      final loginRequest = LoginRequest(
        username: state.username,
        password: state.password,
      );

      try {
        await userRepository.register(loginRequest);
        navigatorKey.currentState?.pop();
      } catch (error) {
        // Show error message to the user
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text(error.toString()),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      } finally {
        state = state.copyWith(isLogging: false);
      }
    }
  }
}
