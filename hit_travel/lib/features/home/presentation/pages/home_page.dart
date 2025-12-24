import 'dart:developer';
import 'package:url_launcher/url_launcher.dart';
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
        thumbnailUrl: 'https://i.pravatar.cc/150?u=$i',
        videoUrl:
            'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // to avoid keyboard overlap
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Фон
          Positioned.fill(
            child: Image.asset('assets/images/home_bg.jpeg', fit: BoxFit.cover),
          ),

          // content
          SafeArea(
            bottom: false,
            child: Stack(
              children: [
                // stories and category selector
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildStories(),
                    SizedBox(height: 4.h),
                    _buildCategorySelector(),
                  ],
                ),

                // form and whatsapp
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 14.w, bottom: 10.h),
                        child: _buildFloatingWhatsAppContent(),
                      ),
                      _buildSearchForm(),
                    ],
                  ),
                ),
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
                border: Border.all(
                  color: story.isViewed
                      ? Colors.transparent
                      : const Color(0xFF0073F7),
                  width: 2.5,
                ),
              ),
              child: CircleAvatar(
                radius: 30.r,
                backgroundImage: NetworkImage(story.thumbnailUrl),
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
        color: Colors.black.withValues(alpha: 0.26),
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
                  color: isSelected ? const Color(0xFF0A2540) : Colors.white,
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
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18.r),
          topRight: Radius.circular(18.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
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
                    _buildFormRow(
                      'Город вылета',
                      'Бишкек',
                      Icons.location_on_outlined,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 1.w, right: 19.w),
                      child: Divider(
                        height: 24.h,
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
            child: Divider(
              height: 1,
              color: const Color(0xFF0073F7).withAlpha(70),
            ),
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
            child: Divider(
              height: 1,
              color: const Color(0xFF0073F7).withAlpha(70),
            ),
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
                        onChanged: (value) =>
                            setState(() => isCharterOnly = value!),
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
            child: Divider(
              height: 1,
              color: const Color(0xFF0073F7).withAlpha(70),
            ),
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
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Divider(
              height: 1,
              color: const Color(0xFF0073F7).withAlpha(70),
            ),
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
          Divider(height: 1, color: const Color(0xFF0073F7).withAlpha(70)),
          SizedBox(
            height: MediaQuery.of(context).padding.bottom > 0
                ? MediaQuery.of(context).padding.bottom
                : 8.h,
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

  Widget _buildVerticalDivider() => Container(
    width: 1,
    height: 40.h,
    color: const Color(0xFF0073F7).withAlpha(70),
  );

  Widget _buildFloatingWhatsAppContent() {
    final Uri whatsappUri = Uri.parse('https://wa.me/996700636676').replace(
      queryParameters: {
        'text': 'Здравствуйте!\n\nПишу из приложения Hit Travel\n\n',
      },
    );

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF25D366),
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      // use material to make it work
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            if (await canLaunchUrl(whatsappUri)) {
              await launchUrl(
                whatsappUri,
                mode: LaunchMode.externalApplication,
              );
            } else {
              log('WhatsApp not available');
            }
          },
          borderRadius: BorderRadius.circular(30.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  FontAwesomeIcons.whatsapp,
                  color: Colors.white,
                  size: 22.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Чат с поддержкой',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
