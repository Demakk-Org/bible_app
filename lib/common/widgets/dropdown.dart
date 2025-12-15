import 'package:flutter/material.dart';
import 'package:bible_app/core/theme/app_colors.dart';

class DropDown extends StatelessWidget {
  const DropDown({
    required this.items,
    required this.onChanged,
    required this.value,
    super.key,
  });

  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: value,
      items: items.map(_buildMenuItem).toList(),
      onChanged: onChanged,
      underline: Container(),
      isDense: true,
      icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary),
    );
  }
}

DropdownMenuItem<String> _buildMenuItem(String value) {
  return DropdownMenuItem(
    value: value,
    child: Text(
      value,
      style: const TextStyle(
        color: AppColors.baseBlack,
        fontSize: 12,
        fontFamily: 'Poppins',
      ),
    ),
  );
}
