import 'package:flutter/material.dart';
import 'package:bible_app/core/theme/app_colors.dart';
import 'package:bible_app/core/theme/scheme_definitions.dart';

abstract class AppSchemes {
  static MaterialScheme lightScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff22749E),
      surfaceTint: Color(0xff904a4b),
      onPrimary: Color(0xffffffff),
      //
      primaryContainer: AppColors.primary,
      //
      onPrimaryContainer: Color(0xff3b080d),
      secondary: Color(0xff3c6090),
      onSecondary: Color(0xffffffff),
      //
      secondaryContainer: AppColors.backgroundLight,
      //
      onSecondaryContainer: AppColors.secondaryLight,
      //
      tertiary: Color(0xff006875),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffD8E2FF),
      //
      onTertiaryContainer: Color(0xff2B4678),
      //
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      //
      surface: AppColors.backgroundLight,
      //
      onSurface: AppColors.green900,
      onSurfaceVariant: Color(0xff43474e),
      outline: Color(0xff9B9EA7),
      outlineVariant: Color(0xffe3e5ec),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2e3035),
      inverseOnSurface: Color(0xfff0f0f7),
      inversePrimary: Color(0xffffb3b2),
      primaryFixed: Color(0xffffdad9),
      onPrimaryFixed: Color(0xff3b080d),
      primaryFixedDim: Color(0xffffb3b2),
      onPrimaryFixedVariant: Color(0xff733335),
      secondaryFixed: Color(0xffd4e3ff),
      onSecondaryFixed: Color(0xff001c3a),
      secondaryFixedDim: Color(0xffa6c8ff),
      onSecondaryFixedVariant: Color(0xff224876),
      tertiaryFixed: Color(0xff9eefff),
      onTertiaryFixed: Color(0xff001f24),
      tertiaryFixedDim: Color(0xff82d3e2),
      onTertiaryFixedVariant: Color(0xff004e59),
      surfaceDim: Color(0xffd9dae0),
      surfaceBright: Color(0xfff9f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff3f3fa),
      surfaceContainer: Color(0xffededf4),
      surfaceContainerHigh: Color(0xffe7e8ee),
      surfaceContainerHighest: Color(0xffe1e2e9),
    );
  }

  static MaterialScheme darkScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: AppColors.baseWhite,
      surfaceTint: Color(0xffffb3b2),
      onPrimary: Color(0xff561d20),
      //
      primaryContainer: AppColors.primary,
      //
      onPrimaryContainer: Color(0xffffdad9),
      secondary: Color(0xffa6c8ff),
      onSecondary: Color(0xff00315e),
      //
      secondaryContainer: AppColors.surfaceDark,
      //
      onSecondaryContainer: Color(0xffd4e3ff),
      tertiary: Color(0xff82d3e2),
      onTertiary: Color(0xff00363e),
      tertiaryContainer: Color(0xff004e59),
      onTertiaryContainer: Color(0xff9eefff),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),

      //
      surface: AppColors.backgroundDark,

      //
      onSurface: Color(0xffe1e2e9),
      onSurfaceVariant: Color(0xffc3c6cf),
      outline: Color(0xff797D84),
      outlineVariant: Color(0xff3A3D43),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffE5E6E9),
      inverseOnSurface: Color(0xff2A2C32),
      inversePrimary: Color(0xff904a4b),
      primaryFixed: Color(0xffffdad9),
      onPrimaryFixed: Color(0xff3b080d),
      primaryFixedDim: Color(0xffffb3b2),
      onPrimaryFixedVariant: Color(0xff733335),
      secondaryFixed: Color(0xffd4e3ff),
      onSecondaryFixed: Color(0xff001c3a),
      secondaryFixedDim: Color(0xffa6c8ff),
      onSecondaryFixedVariant: Color(0xff224876),
      tertiaryFixed: Color(0xff9eefff),
      onTertiaryFixed: Color(0xff001f24),
      tertiaryFixedDim: Color(0xff82d3e2),
      onTertiaryFixedVariant: Color(0xff004e59),
      surfaceDim: Color(0xff0F1216),
      surfaceBright: Color(0xff37393E),
      surfaceContainerLowest: Color(0xff1D2024),
      surfaceContainerLow: Color(0xff282A2F),
      surfaceContainer: Color(0xff32353A),
      surfaceContainerHigh: Color(0xff43474E),
      surfaceContainerHighest: Color(0xff565960),
    );
  }
}
