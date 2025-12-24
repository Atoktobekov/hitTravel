
import 'package:flutter/material.dart';
import 'package:hit_travel/root_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:hit_travel/core/theme/theme.dart';

class HitTravelApp extends StatelessWidget {
  const HitTravelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 780),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          home: child,

        );
      },
      child: const RootPage(),
    );
  }
}