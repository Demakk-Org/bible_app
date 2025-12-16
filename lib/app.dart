import 'package:bible_app/common/utils/logger.dart';
import 'package:bible_app/features/daily_verse/data/repository_impl/daily_verse_repository_impl.dart';
import 'package:bible_app/features/daily_verse/presentation/bloc/daily_verse_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:bible_app/core/data/tutorial/tutorial_repository_impl.dart';
import 'package:bible_app/core/di/app_dependencies.dart';
import 'package:bible_app/core/router/navigation.dart';
import 'package:bible_app/core/theme/theme.dart';
import 'package:bible_app/core/theme/theme_bloc.dart';
import 'package:bible_app/features/bible/data/repository_impl/bible_repository_impl.dart';
import 'package:bible_app/features/bible/presentation/bloc/bible_bloc.dart';
import 'package:bible_app/features/bible/presentation/bloc/bible_source_bloc.dart';
import 'package:bible_app/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:bible_app/features/tutorial/presentation/cubit/tutorial_cubit.dart';
import 'package:bible_app/pages/splash_screen.dart';
import 'package:toastification/toastification.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final GoRouter _router;
  final AppTheme _appTheme = AppTheme();
  AppDependencies? _dependencies;

  @override
  void initState() {
    super.initState();
    _router = AppNavigation.instance.router;
    _initDependencies();
  }

  Future<void> _initDependencies() async {
    final deps = await AppDependencies.init();
    if (mounted) {
      setState(() {
        _dependencies = deps;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_dependencies == null) {
      return MaterialApp(
        theme: _appTheme.light(),
        darkTheme: _appTheme.dark(),
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(isInitialized: false),
      );
    }

    AppLogger.info('Initialized', name: "App: build");
    final deps = _dependencies!;

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: deps.bibleRepository),
        RepositoryProvider.value(value: deps.tutorialRepository),
        RepositoryProvider.value(value: deps.dailyVerseRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
          BlocProvider<BibleBloc>(
            create: (BuildContext context) =>
                BibleBloc(context.read<BibleRepositoryImpl>())
                  ..initializeBibleFromLocalSource()
                  ..getBookmarks(),
          ),
          BlocProvider<BibleSourceBloc>(
            create: (BuildContext context) =>
                BibleSourceBloc(context.read<BibleRepositoryImpl>())
                  ..getBibleSources(),
          ),
          BlocProvider(
            create: (context) => TutorialCubit(
              tutorialRepo: context.read<TutorialRepositoryImpl>(),
            )..initialize(),
          ),
          BlocProvider(create: (context) => OnboardingCubit()..checkIfSeen()),
          BlocProvider(
            create: (context) =>
                DailyVerseBloc(context.read<DailyVerseRepositoryImpl>())
                  ..getDailyVerse(DateTime.now()),
          ),
        ],
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return ScreenUtilInit(
              designSize: const Size(431, 935),
              builder: (context, child) {
                return ToastificationWrapper(
                  child: MaterialApp.router(
                    theme: _appTheme.light(),
                    darkTheme: _appTheme.dark(),
                    title: 'Bible For All',
                    themeMode: state == ThemeState.dark
                        ? ThemeMode.dark
                        : ThemeMode.light,
                    routerConfig: _router,
                    debugShowCheckedModeBanner: false,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
