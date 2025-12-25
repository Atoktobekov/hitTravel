import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_travel/features/auth/presentation/pages/login_page.dart';
import 'package:hit_travel/features/auth/presentation/pages/register_page.dart';
import 'package:hit_travel/shared/presentation/widgets/divider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Профиль',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w100),
        ),
        backgroundColor: Color(0xFF026ed1),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.chat_sharp, size: 24.sp),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Color(0xFF026ed1),
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 20.h),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(18.w),
                child: Column(
                  children: [
                    // avatar
                    Container(
                      width: 65.h,
                      height: 65.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.blue.withValues(alpha: 0.2),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.person_sharp,
                        size: 45.sp,
                        color: Colors.blue.withValues(alpha: 0.8),
                      ),
                    ),
                    SizedBox(height: 18.h),
                    Text(
                      'Присоединяйтесь к нам\nпрямо сейчас',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.w),
                      child: _buildAuthButton(
                        label: 'Войти',
                        onPressed: () {
                          // TODO: Навигация на страницу входа
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              fullscreenDialog: true, // Экран выедет снизу
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.w),
                      child: _buildAuthButton(
                        label: 'Создать профиль',
                        onPressed: () {
                          // TODO: Навигация на регистрацию
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              fullscreenDialog: true,
                              builder: (context) => const RegistrationPage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildMenuTile(
              icon: Icons.contact_support_outlined,
              title: 'Контакты',
              onTap: () {},
            ),
            blueDivider,
            // space for bottom
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 40.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFc8def3),
          foregroundColor: Colors.blue,
          elevation: 0,
          side: BorderSide(color: Colors.blue.withValues(alpha: 0.4)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.r),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Color(
              0xff157ed4)),
        ),
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue, size: 22.sp),
        title: Text(
          title,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        trailing: Icon(Icons.chevron_right, size: 22.sp, color: Colors.black),
        onTap: onTap,
      ),
    );
  }
}
