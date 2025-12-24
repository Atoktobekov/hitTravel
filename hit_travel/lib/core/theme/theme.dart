import 'package:flutter/material.dart';

class AppTheme{

  static final light = ThemeData(
    fontFamily: 'Roboto',
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue).copyWith(
      primary: Colors.blue,
      onPrimary: Colors.white,
      secondary: Colors.blueAccent,
      onSecondary: Colors.white,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.black87,
    ),
    iconTheme: IconThemeData(color: Colors.blue),
    primaryIconTheme: IconThemeData(color: Colors.blue),
  );
}