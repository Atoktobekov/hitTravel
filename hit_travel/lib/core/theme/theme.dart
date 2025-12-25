import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  static final blueColor = Color(0xFF026ed1);

  static final labelText = TextStyle(fontSize: 15, color: Colors.grey);

  static final textFieldText = TextStyle(color: Colors.black54);

  static final elevatedButtonInAuth = ElevatedButton.styleFrom(
    backgroundColor: AppTheme.blueColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6.r),
    ),
    elevation: 0,
  );
}