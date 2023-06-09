import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemoteApi {
  late String url;
  var dio = Dio();
  late SharedPreferences prefs;

  RemoteApi(this.url) {
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

  void initCache() async {
    prefs = await SharedPreferences.getInstance();

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        String cacheKey = options.uri.toString();

        String? cachedResponse = prefs.getString(cacheKey);

        if (options.method == 'GET' && cachedResponse != null) {
          int cacheTimestamp = prefs.getInt('$cacheKey:timestamp') ?? 0;

          int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
          int expirationDuration = 24 * 60 * 60 * 1000;

          if (currentTimestamp - cacheTimestamp <= expirationDuration) {
            handler.resolve(Response(
                data: jsonDecode(cachedResponse),
                statusCode: 200,
                requestOptions: options));
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
        String cacheKey = response.requestOptions.uri.toString();
        String jsonResponse = jsonEncode(response.data);
        await prefs.setString(cacheKey, jsonResponse);

        int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
        await prefs.setInt('$cacheKey:timestamp', currentTimestamp);

        handler.next(response);
      },
    ));
  }
}
