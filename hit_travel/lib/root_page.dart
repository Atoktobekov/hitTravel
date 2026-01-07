import 'package:flutter/material.dart';
import 'package:hit_travel/core/di/locator.dart';
import 'package:hit_travel/core/network/auth_cache_manager.dart';
import 'package:hit_travel/features/profile/presentation/pages/authorized_profile_page.dart';
import 'package:hit_travel/features/home/presentation/pages/home_page.dart';
import 'package:hit_travel/features/favorites/presentation/pages/favorites_page.dart';
import 'package:hit_travel/features/my_bookings/presentation/pages/my_bookings_page.dart';
import 'package:hit_travel/features/profile/presentation/pages/profile_page.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _currentIndex = 0;
  final AuthCacheManager _authManager = serviceLocator<AuthCacheManager>();

  @override
  void initState() {
    super.initState();
    _authManager.addListener(_handleAuthChange);
  }

  @override
  void dispose() {
    _authManager.removeListener(_handleAuthChange);
    super.dispose();
  }

  void _handleAuthChange() {
    if (mounted) setState(() {}); // redraw on auth change
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomePage(),
      const FavoritesPage(),
      const MyBookingsPage(),
      _authManager.isAuthorized
          ? const AuthorizedProfilePage()
          : const ProfilePage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Поиск'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Избранные'),
          BottomNavigationBarItem(icon: Icon(Icons.book_online_outlined), label: 'Мои заказы'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
        ],
      ),
    );
  }
}