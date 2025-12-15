import 'package:flutter/material.dart';

extension IntExtensions on int {
  // Creates a SizedBox with this integer as the width
  SizedBox get ww => SizedBox(width: toDouble());

  // Creates a SizedBox with this integer as the height
  SizedBox get hh => SizedBox(height: toDouble());
}
