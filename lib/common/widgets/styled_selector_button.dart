import 'package:flutter/material.dart';
import 'package:bible_app/core/theme/app_colors.dart';

class StyledSelectorButton extends StatelessWidget {
  const StyledSelectorButton({
    required this.callbackFn,
    required this.label,
    this.isSelected = false,
    super.key,
  });

  final VoidCallback callbackFn;
  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callbackFn,
      child: Column(
        spacing: 4,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.baseBlack : AppColors.gray600,
              fontSize: 16,
              height: 24 / 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              letterSpacing: 0.15,
            ),
          ),
          if (isSelected)
            Container(
              width: 16,
              height: 3,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.all(Radius.circular(2)),
              ),
            ),
        ],
      ),
    );
  }
}
