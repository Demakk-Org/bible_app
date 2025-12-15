import 'package:flutter/material.dart';
import 'package:bible_app/core/theme/app_colors.dart';
import 'package:bible_app/core/theme/scheme_definitions.dart';
import 'package:bible_app/core/theme/schemes.dart';

class AppTheme {
  TextTheme textTheme = const TextTheme();

  TextTheme getTextTheme() => textTheme.copyWith(
    displayLarge: const TextStyle(
      letterSpacing: -2,
      fontSize: 57,
      height: 64 / 57,
    ),
    displayMedium: const TextStyle(
      letterSpacing: -1.5,
      fontSize: 45,
      height: 52 / 45,
    ),
    displaySmall: const TextStyle(
      letterSpacing: -1.25,
      fontSize: 36,
      height: 44 / 36,
    ),
    headlineLarge: const TextStyle(
      letterSpacing: -1,
      fontSize: 32,
      height: 40 / 32,
    ),
    headlineMedium: const TextStyle(
      letterSpacing: -0.5,
      fontSize: 28,
      height: 36 / 28,
    ),
    headlineSmall: const TextStyle(
      letterSpacing: -0.5,
      fontSize: 24,
      height: 32 / 24,
    ),
    titleLarge: const TextStyle(
      letterSpacing: -0.35,
      fontSize: 22,
      height: 28 / 22,
    ),
    titleMedium: const TextStyle(
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      fontSize: 16,
      height: 24 / 16,
    ),
    titleSmall: const TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14,
      height: 20 / 14,
    ),
    labelLarge: const TextStyle(
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      fontSize: 14,
      height: 20 / 14,
    ),
    labelMedium: const TextStyle(
      letterSpacing: 0.25,
      fontSize: 12,
      height: 16 / 12,
    ),
    labelSmall: const TextStyle(
      fontWeight: FontWeight.w500,
      letterSpacing: 0.25,
      fontSize: 11,
      height: 16 / 11,
    ),
    bodyLarge: const TextStyle(letterSpacing: 0, fontSize: 16, height: 24 / 16),
    bodyMedium: const TextStyle(
      letterSpacing: 0,
      fontSize: 14,
      height: 20 / 14,
    ),
    bodySmall: const TextStyle(
      letterSpacing: 0.25,
      fontSize: 12,
      height: 16 / 12,
    ),
  );

  ThemeData light() {
    return createTheme(AppSchemes.lightScheme());
  }

  ThemeData dark() {
    return createTheme(AppSchemes.darkScheme());
  }

  ThemeData createTheme(MaterialScheme materialScheme) {
    final theme = materialScheme.toThemeData();
    return theme.copyWith(
      scaffoldBackgroundColor: materialScheme.surface,
      textTheme: getTextTheme().apply(
        bodyColor: materialScheme.onSurface,
        displayColor: materialScheme.onSurface,
      ),
      appBarTheme: const AppBarTheme().copyWith(
        surfaceTintColor: materialScheme.surfaceContainer,
        backgroundColor: materialScheme.onSurface,
        // titleTextStyle: TextStyle().copyWith(
        //   color: materialScheme.primary,
        // ),
      ),
      // cardTheme: CardTheme(
      //   elevation: 8,
      //   clipBehavior: Clip.hardEdge,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(16),
      //   ),
      //   surfaceTintColor: materialScheme.surface,
      // ),
      searchBarTheme: const SearchBarThemeData(),
      sliderTheme: SliderThemeData(
        overlayShape: SliderComponentShape.noOverlay,
      ),
      chipTheme: ChipThemeData(selectedColor: materialScheme.primaryContainer),
      inputDecorationTheme: InputDecorationTheme(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(width: 3, color: materialScheme.primary),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: materialScheme.onSurface),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: materialScheme.onSurface),
        ),
      ),
      outlinedButtonTheme: const OutlinedButtonThemeData(),
      bottomSheetTheme: BottomSheetThemeData(
        surfaceTintColor: materialScheme.surfaceContainerLow,
        backgroundColor: materialScheme.surfaceContainerLow,
        modalBackgroundColor: materialScheme.surfaceContainerLow,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: AppColors.primary,
        backgroundColor: materialScheme.secondaryContainer,
        unselectedItemColor: materialScheme.onTertiaryContainer,
        selectedLabelStyle: const TextStyle(fontFamily: 'Poppins'),
        unselectedLabelStyle: const TextStyle(fontFamily: 'Poppins'),
      ),
      tooltipTheme: const TooltipThemeData(),
    );
  }

  static AppTheme of(BuildContext context) {
    return Theme.of(context) as AppTheme;
  }
}
