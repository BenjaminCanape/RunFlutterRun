import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:run_flutter_run/core/jwt_storage.dart';

import '../../../data/models/request/LoginRequest.dart';
import '../../../data/repository/user_repository_impl.dart';
import '../../../main.dart';
import '../../home/screen/home_screen.dart';
import 'login_state.dart';

final loginViewModelProvider =
    StateNotifierProvider.autoDispose<LoginViewModel, LoginState>(
  (ref) => LoginViewModel(ref),
);

class LoginViewModel extends StateNotifier<LoginState> {
  Ref ref;

  LoginViewModel(this.ref) : super(LoginState.initial());

  void setUsername(String? username) {
    state = state.copyWith(username: username);
  }

  void setPassword(String? password) {
    state = state.copyWith(password: password);
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
        final jwt = await userRepository.login(loginRequest);
        await JwtUtils.setJwt(jwt);

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
              content: const Text('An error occurred during login.'),
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
