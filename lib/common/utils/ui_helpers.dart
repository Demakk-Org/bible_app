import 'package:flutter/material.dart';

void showNotImplementedSnackbar(BuildContext context) {
  final snackBar = SnackBar(
    content: const Text("This feature is not implemented yet"),
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
    backgroundColor: Colors.orange[700],
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
