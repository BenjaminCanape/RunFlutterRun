import 'package:flutter/material.dart';

class RegistrationState {
  final GlobalKey<FormState> formKey;
  final String username;
  final String password;
  final String checkPassword;
  final bool isLogging;

  const RegistrationState({
    required this.username,
    required this.password,
    required this.checkPassword,
    required this.formKey,
    required this.isLogging,
  });

  factory RegistrationState.initial() {
    return RegistrationState(
      username: '',
      password: '',
      checkPassword: '',
      formKey: GlobalKey<FormState>(),
      isLogging: false,
    );
  }

  RegistrationState copyWith({
    String? username,
    String? password,
    String? checkPassword,
    GlobalKey<FormState>? formKey,
    bool? isLogging,
  }) {
    return RegistrationState(
      username: username ?? this.username,
      password: password ?? this.password,
      checkPassword: checkPassword ?? this.checkPassword,
      formKey: formKey ?? this.formKey,
      isLogging: isLogging ?? this.isLogging,
    );
  }
}
