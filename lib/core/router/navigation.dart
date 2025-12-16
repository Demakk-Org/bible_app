import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bible_app/pages/bible_navigation_screen.dart';
import 'package:bible_app/pages/bookmarked_verses_screen.dart';
import 'package:bible_app/pages/bible_screen.dart';
import 'package:bible_app/pages/onboarding_screen.dart';
import 'package:bible_app/pages/splash_screen.dart';

part "./routes/home_routes.dart";
part 'navigation.g.dart';

class AppNavigation {
  AppNavigation._privateConstructor() {
    router = GoRouter(
      initialLocation: SplashRoute().location,
      navigatorKey: routerKey,
      routes: $appRoutes,
      redirect: _handleRedirect,
    );
  }

  static final AppNavigation _instance = AppNavigation._privateConstructor();

  static AppNavigation get instance => _instance;

  final GlobalKey<NavigatorState> routerKey = GlobalKey<NavigatorState>();
  late final GoRouter router;

  String? _redirectTo;

  String? get redirectTo => _redirectTo;

  void clearRedirectTo() => _redirectTo = null;

  /// Helper method to parse the navigation path from a given URI
  static String parseNavigationPath(Uri uri) => uri.scheme.contains('http')
      ? '${uri.path}?${uri.query}'
      : uri.hasScheme
      ? '/${uri.authority}${uri.path}?${uri.query}'
      : uri.toString();

  FutureOr<String?> _handleRedirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    final uri = state.uri;
    var path = parseNavigationPath(uri);

    if (path == '/') return path;

    return path;
  }
}

@TypedGoRoute<SplashRoute>(path: "/")
class SplashRoute extends GoRouteData with _$SplashRoute {
  SplashRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SplashScreen();
  }
}

@TypedGoRoute<OnboardingRoute>(path: '/onboarding')
class OnboardingRoute extends GoRouteData with _$OnboardingRoute {
  OnboardingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const OnboardingScreen();
  }
}
