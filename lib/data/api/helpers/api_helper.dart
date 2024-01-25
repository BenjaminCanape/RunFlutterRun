import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/error.dart';
import '../../../core/utils/storage_utils.dart';
import '../../../main.dart';
import '../user_api.dart';

/// Helper class for making API requests.
class ApiHelper {
  // switch url when back is down
  static const String apiUrl =
      'http://lxgfjcmoky.us18.qoddiapp.com/api/'; //US server
  //static const String apiUrl =
  //   'http://tiqorhzmyb.eu11.qoddiapp.com/api/'; //EU server

  /// Makes an HTTP request to the specified [url] using the given [method].
  ///
  /// Optional [data] and [queryParams] can be provided for POST, PUT, and DELETE requests.
  /// Returns the [Response] object or null if an unauthorized error occurs and user navigation is handled.
  static Future<Response?> makeRequest(String url, String method,
      {Map<String, dynamic>? data,
      Map<String, dynamic>? queryParams,
      ResponseType? responseType,
      bool noCache = false}) async {
    final remoteApi = RemoteApi(url);
    await remoteApi.setJwt();

    try {
      Response? response;
      switch (method) {
        case 'GET':
          response = await remoteApi.dio.get(
            url,
            queryParameters: queryParams,
            options: Options(
                extra: {'noCache': noCache},
                responseType: responseType ?? ResponseType.json),
          );
          break;
        case 'POST':
          response = await remoteApi.dio.post(
            url,
            data: data,
            queryParameters: queryParams,
          );
          break;
        case 'POST_FORM_DATA':
          final formData = FormData.fromMap(data!);
          response = await remoteApi.dio.post(
            url,
            data: formData,
            queryParameters: queryParams,
          );
          break;
        case 'PUT':
          response = await remoteApi.dio.put(
            url,
            data: data,
            queryParameters: queryParams,
          );
          break;
        case 'DELETE':
          response = await remoteApi.dio.delete(
            url,
            queryParameters: queryParams,
          );
          break;
      }
      return response;
    } on DioError catch (error) {
      if (error.response?.statusCode == 401) {
        return remoteApi.handleUnauthorizedError(error, data, queryParams);
      }
      throw Failure(message: error.toString());
    }
  }

  /// Remove the cache for a specific key, a specific url
  static Future<void> removeCacheForUrl(String url) async {
    final remoteApi = RemoteApi(url);
    await remoteApi.initCache();
    await remoteApi.removeCacheForKey(url);
  }
}

/// Wrapper class for the Dio library with additional functionality.
class RemoteApi {
  late String url;
  late Dio dio;
  late SharedPreferences prefs;

  /// Constructs a RemoteApi object with the given [url].
  RemoteApi(this.url) {
    dio = Dio();
    initCache();
  }

  /// Initializes the shared preferences cache.
  Future<void> initCache() async {
    prefs = await SharedPreferences.getInstance();

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final cacheKey = options.uri.toString();
        final cachedResponse = prefs.getString(cacheKey);
        bool noCache = options.extra['noCache'] ?? false;

        if (noCache == false &&
            options.method == 'GET' &&
            cachedResponse != null) {
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

        if (options.method == 'POST_FORM_DATA' ||
            options.method == 'POST' ||
            options.method == 'PUT' ||
            options.method == 'DELETE') {
          Set<String> keys = prefs.getKeys();

          keys.where((key) => key.startsWith('${url}all')).forEach((key) {
            prefs.remove(key);
          });
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

  Future<bool> removeCacheForKey(String key) {
    return prefs.remove(key);
  }

  /// Sets the JWT in the request headers.
  Future<void> setJwt() async {
    final jwt = await StorageUtils.getJwt();
    if (jwt != null) {
      dio.options.headers['Authorization'] = 'Bearer $jwt';
    }
  }

  /// Handles an unauthorized error by refreshing the JWT and making the request again.
  ///
  /// Returns the [Response] object or null if navigation to the login screen occurs.
  Future<Response?> handleUnauthorizedError(DioError error,
      Map<String, dynamic>? data, Map<String, dynamic>? queryParams) async {
    try {
      String? jwt = await UserApi.refreshToken();
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
}
