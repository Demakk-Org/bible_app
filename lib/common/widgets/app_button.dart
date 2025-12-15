import 'package:flutter/material.dart';
import 'package:bible_app/core/theme/app_colors.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    required this.text,
    required this.onPressed,
    super.key,
    this.isLoading = false,
    this.isDisabled = false,
  });
  final String text;
  final bool isLoading;
  final VoidCallback onPressed;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isDisabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isDisabled ? AppColors.gray500 : AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          fontFamily: 'Poppins',
          height: 35 / 16,
        ),
      ),
      child: isLoading
          ? Container(
              padding: const EdgeInsets.all(5),
              height: 35,
              width: 35,
              child: const CircularProgressIndicator(
                color: AppColors.baseWhite,
                strokeWidth: 2,
              ),
            )
          : Text(text),
    );
  }
}
