import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bible_app/core/router/navigation.dart';
import 'package:bible_app/features/onboarding/presentation/bloc/onboarding_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({this.isInitialized = true, super.key});

  final bool isInitialized;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    if (!widget.isInitialized) {
      return const _Screen();
    }

    return BlocListener<OnboardingCubit, bool>(
      listener: (context, onboardingState) {
        if (onboardingState == false) {
          OnboardingRoute().go(context);
        } else {
          BibleRoute().go(context);
        }
      },
      child: const _Screen(),
    );
  }
}

class _Screen extends StatelessWidget {
  const _Screen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 16,
        children: [
          Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Text(
                "Bible For All",
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(
            height: 40,
            width: 40,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Color.fromARGB(255, 33, 32, 32),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
