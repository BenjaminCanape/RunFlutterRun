import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:run_flutter_run/core/refresh_token_utils.dart';
import '../../core/error.dart';
import '../../core/jwt_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

const String apiUrl = 'https://runbackendrun.onrender.com/api/';

class RemoteApi {
  late String url;
  late Dio dio;
  late SharedPreferences prefs;

  RemoteApi(this.url) {
    dio = Dio();

    dio.options.connectTimeout = const Duration(seconds: 2);

    /*dio.interceptors.add(RetryInterceptor(
      dio: dio,
      retries: 5,
      retryDelays: const [
        Duration(seconds: 1),
        Duration(seconds: 2),
        Duration(seconds: 5),
        Duration(seconds: 5),
        Duration(seconds: 10),
      ],
    ));*/

    initCache();
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

  Future<Response?> handleUnauthorizedError(DioError error,
      Map<String, dynamic>? data, Map<String, dynamic>? queryParams) async {
    try {
      await JwtUtils.removeJwt();
      String jwt = await refreshToken();
      await JwtUtils.setJwt(jwt);
      try {
        var headers = error.requestOptions.headers;
        headers['Authorization'] = 'Bearer $jwt';
        return await dio.request(
          queryParameters: queryParams,
          data: data,
          error.requestOptions.path,
          options: Options(
            method: error.requestOptions.method,
            headers: headers,
            contentType: error.requestOptions.contentType,
            responseType: error.requestOptions.responseType,
          ),
        );
      } on DioError catch (_) {
        navigatorKey.currentState?.pushReplacementNamed('/login');
      }
    } on DioError {
      navigatorKey.currentState?.pushReplacementNamed('/login');
    }
    return null;
  }

  Future<String> refreshToken() async {
    try {
      String? refreshToken = await RefreshTokenUtils.getRefreshToken();
      final response = await dio
          .post('${apiUrl}user/refreshToken', data: {'token': refreshToken});

      if (response.statusCode == 200) {
        if (response.data.isNotEmpty) {
          return response.data['token'];
        }
      }
      throw const Failure(message: 'RefreshToken failed');
    } on DioError catch (err) {
      throw Failure(
          message: err.response?.statusMessage ?? 'Something went wrong!');
    } on SocketException {
      throw const Failure(message: 'Please check your connection.');
    }
  }
}
