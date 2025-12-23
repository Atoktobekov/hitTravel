
import 'package:flutter/material.dart';
import 'package:hit_travel/root_page.dart';

class HitTravelApp extends StatelessWidget {
  const HitTravelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hit Travel Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const RootPage(),
    );
  }
}