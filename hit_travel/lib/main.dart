import 'package:flutter/material.dart';
import 'package:hit_travel/app.dart';
import 'package:hit_travel/core/di/locator.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await setupLocator();

  runApp(const HitTravelApp());
}
