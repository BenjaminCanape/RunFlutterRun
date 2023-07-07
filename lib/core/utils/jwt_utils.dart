import 'package:shared_preferences/shared_preferences.dart';

/// Utility class for handling JSON Web Token (JWT) using the shared_preferences library.
class JwtUtils {
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
}
