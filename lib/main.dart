import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:bible_app/app.dart';
import 'package:bible_app/common/utils/logger.dart';
import 'package:bible_app/core/bootstrap/bootstrap.dart';

void main() {
  runZonedGuarded(
    () async {
      // Configure centralized logging
      AppLogger.configureFlutterError();
      await AppBootstrap.ensureInitialized();
      runApp(const App());
    },
    (error, stackTrace) {
      // Intentionally not logging here; Crashlytics is configured in bootstrap.
      log(error.toString(), name: 'main');
    },
  );
}
