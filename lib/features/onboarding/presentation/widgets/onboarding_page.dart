import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_app/common/utils/int_extension.dart';
import 'package:bible_app/features/onboarding/data/onboarding_model.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({required this.data, super.key});
  final OnboardingPageModel data;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Center(child: Image.asset(data.imageAsset, width: 300.w)),
        ),
        Text(
          data.title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 24.sp,
            fontFamily: 'Poppins',
          ),
          textAlign: TextAlign.center,
        ),
        25.hh,
        Text(
          data.description,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontFamily: 'Poppins',
            fontSize: 20.sp,
          ),
        ),
        25.hh,
      ],
    );
  }
}
