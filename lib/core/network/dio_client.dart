import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_client.g.dart';

const _storage = FlutterSecureStorage();

@riverpod
Dio dio(DioRef ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.e-office.dummy/api',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'jwt_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (e, handler) {
        if (e.response?.statusCode == 401) {
          // TODO: Trigger logout karena token kedaluwarsa/tidak valid
        }
        return handler.next(e);
      },
    ),
  );

  return dio;
}
