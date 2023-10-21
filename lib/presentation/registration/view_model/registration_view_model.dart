import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/model/request/registration_request.dart';
import '../../../data/repositories/user_repository_impl.dart';
import '../../../main.dart';
import 'state/registration_state.dart';

final registrationViewModelProvider =
    StateNotifierProvider.autoDispose<RegistrationViewModel, RegistrationState>(
  (ref) => RegistrationViewModel(ref),
);

class RegistrationViewModel extends StateNotifier<RegistrationState> {
  Ref ref;

  /// Creates a new instance of [RegistrationViewModel].
  RegistrationViewModel(this.ref) : super(RegistrationState.initial());

  /// Sets the firstname in the state.
  void setFirstname(String? firstname) {
    state = state.copyWith(firstname: firstname);
  }

  /// Sets the lastname in the state.
  void setLastname(String? lastname) {
    state = state.copyWith(lastname: lastname);
  }

  /// Sets the username in the state.
  void setUsername(String? username) {
    state = state.copyWith(username: username);
  }

  /// Sets the password in the state.
  void setPassword(String? password) {
    state = state.copyWith(password: password);
  }

  /// Sets the check password in the state.
  void setCheckPassword(String? checkPassword) {
    state = state.copyWith(checkPassword: checkPassword);
  }

  /// Submits the registration form.
  Future<void> submitForm(
      BuildContext context, GlobalKey<FormState> formKey) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      state = state.copyWith(isLogging: true);

      final userRepository = ref.read(userRepositoryProvider);
      final registrationRequest = RegistrationRequest(
        firstname: state.firstname,
        lastname: state.lastname,
        username: state.username,
        password: state.password,
      );

      try {
        await userRepository.register(registrationRequest);
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
