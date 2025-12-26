import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

final serviceLocator = GetIt.instance; // sl - Service Locator

Future<void> setupLocator() async {
  // 1. Инициализируем Talker
  final talker = TalkerFlutter.init();

  if (!serviceLocator.isRegistered<Talker>()) {
    serviceLocator.registerSingleton<Talker>(talker);
  }

  // 2. Настраиваем Dio
  final dio = Dio(
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

  // 3. Добавляем TalkerDioLogger в перехватчики Dio
  dio.interceptors.add(
    TalkerDioLogger(
      talker: talker,
      settings: const TalkerDioLoggerSettings(
        printRequestHeaders: true,
        printResponseHeaders: false,
        printResponseMessage: true,
      ),
    ),
  );

  if (!serviceLocator.isRegistered<Dio>()) {
    serviceLocator.registerSingleton<Dio>(dio);
  }
}