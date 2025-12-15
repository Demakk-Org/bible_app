import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_app/core/theme/app_colors.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    required this.label,
    required this.controller,
    super.key,
    this.hidable = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.autofillHints,
  });

  final String label;
  final bool hidable;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Iterable<String>? autofillHints;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.hidable ? _obscure : false,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      autofillHints: widget.autofillHints,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyle(
          color: AppColors.gray500,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.08,
          height: 35 / 14,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.gray500),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        suffixIcon: widget.hidable
            ? IconButton(
                icon: Icon(
                  !_obscure ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.gray500,
                ),
                onPressed: () {
                  setState(() {
                    _obscure = !_obscure;
                  });
                },
              )
            : null,
      ),
    );
  }
}
