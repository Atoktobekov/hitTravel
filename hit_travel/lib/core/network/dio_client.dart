import 'package:dio/dio.dart';
import 'package:hit_travel/core/di/locator.dart';

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
}