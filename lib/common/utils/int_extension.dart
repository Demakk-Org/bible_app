import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension IntToSizedBox on int {
  SizedBox get ww => SizedBox(width: toDouble().w);
  SizedBox get hh => SizedBox(height: toDouble().h);
}
