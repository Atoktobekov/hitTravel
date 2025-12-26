import 'package:flutter/material.dart';
import 'package:hit_travel/core/di/locator.dart';
import 'package:hit_travel/core/theme/theme.dart';
import 'package:talker_flutter/talker_flutter.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Избранные',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.blueColor,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      TalkerScreen(talker: serviceLocator<Talker>()),
                ),
              );
            },
            icon: Icon(Icons.bug_report_outlined), color: Colors.white,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            'Привет! Раздел находится в разработке, скоро тут будут ваши избранные.',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
