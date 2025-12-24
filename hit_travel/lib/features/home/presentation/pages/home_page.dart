import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hit_travel/features/home/domain/entities/story_item.dart';
import 'package:hit_travel/features/home/presentation/pages/story_video_page.dart';
import 'package:hit_travel/shared/presentation/widgets/dash_line_painter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<StoryItem> stories;
  int selectedAvatarIndex = 0;
  bool isCharterOnly = false;
  int hotelClass = 1;
  int selectedCategoryIndex = 0;
  final List<String> categories = [
    'Поиск туров',
    'Авиабилеты',
    'Отели',
    'Авторские туры',
  ];

  @override
  void initState() {
    super.initState();
    stories = List.generate(
      6,
          (i) => StoryItem(
        avatarUrl: 'https://i.pravatar.cc/150?u=$i',
        videoUrl:
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Чтобы избежать проблем с клавиатурой, если появятся текстовые поля
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Фон
          Positioned.fill(
            child: Image.asset(
              'assets/images/home_bg.jpeg',
              fit: BoxFit.cover,
            ),
          ),

          // Контент
          SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    _buildStories(),
                    SizedBox(height: 4.h),
                    _buildCategorySelector(),
                    SizedBox(height: 12.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: _buildSearchForm(),
                    ),
                  ],
                ),
                _buildFloatingWhatsApp(),
              ],
            ),
          ),
        ],
      ),

    );
  }

  Widget _buildStories() {
    return SizedBox(
      height: 96.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: stories.length,
        itemBuilder: (context, index) {
          final story = stories[index];

          return GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => StoryVideoPage(videoUrl: story.videoUrl),
                ),
              );
              setState(() => story.isViewed = true);
            },
            child: Container(
              margin: EdgeInsets.only(right: 12.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: story.isViewed
                    ? null
                    : Border.all(color: Color(0xFF0073F7), width: 2.5),
              ),
              child: CircleAvatar(
                radius: 30.r,
                backgroundImage: NetworkImage(story.avatarUrl),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      height: 46.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(2.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(categories.length, (index) {
          final isSelected = selectedCategoryIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() => selectedCategoryIndex = index);
              // TODO handle selection logic
              log('Selected: ${categories[index]}');
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.decelerate,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Text(
                categories[index],
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected
                      ? const Color(0xFF0A2540) // тёмно-синий, не чёрный
                      : Colors.white.withOpacity(0.9),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }


  Widget _buildSearchForm() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // important for non-scroll
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Stack(
              children: [
                Positioned(
                  right: 12.w,
                  top: 36.h,
                  bottom: 39.h,
                  child: CustomPaint(painter: DashLinePainter()),
                ),
                Column(
                  children: [
                    _buildFormRow('Город вылета', 'Бишкек', Icons.location_on_outlined),
                    Padding(
                      padding: EdgeInsets.only(left: 1.w, right: 19.w),
                      child: Divider(
                        height: 26.h,
                        thickness: 1,
                        color: const Color(0xFF0073F7).withAlpha(70),
                      ),
                    ),
                    _buildFormRow(
                      'Страна, курорт, отель',
                      'Турция',
                      Icons.location_on_outlined,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Divider(height: 1,  color: const Color(0xFF0073F7).withAlpha(70)),
          ),
          Row(
            children: [
              _buildGridItem('Дата вылета', '23.12 - 23.12'),
              _buildVerticalDivider(),
              _buildGridItem('На сколько', '6 - 14 ночей'),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Divider(height: 1, color: const Color(0xFF0073F7).withAlpha(70)),
          ),
          Row(
            children: [
              _buildGridItem('Кто летит', '2 взрослых'),
              _buildVerticalDivider(),
              _buildGridItemWidget(
                'Только чартер',
                Row(
                  children: [
                    SizedBox(
                      width: 24.w,
                      height: 24.h,
                      child: Checkbox(
                        value: isCharterOnly,
                        onChanged: (v) => setState(() => isCharterOnly = v!),
                        side: BorderSide(color: Colors.grey.shade400, width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        activeColor: const Color(0xFF0073F7),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      isCharterOnly ? 'Включено' : 'Выключено',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Divider(height: 1, color: const Color(0xFF0073F7).withAlpha(70)),
          ),
          Row(
            children: [
              _buildGridItemWidget(
                'Класс отеля',
                Row(
                  children: List.generate(
                    5,
                    (i) => Icon(
                      Icons.star,
                      size: 18.sp,
                      color: i < 1 ? Colors.amber : Colors.grey.shade300,
                    ),
                  ),
                ),
              ),
              _buildVerticalDivider(),
              _buildGridItem('Питание', 'Любое'),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(14.w),
            child: SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF026ed1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Найти туры',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade500),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        Icon(icon, color: const Color(0xFF0073F7), size: 24.sp),
      ],
    );
  }

  Widget _buildGridItem(String label, String value) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade500),
            ),
            SizedBox(height: 2.h),
            Text(
              value,
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItemWidget(String label, Widget child) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade500),
            ),
            SizedBox(height: 2.h),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalDivider() =>
      Container(width: 1, height: 40.h, color: const Color(0xFF0073F7).withAlpha(70));

  Widget _buildFloatingWhatsApp() {
    return Positioned(
      bottom: 20.h,
      right: 16.w,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: const Color(0xFF25D366),
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white, size: 22.sp),
            SizedBox(width: 8.w),
            Text(
              'Чат с поддержкой',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}





