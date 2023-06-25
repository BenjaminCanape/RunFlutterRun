import 'package:equatable/equatable.dart';

class LoginRequest extends Equatable {
  final String username;
  final String password;

  const LoginRequest({
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [username, password];

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
    };
  }
}
