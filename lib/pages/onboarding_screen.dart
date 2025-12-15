import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_app/common/utils/int_extension.dart';
import 'package:bible_app/core/router/navigation.dart';
import 'package:bible_app/core/theme/app_colors.dart';
import 'package:bible_app/features/onboarding/data/onboarding_model.dart';
import 'package:bible_app/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:bible_app/features/onboarding/presentation/widgets/onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<OnboardingPageModel> _pages = [
    OnboardingPageModel(
      title: "Welcome",
      description:
          "Stay spiritually connected and grow with your community — anytime, anywhere.",
      imageAsset: "assets/images/onboarding/1.png",
    ),
    OnboardingPageModel(
      title: "Bible",
      description:
          "Access the full Bible, highlight verses, and join group studies with ease.",
      imageAsset: "assets/images/onboarding/2.png",
    ),
    OnboardingPageModel(
      title: "Audio",
      description:
          "Enjoy inspiring sermons and Bible audio wherever you are, hands-free.",
      imageAsset: "assets/images/onboarding/3.png",
    ),
    OnboardingPageModel(
      title: "Quiz",
      description:
          "Strengthen your understanding through fun, interactive Bible quizzes.",
      imageAsset: "assets/images/onboarding/4.png",
    ),
  ];

  void _next() {
    if (_currentIndex < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.read<OnboardingCubit>().complete();
      BibleRoute().go(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.baseWhite,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(15.w),
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: _pages.length,
                    onPageChanged: (index) =>
                        setState(() => _currentIndex = index),
                    itemBuilder: (_, index) =>
                        OnboardingPage(data: _pages[index]),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => Container(
                      margin: const EdgeInsets.all(4),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == index
                            ? AppColors.primary
                            : Colors.grey[400],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 20.h,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _next,
                      child: Text(
                        _currentIndex == _pages.length - 1
                            ? 'Get Started'
                            : 'Next',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_currentIndex <= _pages.length - 2)
            Positioned(
              top: 40,
              right: 20,
              child: TextButton(
                onPressed: () {
                  context.read<OnboardingCubit>().complete();
                  BibleRoute().go(context);
                },
                child: Row(
                  children: [
                    Text(
                      "Skip",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    5.ww,
                    Icon(
                      Icons.double_arrow_outlined,
                      color: Colors.grey[700],
                      weight: 100,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
