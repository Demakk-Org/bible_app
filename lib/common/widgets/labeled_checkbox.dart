import 'package:flutter/material.dart';
import 'package:bible_app/common/utils/int_extension.dart';
import 'package:bible_app/core/theme/app_colors.dart';

class LabeledCheckbox extends StatelessWidget {
  const LabeledCheckbox({
    required this.value,
    required this.onChanged,
    required this.label,
    super.key,
    this.labelStyle,
    this.activeColor = AppColors.primary,
    this.alignment = MainAxisAlignment.start,
  });

  final bool value;
  final ValueChanged<bool?> onChanged;
  final String label;
  final TextStyle? labelStyle;
  final Color activeColor;
  final MainAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignment,
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            checkboxTheme: CheckboxThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1),
              ),
              side: WidgetStateBorderSide.resolveWith(
                (states) => const BorderSide(color: AppColors.gray500),
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              splashRadius: 12,
            ),
          ),
          child: SizedBox(
            height: 20,
            width: 20,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: activeColor,
              checkColor: Colors.white,
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ),
        25.ww,
        Flexible(
          child: GestureDetector(
            onTap: () => onChanged(!value),
            child: Text(
              label,
              style:
                  labelStyle ??
                  const TextStyle(
                    fontSize: 14,
                    height: 20 / 14,
                    letterSpacing: 0.08,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    color: AppColors.gray500,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
