import 'package:dio/dio.dart';
import 'package:hit_travel/core/di/locator.dart';
import 'package:hit_travel/core/network/auth_cache_manager.dart';

class ApiService {
  final Dio _dio = serviceLocator<Dio>();

  Future<Response> post(String path, Map<String, dynamic> data) async {
    return await _dio.post(path, data: data);
  }

  Future<Response> register(Map<String, dynamic> data) async {
    return await _dio.post('/auth/register', data: data);
  }

  Future<Response> verifyPhone(Map<String, dynamic> data) async {
    return await _dio.post('/auth/verify-phone', data: data);
  }

  Future<Response> resendCode(Map<String, dynamic> data) async {
    return await _dio.post('/auth/re-send', data: data);
  }

  Future<Response> getPersonalData() async {
    final token = serviceLocator<AuthCacheManager>().getToken();

    return await _dio.get(
      '/profile/personal',
      options: Options(headers: {
        'Authorization': 'Token $token',
      }),
    );
  }

  Future<Response> getMyTours() async {
    final token = serviceLocator<AuthCacheManager>().getToken();
    return await _dio.get(
      '/profile/my-tour',
      options: Options(headers: {'Authorization': 'Token $token'}),
    );
  }
}