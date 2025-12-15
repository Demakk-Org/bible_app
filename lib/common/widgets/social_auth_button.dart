import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SocialAuthButton extends StatelessWidget {
  const SocialAuthButton({
    required this.text,
    required this.imageAsset,
    required this.onPressed,
    super.key,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black87,
  });

  final String text;
  final String imageAsset;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            imageAsset,
            height: 24,
            width: 24,
          ),
          SizedBox(width: 15.w),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w300,
              fontSize: 13.sp,
              letterSpacing: 0.08,
              height: 35 / 13,
            ),
          ),
        ],
      ),
    );
  }
}
