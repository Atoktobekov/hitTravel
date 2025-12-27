import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileListTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final IconData? icon;
  final Color? textColor;
  final bool isChevronNeeded;

  const ProfileListTile({
    super.key,
    required this.title,
    required this.onTap,
    this.icon,
    this.textColor,
    required this.isChevronNeeded,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minTileHeight: 42.h,
      leading: icon != null
          ? Icon(icon, size: 24.sp, color: textColor ?? Colors.black87)
          : null,
      title: Padding(
        padding: EdgeInsets.only(left: icon == null ? 10 : 0),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: textColor ?? Colors.black,
          ),
        ),
      ),
      trailing: isChevronNeeded
          ? Icon(Icons.chevron_right, size: 24.sp, color: Colors.black)
          : null,
      onTap: onTap,
    );
  }
}
