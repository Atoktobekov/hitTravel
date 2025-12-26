import 'package:flutter/material.dart';
import 'package:hit_travel/core/di/locator.dart';
import 'package:hit_travel/core/network/auth_cache_manager.dart';
import 'package:hit_travel/core/network/dio_client.dart';
import 'package:hit_travel/core/theme/theme.dart';

class AuthorizedProfilePage extends StatefulWidget {
  const AuthorizedProfilePage({super.key});

  @override
  State<AuthorizedProfilePage> createState() => _AuthorizedProfilePageState();
}

class _AuthorizedProfilePageState extends State<AuthorizedProfilePage> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final response = await _apiService.getPersonalData();
      if (mounted) {
        setState(() {
          // Согласно логам, данные лежат в поле 'data'
          userData = response.data['data'];
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не удалось загрузить данные профиля')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Маппинг данных из ответа API
    final String firstName = userData?['first_name'] ?? 'Имя';
    final String lastName = userData?['last_name'] ?? '';
    final String email = userData?['email'] ?? 'E-mail не указан';
    final String bonuses = userData?['bonuses']?.toString() ?? '0';
    final String? photoUrl = userData?['photo'];

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _loadProfile, // Позволяет обновить данные свайпом вниз
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Blue Header Section
              Container(
                width: double.infinity,
                decoration: BoxDecoration(color: AppTheme.blueColor),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // Avatar с загрузкой из сети
                            Container(
                              width: 70,
                              height: 70,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: photoUrl != null && photoUrl.isNotEmpty
                                  ? Image.network(
                                photoUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.person, size: 40, color: AppTheme.blueColor),
                              )
                                  : Icon(Icons.person, size: 40, color: AppTheme.blueColor),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$firstName $lastName'.trim(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    email,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Кнопка редактирования (пока просто иконка)
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.edit, color: Colors.white, size: 20),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Bonuses Card
                        _buildBonusesCard(bonuses),
                      ],
                    ),
                  ),
                ),
              ),
              // Menu Items
              _buildMenu(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBonusesCard(String bonuses) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Доступные бонусы', style: TextStyle(fontSize: 16, color: Colors.black87)),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '$bonuses ',
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        const TextSpan(
                          text: 'С',
                          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black, decoration: TextDecoration.underline),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Image.asset('assets/gift.png', width: 80, height: 80,
                  errorBuilder: (_, __, ___) => const Text('🎁', style: TextStyle(fontSize: 50))),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const Text(
            'Получайте кешбек за покупку туров и используйте бонусы для следующих поездок!',
            style: TextStyle(fontSize: 13, color: Colors.black54, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildMenu() {
    return Column(
      children: [
        _buildMenuItem(icon: Icons.shopping_bag_outlined, title: 'Мои заказы', onTap: () {}),
        _buildDivider(),
        _buildMenuItem(icon: Icons.notifications_outlined, title: 'Уведомления', onTap: () {}),
        _buildDivider(),
        _buildMenuItem(icon: Icons.contacts_outlined, title: 'Контакты', onTap: () {}),
        _buildDivider(),
        _buildMenuItem(icon: Icons.lock_outline, title: 'Изменить пароль', onTap: () {}),
        _buildDivider(),
        _buildMenuItem(icon: Icons.help_outline, title: 'Часто задаваемые вопросы', onTap: () {}),
        _buildDivider(),
        _buildMenuItem(
            icon: Icons.language,
            title: 'Язык',
            trailing: const Text('Русский', style: TextStyle(fontSize: 16, color: Colors.black54)),
            onTap: () {}
        ),
        _buildDivider(),
        _buildMenuItem(
            icon: Icons.logout,
            title: 'Выйти из аккаунта',
            titleColor: Colors.red,
            onTap: () async => await serviceLocator<AuthCacheManager>().logout()
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    Color? titleColor,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Row(
          children: [
            Icon(icon, size: 24, color: titleColor ?? Colors.black87),
            const SizedBox(width: 16),
            Expanded(
              child: Text(title, style: TextStyle(fontSize: 16, color: titleColor ?? Colors.black87)),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() => const Divider(height: 1, thickness: 1, indent: 24, endIndent: 24);
}