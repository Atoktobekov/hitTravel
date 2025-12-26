import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hit_travel/core/network/auth_cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

final serviceLocator = GetIt.instance;

Future<void> setupLocator() async {
  final talker = TalkerFlutter.init();

  if (!serviceLocator.isRegistered<Talker>()) {
    serviceLocator.registerSingleton<Talker>(talker);
  }

  final sharedPreferences = await SharedPreferences.getInstance();
  if (!serviceLocator.isRegistered<SharedPreferences>()) {
    serviceLocator.registerSingleton<SharedPreferences>(sharedPreferences);
  }

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

  if (!serviceLocator.isRegistered<AuthCacheManager>()) {
    serviceLocator.registerSingleton<AuthCacheManager>(AuthCacheManager());
  }
}
