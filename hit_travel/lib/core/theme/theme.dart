import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  static final blueColor = const Color(0xFF026ed1);

  static final light = ThemeData(
    fontFamily: 'Gilroy', // Меняем Roboto на Gilroy
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: blueColor).copyWith(
      primary: blueColor,
      onPrimary: Colors.white,
      secondary: Colors.blueAccent,
      onSecondary: Colors.white,
    ),
    // Настраиваем глобальную тему текста, чтобы везде был Gilroy
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontFamily: 'Gilroy'),
      bodyMedium: TextStyle(fontFamily: 'Gilroy'),
      titleLarge: TextStyle(fontFamily: 'Gilroy', fontWeight: FontWeight.bold),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFF026ed1),
      unselectedItemColor: Colors.black87,
    ),
    iconTheme: const IconThemeData(color: Color(0xFF026ed1)),
    primaryIconTheme: const IconThemeData(color: Color(0xFF026ed1)),
  );

  static final labelText = TextStyle(
    fontFamily: 'Gilroy',
    fontSize: 15.sp,
    color: Colors.grey,
    fontWeight: FontWeight.w500,
  );

  static final textFieldText = TextStyle(
    fontFamily: 'Gilroy',
    color: Colors.black54,
    fontSize: 16.sp,
  );

  static final elevatedButtonInAuth = ElevatedButton.styleFrom(
    backgroundColor: AppTheme.blueColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6.r),
    ),
    elevation: 0,
    textStyle: TextStyle(
      fontFamily: 'Gilroy',
      fontWeight: FontWeight.w600,
      fontSize: 16.sp,
    ),
  );
}