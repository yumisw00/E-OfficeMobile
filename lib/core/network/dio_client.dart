import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio _dio;

  factory DioClient() => _instance;

  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.e-office.example.com', // Dummy Base URL
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        responseType: ResponseType.json,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Log request in debug mode
          if (kDebugMode) {
            print('REQUEST[${options.method}] => PATH: ${options.path}');
          }

          // Placeholder for Bearer Token
          // String? token = await storage.read(key: 'auth_token');
          // if (token != null) {
          //   options.headers['Authorization'] = 'Bearer $token';
          // }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          if (kDebugMode) {
            print('ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
          }
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
