import 'package:shared_preferences/shared_preferences.dart';

class RefreshTokenUtils {
  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken');
  }

  static Future<bool> removeRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove('refreshToken');
  }

  static Future<bool> setRefreshToken(String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('refreshToken', refreshToken);
  }
}
