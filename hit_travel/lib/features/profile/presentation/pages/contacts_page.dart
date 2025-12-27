import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hit_travel/core/constants/app_links.dart';
import 'package:hit_travel/core/di/locator.dart';
import 'package:hit_travel/core/theme/theme.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.blueColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Контакты',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_sharp, color: Colors.white),
            onPressed: () async {
              if (await canLaunchUrl(AppLinks.whatsappUri)) {
                await launchUrl(
                  AppLinks.whatsappUri,
                  mode: LaunchMode.externalApplication,
                );
              } else {
                serviceLocator<Talker>().error("Could not open WhatsApp.");
              }
            }
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            // logo
            Center(
              child: Image.asset(
                'assets/images/hit_logo.png',
                height: 75,
              ),
            ),
            const SizedBox(height: 20),

            // contacts
            Center(
              child: Text(
                'КОНТАКТЫ',
                style: TextStyle(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w100,
                  letterSpacing: 4,
                  color: Colors.grey[300],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Divider(height: 1, color: Colors.black12,),
            SizedBox(height: 6.h),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Оставить запрос на подбор тура',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // social buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  _buildSocialButton(
                    const Color(0xFF25D366),
                    FontAwesomeIcons.whatsapp,
                    AppLinks.whatsappUri,
                  ),
                  SizedBox(width: 12.w),
                  _buildSocialButton(
                    const Color(0xFFE4405F),
                    FontAwesomeIcons.instagram,
                    AppLinks.instagramUri,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Divider(height: 1, color: Colors.black12,),

            _buildContactItem(
              icon: Icons.phone,
              title: '+996 557 63 66 76',
              subtitle: 'Номер телефона',
            ),
            Divider(height: 1, color: Colors.black12,),

            _buildContactItem(
              icon: Icons.phone,
              title: '+996 700 63 66 76',
              subtitle: 'Номер телефона',
            ),
            Divider(height: 1, color: Colors.black12,),

            _buildContactItem(
              icon: Icons.phone,
              title: '+996 776 63 66 76',
              subtitle: 'Номер телефона',
            ),
            Divider(height: 1, color: Colors.black12,),

            _buildContactItem(
              icon: Icons.email_outlined,
              title: 'info@hit-travel.kg',
              subtitle: 'Электронная почта',
            ),
            Divider(height: 1, color: Colors.black12,),

            _buildContactItem(
              icon: Icons.calendar_today_outlined,
              title: 'Пн-пт с 10:00 до 19:00',
              subtitle: 'Рабочее время',
            ),
            Divider(height: 1, color: Colors.black12,),

            _buildContactItem(
              icon: Icons.calendar_today_outlined,
              title: 'Сб с 10:00 до 16:30',
              subtitle: 'Рабочее время',
            ),
            Divider(height: 1, color: Colors.black12,),

            _buildContactItem(
              icon: Icons.calendar_today_outlined,
              title: 'Воскресенье',
              subtitle: 'Выходной',
            ),
            Divider(height: 1, color: Colors.black12,),

            _buildContactItem(
              icon: Icons.location_on_outlined,
              title: 'Разакова 26',
              subtitle: 'Адрес',
            ),
            Divider(height: 1, color: Colors.black12,),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(Color color, IconData icon, Uri uri) {
    return Container(
      width: 56.w,
      height: 56.h,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () async {
            if (await canLaunchUrl(uri)) {
              await launchUrl(
                uri,
                mode: LaunchMode.externalApplication,
              );
            } else {
              serviceLocator<Talker>().error('Could not launch ${uri.toString()}');
            }
          },
          child: Center(
            child: FaIcon(icon, color: color, size: 28.sp),
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppTheme.blueColor,
            size: 28,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                //const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}