import 'package:flutter/material.dart';
import 'package:bible_app/core/theme/app_colors.dart';

class ContainedIconButton extends StatelessWidget {
  const ContainedIconButton({
    required this.icon,
    required this.action,
    super.key,
    this.backgroundColor,
  });

  final IconData icon;
  final VoidCallback action;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.green900,
        shape: BoxShape.circle,
      ),
      constraints: const BoxConstraints.tightFor(width: 32, height: 32),
      padding: EdgeInsets.zero,
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: action,
        icon: Icon(icon, size: 20, color: Colors.white),
      ),
    );
  }
}
