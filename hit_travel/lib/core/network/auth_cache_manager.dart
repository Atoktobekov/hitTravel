import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hit_travel/core/di/locator.dart';

class AuthCacheManager extends ChangeNotifier {
  final SharedPreferences _prefs = serviceLocator<SharedPreferences>();

  // Ключи для хранения
  static const _tokenKey = 'auth_token';

  // Проверка: авторизован ли пользователь?
  bool get isAuthorized => _prefs.getString(_tokenKey) != null;

  String? getToken() => _prefs.getString(_tokenKey);

  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
    notifyListeners(); // Уведомляем RootPage об изменениях
  }

  Future<void> logout() async {
    await _prefs.remove(_tokenKey);
    notifyListeners(); // Уведомляем RootPage
  }
}