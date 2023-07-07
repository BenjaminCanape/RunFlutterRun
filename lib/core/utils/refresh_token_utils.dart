import 'package:shared_preferences/shared_preferences.dart';

/// Utility class for handling the refresh token using the shared_preferences library.
class RefreshTokenUtils {
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
}
