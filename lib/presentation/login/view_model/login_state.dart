import 'package:flutter/material.dart';

class LoginState {
  final GlobalKey<FormState> formKey;
  final String username;
  final String password;
  final bool isLogging;

  const LoginState({
    required this.username,
    required this.password,
    required this.formKey,
    required this.isLogging,
  });

  factory LoginState.initial() {
    return LoginState(
      username: '',
      password: '',
      formKey: GlobalKey<FormState>(),
      isLogging: false,
    );
  }

  LoginState copyWith({
    String? username,
    String? password,
    GlobalKey<FormState>? formKey,
    bool? isLogging,
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      formKey: formKey ?? this.formKey,
      isLogging: isLogging ?? this.isLogging,
    );
  }
}
