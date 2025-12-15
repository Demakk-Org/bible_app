import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bible_app/common/utils/logger.dart';

enum ThemeState { light, dark }

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState.light);

  void toggleTheme() {
    AppLogger.debug(
      'Change the state: $state',
      name: 'ThemeCubit: toggleTheme',
    );
    emit(state == ThemeState.dark ? ThemeState.light : ThemeState.dark);
  }
}
