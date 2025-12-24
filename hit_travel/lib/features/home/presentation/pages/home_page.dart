import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // gradient background
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.lightBlue, Colors.white],
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    _buildAvatarSelector(),
                    SizedBox(height: 10.h),
                    _buildCategorySelector(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: _buildSearchForm(),
                    ),
                    SizedBox(height: 100.h), // Отступ под кнопку
                  ],
                ),
              ),
              _buildFloatingWhatsApp(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSelector() {
    return SizedBox(
      height: 100.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemBuilder: (context, index) {
          final isSelected = selectedAvatarIndex == index;
          return GestureDetector(
            onTap: () => setState(() => selectedAvatarIndex = index),
            child: Container(
              margin: EdgeInsets.only(right: 12.w),
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? Colors.blue
                      : Colors.white.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                radius: 35.r,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(
                  'https://i.pravatar.cc/150?u=$index',
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      height: 44.h,
      margin: EdgeInsets.only(bottom: 20.h, left: 16.w, right: 16.w),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedCategoryIndex == index;
          return GestureDetector(
            onTap: () => setState(() => selectedCategoryIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: EdgeInsets.only(right: 8.w),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white
                    : Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(22.r),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 2,
                          offset: Offset(0,1),
                        ),
                      ]
                    : [],
              ),
              alignment: Alignment.center,
              child: Text(
                categories[index],
                style: TextStyle(
                  color: isSelected
                      ? Colors.black87
                      : Colors.white.withOpacity(0.9),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 13.sp,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchForm() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Блок вылета и назначения с вертикальной линией
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Stack(
              children: [
                Positioned(
                  right: 12.w,
                  top: 25.h,
                  bottom: 25.h,
                  child: CustomPaint(painter: DashLinePainter()),
                ),
                Column(
                  children: [
                    _buildFormRow('Город вылета', 'Бишкек', Icons.location_on),
                    Divider(
                      height: 32.h,
                      thickness: 1,
                      color: Colors.grey.shade100,
                    ),
                    _buildFormRow(
                      'Страна, курорт, отель',
                      'Турция',
                      Icons.location_on,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade100),
          // Сетка параметров
          Row(
            children: [
              _buildGridItem('Дата вылета', '23.12 - 23.12', flex: 1),
              _buildVerticalDivider(),
              _buildGridItem('На сколько', '6 - 14 ночей', flex: 1),
            ],
          ),
          Divider(height: 1, color: Colors.grey.shade100),
          Row(
            children: [
              _buildGridItem('Кто летит', '2 взрослых', flex: 1),
              _buildVerticalDivider(),
              _buildGridItemWidget(
                'Только чартер',
                Row(
                  children: [
                    SizedBox(
                      width: 24.w,
                      child: Checkbox(
                        value: isCharterOnly,
                        onChanged: (v) => setState(() => isCharterOnly = v!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Выключено',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                flex: 1,
              ),
            ],
          ),
          Divider(height: 1, color: Colors.grey.shade100),
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
                flex: 1,
              ),
              _buildVerticalDivider(),
              _buildGridItem('Питание', 'Любое', flex: 1),
            ],
          ),
          // Кнопка
          Padding(
            padding: EdgeInsets.all(16.w),
            child: SizedBox(
              width: double.infinity,
              height: 54.h,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0073F7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Найти туры',
                  style: TextStyle(
                    fontSize: 16.sp,
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
                style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade500),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        Icon(icon, color: const Color(0xFF0073F7), size: 24.sp),
      ],
    );
  }

  Widget _buildGridItem(String label, String value, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade500),
            ),
            SizedBox(height: 4.h),
            Text(
              value,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItemWidget(String label, Widget child, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade500),
            ),
            SizedBox(height: 4.h),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalDivider() =>
      Container(width: 1, height: 50.h, color: Colors.grey.shade100);

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
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white, size: 20.sp),
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

// Отрисовка пунктирной линии между иконками геолокации
class DashLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 5, dashSpace = 3, startY = 0;
    final paint = Paint()
      ..color = Colors.blue.shade200
      ..strokeWidth = 1.5;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
