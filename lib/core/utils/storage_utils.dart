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

  /// Removes the cached data of an url api from shared preferences.
  ///
  /// Returns [true] if the JWT was successfully removed, otherwise [false].
  static Future<bool> removeCachedDataFromUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(url);
  }
}
