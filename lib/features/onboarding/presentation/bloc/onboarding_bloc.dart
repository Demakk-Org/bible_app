import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bible_app/common/utils/logger.dart';

class OnboardingCubit extends Cubit<bool> {
  OnboardingCubit() : super(false);

  final Box<bool> settingsBox = Hive.box('settings');

  Future<void> checkIfSeen() async {
    final seen = settingsBox.get('hasSeenOnboarding', defaultValue: false);
    AppLogger.info('seen: $seen', name: 'OnboardingCubit: checkIfSeen');
    emit(seen ?? false);
  }

  Future<void> complete() async {
    await settingsBox.put('hasSeenOnboarding', true);
    AppLogger.info(
      'Set the onboarding completed',
      name: 'OnboardingCubit: complete',
    );
    emit(true);
  }

  Future<void> reset() async {
    await settingsBox.put('hasSeenOnboarding', false);
    AppLogger.info('reset', name: 'OnboardingCubit: reset');
    emit(false);
  }
}
