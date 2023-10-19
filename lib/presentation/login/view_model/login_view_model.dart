import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/model/request/login_request.dart';
import '../../../data/repositories/user_repository_impl.dart';
import '../../../main.dart';
import '../../home/screens/home_screen.dart';
import 'state/login_state.dart';

/// Provides the view model for the login screen.
final loginViewModelProvider =
    StateNotifierProvider.autoDispose<LoginViewModel, LoginState>(
  (ref) => LoginViewModel(ref),
);

/// The view model class for the login screen.
class LoginViewModel extends StateNotifier<LoginState> {
  final Ref ref;

  LoginViewModel(this.ref) : super(LoginState.initial());

  /// Sets the username in the state.
  void setUsername(String? username) {
    state = state.copyWith(username: username ?? '');
  }

  /// Sets the password in the state.
  void setPassword(String? password) {
    state = state.copyWith(password: password ?? '');
  }

  /// Submits the login form.
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
        await userRepository.login(loginRequest);

        state = state.copyWith(isLogging: false);

        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } catch (error) {
        // Handle login error
        state = state.copyWith(isLogging: false);
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
      }
    }
  }
}
