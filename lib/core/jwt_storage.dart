import 'package:shared_preferences/shared_preferences.dart';

class JwtUtils {
  static Future<String?> getJwt() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt');
  }

  static Future<bool> removeJwt() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove('jwt');
  }

  static Future<bool> setJwt(String jwt) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString('jwt', jwt);
  }
}
