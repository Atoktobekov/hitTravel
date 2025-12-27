import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hit_travel/core/di/locator.dart';

class AuthCacheManager extends ChangeNotifier {
  final SharedPreferences _prefs = serviceLocator<SharedPreferences>();

  static const _tokenKey = 'auth_token';

  // auth check
  bool get isAuthorized => _prefs.getString(_tokenKey) != null;

  String? getToken() => _prefs.getString(_tokenKey);

  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
    notifyListeners(); // notify RootPage
  }

  Future<void> logout() async {
    await _prefs.remove(_tokenKey);
    notifyListeners(); // notify RootPage
  }
}