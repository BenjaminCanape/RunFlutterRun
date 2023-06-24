import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/widgets.dart';
import 'package:run_flutter_run/core/jwt_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemoteApi {
  late String url;
  late Dio dio;
  late SharedPreferences prefs;
  static late BuildContext? context;

  RemoteApi(this.url) {
    dio = Dio();

    dio.options.connectTimeout = const Duration(seconds: 2);

    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      retries: 5,
      retryDelays: const [
        Duration(seconds: 1),
        Duration(seconds: 2),
        Duration(seconds: 5),
        Duration(seconds: 5),
        Duration(seconds: 10),
      ],
    ));

    initCache();
  }

  static void initialize(BuildContext context) {
    context = context;
  }

  Future<void> initCache() async {
    prefs = await SharedPreferences.getInstance();

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final cacheKey = options.uri.toString();

        final cachedResponse = prefs.getString(cacheKey);

        if (options.method == 'GET' && cachedResponse != null) {
          final cacheTimestamp = prefs.getInt('$cacheKey:timestamp') ?? 0;

          final currentTimestamp = DateTime.now().millisecondsSinceEpoch;
          final expirationDuration = const Duration(days: 1).inMilliseconds;

          if (currentTimestamp - cacheTimestamp <= expirationDuration) {
            handler.resolve(Response(
              data: jsonDecode(cachedResponse),
              statusCode: 200,
              requestOptions: options,
            ));
            return;
          } else {
            prefs.remove(cacheKey);
            prefs.remove('$cacheKey:timestamp');
          }
        }

        if (options.method == 'POST' ||
            options.method == 'PUT' ||
            options.method == 'DELETE') {
          prefs.remove('${url}all');
          prefs.remove('${url}all:timestamp');
        }

        handler.next(options);
      },
      onResponse: (response, handler) async {
        final cacheKey = response.requestOptions.uri.toString();
        final jsonResponse = jsonEncode(response.data);
        await prefs.setString(cacheKey, jsonResponse);

        final currentTimestamp = DateTime.now().millisecondsSinceEpoch;
        await prefs.setInt('$cacheKey:timestamp', currentTimestamp);

        handler.next(response);
      },
      onError: (DioError error, ErrorInterceptorHandler handler) async {
        print(error);
        if (error.response?.statusCode == 401) {
          await handleUnauthorizedError();
        }
        handler.next(error);
      },
    ));
  }

  Future<void> setJwt() async {
    final jwt = await JwtUtils.getJwt();
    if (jwt != null) {
      dio.options.headers['Authorization'] = 'Bearer $jwt';
    }
  }

  Future<void> handleUnauthorizedError() async {
    await JwtUtils.removeJwt();
    if (context != null) {
      Navigator.pushReplacementNamed(context!, '/login');
    }
  }
}
