import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:bible_app/common/utils/logger.dart';
import 'package:bible_app/core/data/tutorial/tutorial.dart';
import 'package:bible_app/features/bible/data/model/bible.dart';
import 'package:bible_app/features/bible/data/model/bible_source.dart';
import 'package:bible_app/features/bible/data/model/verse.dart';
import 'package:path_provider/path_provider.dart';

class AppBootstrap {
  const AppBootstrap._();

  static Future<void> ensureInitialized() async {
    WidgetsFlutterBinding.ensureInitialized();

    await _initHiveAndRegisterAdapters();
    await initializeDateFormatting();
  }

  static Future<void> _initHiveAndRegisterAdapters() async {
    try {
      if (kIsWeb) {
        // Web: IndexedDB, no filesystem path
        await Hive.initFlutter();
      } else {
        // Mobile/Desktop: use app documents dir
        final dir = await getApplicationDocumentsDirectory();
        await Hive.initFlutter(dir.path);
      }

      Hive
        ..registerAdapter(VerseAdapter())
        ..registerAdapter(BibleAdapter())
        ..registerAdapter(BibleSourceAdapter())
        ..registerAdapter(TutorialAdapter());

      AppLogger.info('Hive Initialization Success', name: 'Hive Init');
    } on Exception catch (e, stacktrace) {
      AppLogger.error(
        e.toString(),
        name: 'Hive Init',
        error: e,
        stackTrace: stacktrace,
      );
    }
  }
}
