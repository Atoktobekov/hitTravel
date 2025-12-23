import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedAvatarIndex = 2;
  bool isCharterOnly = false;
  int hotelClass = 1;
  int selectedCategoryIndex = 0;
  final List<String> categories = ['Авиабилеты', 'Поиск туров', 'Авторские туры', 'Отели'];

  // Начальная позиция кнопки (справа внизу)
  Offset buttonPosition = Offset(180.w, 600.h);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Stack(
          children: [
            // Основной контент
            Column(
              children: [
                _buildAvatarSelector(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: _buildCategorySelector(),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: _buildSearchForm(),
                ),
              ],
            ),

            // Перетаскиваемая кнопка WhatsApp
            Positioned(
              left: buttonPosition.dx,
              top: buttonPosition.dy,
              child: Draggable(
                feedback: Material(
                  color: Colors.transparent,
                  child: _buildWhatsAppButtonContent(opacity: 0.7),
                ),
                childWhenDragging: Container(),
                onDragEnd: (details) {
                  setState(() {
                    // Вычитаем SafeArea top, если нужно идеальное позиционирование
                    buttonPosition = Offset(details.offset.dx, details.offset.dy - MediaQuery.of(context).padding.top);
                  });
                },
                child: _buildWhatsAppButtonContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarSelector() {
    final avatars = ['👨‍🦱', '🧔', '🤠', '😎', '🕶️'];
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: SizedBox(
        height: 70.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: avatars.length,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemBuilder: (context, index) {
            final isSelected = selectedAvatarIndex == index;
            return GestureDetector(
              onTap: () => setState(() => selectedAvatarIndex = index),
              child: Container(
                margin: EdgeInsets.only(right: 12.w),
                width: 54.h,
                height: 54.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey[300]!,
                    width: 2,
                  ),
                  color: Colors.grey[200],
                ),
                child: Center(
                  child: Text(avatars[index], style: TextStyle(fontSize: 26.sp)),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      height: 38.h,
      margin: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedCategoryIndex == index;
          return GestureDetector(
            onTap: () => setState(() => selectedCategoryIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.all(3),
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(18.r),
              ),
              alignment: Alignment.center,
              child: Text(
                categories[index],
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 11.sp,
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
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildInputField(label: 'Город вылета', value: 'Бишкек', icon: Icons.flight_takeoff),
          SizedBox(height: 8.h),
          _buildInputField(label: 'Страна, курорт, отель', value: 'Турция', icon: Icons.flight_land),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(child: _buildInputField(label: 'Дата вылета', value: '23.12 - 23.12')),
              SizedBox(width: 8.w),
              Expanded(child: _buildInputField(label: 'На сколько', value: '6 - 14 ночей')),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(child: _buildInputField(label: 'Кто летит', value: '2 взрослых', icon: Icons.person)),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Только чартер', style: TextStyle(fontSize: 10.sp, color: Colors.grey[600])),
                    SizedBox(
                      height: 32.h, // Ограничиваем высоту, чтобы Checkbox не раздувал форму
                      child: Checkbox(
                        value: isCharterOnly,
                        activeColor: Colors.blue,
                        onChanged: (v) => setState(() => isCharterOnly = v ?? false),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Класс отеля', style: TextStyle(fontSize: 10.sp, color: Colors.grey[600])),
                    Row(
                      children: List.generate(5, (i) => Icon(Icons.star, size: 16.sp, color: i < hotelClass ? Colors.amber : Colors.grey[300])),
                    ),
                  ],
                ),
              ),
              Expanded(child: _buildInputField(label: 'Питание', value: 'Любое')),
            ],
          ),
          SizedBox(height: 14.h),
          SizedBox(
            width: double.infinity,
            height: 42.h,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
              child: Text('Найти туры', style: TextStyle(fontSize: 14.sp, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({required String label, required String value, IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 10.sp, color: Colors.grey[600])),
        SizedBox(height: 4.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[200]!),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              Expanded(child: Text(value, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500))),
              if (icon != null) Icon(icon, color: Colors.blue, size: 14.sp),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWhatsAppButtonContent({double opacity = 1.0}) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: 160.w,
        height: 44.h,
        decoration: BoxDecoration(
          color: const Color(0xFF25D366),
          borderRadius: BorderRadius.circular(22.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white, size: 18.sp),
            SizedBox(width: 8.w),
            Text(
              'Чат с поддержкой',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none, // Чтобы не было желтых линий при Draggable
              ),
            ),
          ],
        ),
      ),
    );
  }
}