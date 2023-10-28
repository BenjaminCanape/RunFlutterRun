import 'dart:convert';

import '../../data/model/response/user_response.dart';
import '../../domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Utility class for handling the storage using the shared_preferences library.
class StorageUtils {
  /// Retrieves the refresh token stored in shared preferences.
  ///
  /// Returns [null] if no refresh token is stored.
  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken');
  }

  /// Removes the stored refresh token from shared preferences.
  ///
  /// Returns [true] if the refresh token was successfully removed, otherwise [false].
  static Future<bool> removeRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove('refreshToken');
  }

  /// Stores the refresh token in shared preferences.
  ///
  /// Returns [true] if the refresh token was successfully stored, otherwise [false].
  static Future<bool> setRefreshToken(String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('refreshToken', refreshToken);
  }

  /// Retrieves the JWT stored in shared preferences.
  ///
  /// Returns [null] if no JWT is stored.
  static Future<String?> getJwt() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt');
  }

  /// Removes the stored JWT from shared preferences.
  ///
  /// Returns [true] if the JWT was successfully removed, otherwise [false].
  static Future<bool> removeJwt() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove('jwt');
  }

  /// Stores the JWT in shared preferences.
  ///
  /// Returns [true] if the JWT was successfully stored, otherwise [false].
  static Future<bool> setJwt(String jwt) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('jwt', jwt);
  }

  /// Retrieves the user stored in shared preferences.
  ///
  /// Returns [null] if no data is stored.
  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? userString = prefs.getString('user');
    if (userString != null) {
      dynamic json = jsonDecode(userString!);
      UserResponse response = UserResponse.fromMap(json);
      User user = response.toEntity();
      return Future.value(user);
    }
    return Future.value(null);
  }

  /// Removes the stored user from shared preferences.
  ///
  /// Returns [true] if the user was successfully removed, otherwise [false].
  static Future<bool> removeUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove('user');
  }

  /// Stores the user in shared preferences.
  ///
  /// Returns [true] if the user was successfully stored, otherwise [false].
  static Future<bool> setUser(UserResponse user) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('user', jsonEncode(user.toJson()));
  }

  /// Removes the cached data of an url api from shared preferences.
  ///
  /// Returns [true] if the data were successfully removed, otherwise [false].
  static Future<bool> removeCachedDataFromUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(url);
  }
}
