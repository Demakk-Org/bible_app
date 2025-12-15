import 'package:bible_app/features/daily_verse/data/data_sources/local_daily_verse_data_source.dart';
import 'package:bible_app/features/daily_verse/data/model/daily_verse.dart';
import 'package:bible_app/features/daily_verse/data/repository_impl/daily_verse_repository_impl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bible_app/core/data/tutorial/tutorial.dart';
import 'package:bible_app/core/data/tutorial/tutorial_repository_impl.dart';
import 'package:bible_app/features/bible/data/data_sources/bible_data_sources.dart';
import 'package:bible_app/features/bible/data/model/bible.dart';
import 'package:bible_app/features/bible/data/model/bible_source.dart';
import 'package:bible_app/features/bible/data/model/verse.dart';
import 'package:bible_app/features/bible/data/repository_impl/bible_repository_impl.dart';

class AppDependencies {
  AppDependencies({
    required this.bibleRepository,
    required this.tutorialRepository,
    required this.dailyVerseRepository,
  });

  final BibleRepositoryImpl bibleRepository;
  final TutorialRepositoryImpl tutorialRepository;
  final DailyVerseRepositoryImpl dailyVerseRepository;


  static Future<AppDependencies> init() async {
    await Hive.openBox<bool>('settings');
   
    final bibleBox = await Hive.openBox<Bible>('bibleBox');
    final bibleSourceBox = await Hive.openBox<BibleSource>('bibleSourceBox');
    final bookmarkBox = await Hive.openBox<Verse>('bookmarkBox');
    final bibleDataSource = BibleDataSources(
      bibleBox: bibleBox,
      bibleSourceBox: bibleSourceBox,
      bookmarkBox: bookmarkBox,
    );

    final bibleRepository =
        BibleRepositoryImpl(bibleDataSources: bibleDataSource);

    final dailyVerseBox = await Hive.openBox<DailyVerse>('dailyVerseBox');
    final localDailyVerseDataSource = LocalDailyVerseDataSource(
      dailyVerseBox: dailyVerseBox,
    );
    
    final dailyVerseRepository = DailyVerseRepositoryImpl(
      localDailyVerseDataSource: localDailyVerseDataSource,
    );
   
    final tutorialBox = await Hive.openBox<Tutorial>('tutorial');
    final tutorialRepository = TutorialRepositoryImpl(tutorialBox: tutorialBox);

    return AppDependencies(
      bibleRepository: bibleRepository,
      tutorialRepository: tutorialRepository,
      dailyVerseRepository: dailyVerseRepository,
    );
  }
}
