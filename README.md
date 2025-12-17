# Bible For All

Offline-first Bible reading app built with Flutter.

## Features

- **Bible reading**

  - Read locally bundled Bible content (`assets/bible/`).
  - Change book/chapter.
  - Long-press verses to select and reveal actions (share/bookmark/copy).

- **Bookmarks**

  - Bookmark verses while reading.
  - View and remove bookmarks from the Bookmarks screen.
  - Tap a bookmark to jump back to that verse.

- **Search / navigation**

  - Search within Bible navigation screen to jump by book/chapter.

- **Daily verse**

  - Shows a daily verse with share/copy.
  - When possible, it resolves the displayed verse from the currently selected Bible (fallbacks to the daily verse payload).

- **In-app tutorials (coach marks)**
  - Bible screen tutorial (book/chapter picker, bookmarks, search, verse selection actions).
  - Bookmarks screen tutorial (only shown if there is at least one bookmark).
  - Tutorial completion state is persisted locally.

## Tech stack

- **Flutter + Material**
- **State management**: `flutter_bloc`
- **Routing**: `go_router` (typed routes)
- **Local persistence**: `hive_flutter`
- **Sharing**: `share_plus` (also supports sharing captured widgets via `RepaintBoundary`)
- **Tutorial overlays**: `tutorial_coach_mark`

## Project structure (high level)

- `lib/app.dart`: app bootstrap, dependency injection, bloc/repository wiring
- `lib/core/router/`: app navigation and typed routes
- `lib/features/`: feature modules (`bible`, `daily_verse`, `tutorial`, `onboarding`, ...)
- `assets/bible/`: bundled Bible data

## Running the app

Prerequisites:

- Flutter SDK (see `pubspec.yaml` for the Dart SDK constraint)

Commands:

```bash
flutter pub get
flutter run
```

### Code generation

This project uses code generation for:

- `hive_generator`
- `go_router_builder`

Run:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Android notes

- **Application ID / namespace**: `com.melkatole1.bible_app`
- **NDK version**: pinned to `27.0.12077973` in `android/app/build.gradle.kts`
- **Release signing**:
  - `android/app/build.gradle.kts` loads signing config from `android/key.properties`.
  - Create your keystore and configure `key.properties` accordingly.

## Privacy

The app is designed to be offline-first and stores data locally on-device (e.g., bookmarks and tutorial completion flags). For a full statement, see the project privacy policy.
