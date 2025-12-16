part of './../navigation.dart';

class BibleRoute extends GoRouteData with _$BibleRoute {
  BibleRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const BibleScreen();
  }
}

@TypedShellRoute<MainShellRoute>(
  routes: [
    TypedGoRoute<BibleRoute>(
      path: "/bible",
      routes: [
        TypedGoRoute<BookmarksRoute>(path: "bookmarks"),
        TypedGoRoute<BibleNavigationRoute>(path: "bible-navigation"),
      ],
    ),
  ],
)
class MainShellRoute extends ShellRouteData {
  MainShellRoute();

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return Scaffold(
      body: navigator,
    );
  }
}

class BibleNavigationRoute extends GoRouteData with _$BibleNavigationRoute {
  BibleNavigationRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const BibleNavigationScreen();
  }
}

class BookmarksRoute extends GoRouteData with _$BookmarksRoute {
  BookmarksRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const BookmarkedVersesScreen();
  }
}
