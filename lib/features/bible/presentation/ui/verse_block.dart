import 'package:flutter/material.dart';
import 'package:bible_app/core/theme/app_colors.dart';
import 'package:bible_app/features/bible/data/model/verse.dart';

class VerseBlock extends StatelessWidget {
  const VerseBlock({
    required this.verse,
    required this.onLongPress,
    required this.onTap,
    super.key,
    this.isSelected = false,
    this.isBookmarked = false,
  });

  final Verse verse;
  final VoidCallback onLongPress;
  final VoidCallback onTap;
  final bool isSelected;
  final bool isBookmarked;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary
                : isBookmarked
                ? AppColors.tertiaryDark.withValues(alpha: 0.5)
                : AppColors.backgroundLight,
          ),
          child: Stack(
            children: [
              Text(
                '   ${verse.text}',
                style: TextStyle(
                  fontSize: 20,
                  height: 22 / 20,
                  fontFamily: 'JosefinSans',
                  color: (isSelected || isBookmarked)
                      ? AppColors.baseWhite
                      : AppColors.baseBlack,
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Row(
                  children: [
                    Text(
                      verse.verse.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'JosefinSans',
                        color: (isSelected || isBookmarked)
                            ? AppColors.baseWhite
                            : AppColors.baseBlack,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
