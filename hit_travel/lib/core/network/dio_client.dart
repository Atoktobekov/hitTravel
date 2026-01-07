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

  Future<Response> requestPasswordReset(String email) async {
    return await _dio.post(
      '/auth/password-reset/request',
      data: {'email': email},
    );
  }

  Future<Response> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final token = serviceLocator<AuthCacheManager>().getToken();
    return await _dio.post(
      '/auth/new-password',
      data: {
        'old_password': oldPassword,
        'new_password': newPassword,
        'confirm_password': confirmPassword,
      },
      options: Options(headers: {
        'Authorization': 'Token $token',
      }),
    );
  }

  Future<Response> getFaq() async {
    return await _dio.get('/faq');
  }
}