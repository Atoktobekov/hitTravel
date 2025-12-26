import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://hit-travel.org',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Универсальный метод для POST запросов
  Future<Response> post(String path, Map<String, dynamic> data) async {
    return await _dio.post(path, data: data);
  }

  // Оставляем специализированный метод для регистрации, если ты его уже используешь
  Future<Response> register(Map<String, dynamic> data) async {
    return await _dio.post('/auth/register', data: data);
  }

  // Можно также добавить методы специально под верификацию для чистоты кода:
  Future<Response> verifyPhone(Map<String, dynamic> data) async {
    return await _dio.post('/auth/verify-phone', data: data);
  }

  Future<Response> resendCode(Map<String, dynamic> data) async {
    return await _dio.post('/auth/re-send', data: data);
  }
}