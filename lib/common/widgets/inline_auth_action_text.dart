import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InlineAuthActionText extends StatelessWidget {
  const InlineAuthActionText({
    required this.prompt,
    required this.actionText,
    required this.onTap,
    super.key,
    this.promptColor = const Color(0xFF444444),
    this.actionColor = Colors.teal,
  });

  final String prompt;
  final String actionText;
  final VoidCallback onTap;
  final Color promptColor;
  final Color actionColor;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: '$prompt ',
        style: TextStyle(
          color: promptColor,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          height: 24 / 16,
          letterSpacing: 0.08,
          fontFamily: 'Poppins',
        ),
        children: [
          TextSpan(
            text: actionText,
            style: TextStyle(
              color: actionColor,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
            ),
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        ],
      ),
    );
  }
}
