import 'package:flutter/material.dart';

class SectionTextButton extends StatelessWidget {
  const SectionTextButton({
    required this.label,
    required this.callBackFn,
    super.key,
  });

  final String label;
  final VoidCallback callBackFn;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: callBackFn,
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          height: 22 / 16,
          color: Colors.black,
          letterSpacing: 0,
        ),
      ),
    );
  }
}
