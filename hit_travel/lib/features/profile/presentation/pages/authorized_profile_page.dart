import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_travel/core/di/locator.dart';
import 'package:hit_travel/core/network/auth_cache_manager.dart';
import 'package:hit_travel/core/network/dio_client.dart';
import 'package:hit_travel/core/theme/theme.dart';
import 'package:hit_travel/features/profile/presentation/pages/contacts_page.dart';
import 'package:hit_travel/features/profile/presentation/widgets/profile_list_tile.dart';
import 'package:hit_travel/shared/presentation/widgets/blue_divider.dart';

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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final String firstName = userData?['first_name'] ?? 'Имя';
    final String lastName = userData?['last_name'] ?? '';
    final String email = userData?['email'] ?? 'E-mail не указан';
    final String bonuses = userData?['bonuses']?.toString() ?? '0';
    final String? photoUrl = userData?['photo'];

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _loadProfile,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                color: AppTheme.blueColor,
                padding: const EdgeInsets.fromLTRB(16, 48, 16, 18),
                child: Column(
                  children: [
                    _buildHeader(firstName, lastName, email, photoUrl),
                    const SizedBox(height: 20),
                    _buildBonusesCard(bonuses),
                  ],
                ),
              ),
              _buildMenu(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    String firstName,
    String lastName,
    String email,
    String? photoUrl,
  ) {
    return Row(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          clipBehavior: Clip.antiAlias,
          child: photoUrl != null && photoUrl.isNotEmpty
              ? Image.network(photoUrl, fit: BoxFit.cover)
              : Icon(Icons.person, size: 36, color: AppTheme.blueColor),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$firstName $lastName'.trim(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                email,
                style: TextStyle(
                  color: Colors.white.withAlpha(225),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(50),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.edit, size: 18, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildBonusesCard(String bonuses) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Доступные бонусы',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),

                    // bonuses text
                    Row(
                      children: [
                        Text(
                          "$bonuses ",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w100,
                            color: Colors.black87,
                          ),
                        ),
                        const Text(
                          'С',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w200,
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                            decorationThickness: 1.5,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    GestureDetector(
                      onTap: () {
                        // TODO: bonuses story
                      },
                      child: const Text(
                        'История бонусов',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF0A84FF),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Image.asset(
                  'assets/gift.png',
                  width: 64,
                  height: 64,
                  errorBuilder: (_, __, ___) =>
                      const Text('🎁', style: TextStyle(fontSize: 44)),
                ),
              ),
            ],
          ),
          blueDivider,

          const SizedBox(height: 12),

          Text(
            'Получайте кешбек за покупку туров и используйте бонусы для следующих поездок!',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenu() {
    return Column(
      children: [
        ProfileListTile(
          title: "Мои заказы",
          onTap: () {
            //TODO handle my bookings
          },
          isChevronNeeded: false,
        ),

        blueDivider,
        ProfileListTile(
          title: "Уведомления",
          onTap: () {
            //TODO handle notifications
          },
          isChevronNeeded: false,
        ),

        blueDivider,
        ProfileListTile(
          title: "Контакты",
          onTap: () {
            //TODO handle contact support
            Navigator.push(
              context,
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => const ContactsPage(),
              ),
            );
          },
          isChevronNeeded: false,
        ),

        blueDivider,
        ProfileListTile(
          title: "Изменить пароль",
          onTap: () {
            //TODO handle change password
          },
          isChevronNeeded: false,
        ),

        blueDivider,
        ProfileListTile(
          title: "Часто задаваемые вопросы",
          onTap: () {
            //TODO handle frequently asked questions
          },
          isChevronNeeded: false,
        ),

        blueDivider,
        ListTile(
          minTileHeight: 42.h,
          title: Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              "Язык",
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          trailing: Text(
            "Русский",
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade500,
            ),
          ),

          onTap: () {
            //TODO handle language change
          },
        ),

        blueDivider,
        ProfileListTile(
          title: "Выйти / Удалить аккаунт",
          onTap: () => _showLogoutDeleteDialog(context),
          isChevronNeeded: false,
        ),
        blueDivider,
        const SizedBox(height: 32),
      ],
    );
  }

  void _showLogoutDeleteDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // dialog header
                const Text(
                  "Управление аккаунтом",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 1),

                // logout option
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.blue),
                  title: const Text("Выйти из аккаунта"),
                  onTap: () async {
                    Navigator.pop(context); // Закрываем диалог
                    await serviceLocator<AuthCacheManager>().logout();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Выход успешно выполнен!"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                ),

                blueDivider,

                //delete account option
                ListTile(
                  leading: const Icon(Icons.delete_forever, color: Colors.red),
                  title: const Text(
                    "Удалить аккаунт",
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showDeleteConfirmation(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // show delete confirmation dialog
  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Удаление аккаунта"),
        content: const Text(
          "Вы уверены, что хотите удалить аккаунт? Это действие необратимо.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Отмена"),
          ),
          TextButton(
            onPressed: () {
              //TODO handle account deleting
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Запрос на удаление отправлен.")),
              );
            },
            child: const Text("Удалить", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
