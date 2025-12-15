import 'package:flutter/material.dart';
import 'package:bible_app/core/theme/app_colors.dart';

class ComingSoonView extends StatelessWidget {
  const ComingSoonView({super.key, this.imageFileName, this.pageName});

  final String? imageFileName;
  final String? pageName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            spacing: 16,
            children: [
              SizedBox(
                width: 100,
                child: Image.asset(
                  'assets/images/${imageFileName ?? 'feature.png'}',
                ),
              ),
              Text(
                'Coming soon!',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.baseBlack,
                  fontSize: 32,
                  fontFamily: 'Poppins',
                ),
              ),
              Text(
                'We will notify you when '
                '${pageName != null ? 'the $pageName' : 'this'} '
                'feature is ready',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.gray500,
                  fontSize: 24,
                  fontFamily: 'JosefinSans',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
