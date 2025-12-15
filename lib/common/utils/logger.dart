//
// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart' as pkg;

class AppLogger {
  AppLogger._();

  static LogLevel _minLevel = kReleaseMode ? LogLevel.warning : LogLevel.debug;
  static pkg.Logger _logger = _buildLogger();
  // In-memory log ring buffer (for quick in-app diagnostics)
  static final List<String> _memory = <String>[];
  static int _memoryMax = 2000; // default capacity

  /// Configure the minimum level printed/logged.
  static void setMinLevel(LogLevel level) {
    _minLevel = level;
    // Rebuild logger with new minimum level in debug/profile.
    if (!kReleaseMode) {
      _logger = _buildLogger();
    }
  }

  /// Returns a trimmed stack trace that skips frames belonging to AppLogger
  /// so PrettyPrinter shows the original call site.
  static StackTrace _callerStackTrace() {
    final current = StackTrace.current;
    final lines = current.toString().split('\n');
    var i = 0;
    while (i < lines.length) {
      final line = lines[i];
      // Skip frames inside our logger utility
      if (line.contains('/common/utils/logger.dart') ||
          line.contains(r'\common\utils\logger.dart') ||
          line.contains('AppLogger.')) {
        i++;
        continue;
      }
      break;
    }
    if (i > 0 && i < lines.length) {
      return StackTrace.fromString(lines.sublist(i).join('\n'));
    }
    return current;
  }

  /// Base log call; prefer using the level helpers below.
  static void log(
    LogLevel level,
    String message, {
    String name = 'App',
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (level.index < _minLevel.index) return;
    // Title on first line (name), message on second line
    final msg = '$name\n$message';
    final ts = DateTime.now().toIso8601String();
    final line = '$ts ${_levelLabel(level)} $msg'
        '${error != null ? ' | error: $error' : ''}'
        '${stackTrace != null ? '\n$stackTrace' : ''}';
    _appendToMemory(line);

    if (kReleaseMode) {
      // Keep developer.log in release for better tooling integration
      developer.log(
        msg,
        name: name,
        level: _toDeveloperLevel(level),
        error: error,
        stackTrace: stackTrace,
      );
      return;
    }

    // Pretty, colored output in debug/profile
    _logger.log(
      _toPkgLevel(level),
      msg,
      error: error,
      // Use caller stack so PrettyPrinter points to invocation site, not AppLogger.
      stackTrace: stackTrace ?? _callerStackTrace(),
    );
  }

  static void verbose(
    String message, {
    String name = 'App',
    Object? error,
    StackTrace? stackTrace,
  }) =>
      log(
        LogLevel.verbose,
        message,
        name: name,
        error: error,
        stackTrace: stackTrace,
      );
  static void debug(
    String message, {
    String name = 'App',
    Object? error,
    StackTrace? stackTrace,
  }) =>
      log(
        LogLevel.debug,
        message,
        name: name,
        error: error,
        stackTrace: stackTrace,
      );
  static void info(
    String message, {
    String name = 'App',
    Object? error,
    StackTrace? stackTrace,
  }) =>
      log(
        LogLevel.info,
        message,
        name: name,
        error: error,
        stackTrace: stackTrace,
      );
  static void warning(
    String message, {
    String name = 'App',
    Object? error,
    StackTrace? stackTrace,
  }) =>
      log(
        LogLevel.warning,
        message,
        name: name,
        error: error,
        stackTrace: stackTrace,
      );
  static void error(
    String message, {
    String name = 'App',
    Object? error,
    StackTrace? stackTrace,
  }) =>
      log(
        LogLevel.error,
        message,
        name: name,
        error: error,
        stackTrace: stackTrace,
      );
  static void wtf(
    String message, {
    String name = 'App',
    Object? error,
    StackTrace? stackTrace,
  }) =>
      log(
        LogLevel.wtf,
        message,
        name: name,
        error: error,
        stackTrace: stackTrace,
      );

  /// Hook into FlutterError to log framework errors in a consistent way.
  static void configureFlutterError() {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (kReleaseMode) {
        // In release send to Zone to allow top-level crash reporting.
        Zone.current.handleUncaughtError(
          details.exception,
          details.stack ?? StackTrace.current,
        );
      } else {
        // Also show in console during debug/dev.
        FlutterError.dumpErrorToConsole(details);
      }
      AppLogger.error(
        details.exceptionAsString(),
        name: 'FlutterError',
        stackTrace: details.stack,
      );
    };
  }

  static LogTimer time(String label, {String name = 'App'}) => LogTimer(
        label,
        name: name,
      );

  static int _toDeveloperLevel(LogLevel level) {
    switch (level) {
      case LogLevel.verbose:
        return 500;
      case LogLevel.debug:
        return 700;
      case LogLevel.info:
        return 800;
      case LogLevel.warning:
        return 900;
      case LogLevel.error:
        return 1000;
      case LogLevel.wtf:
        return 1200;
      case LogLevel.none:
        return 2000;
    }
  }

  static pkg.Logger _buildLogger() {
    return pkg.Logger(
      level: _toPkgLevel(_minLevel),
      printer: pkg.PrettyPrinter(
        methodCount: 0,
        errorMethodCount: kReleaseMode ? 0 : 5,
        lineLength: 80,
        colors: !kReleaseMode,
        printEmojis: false,
      ),
    );
  }

  static pkg.Level _toPkgLevel(LogLevel level) {
    switch (level) {
      case LogLevel.verbose:
        return pkg.Level.trace;
      case LogLevel.debug:
        return pkg.Level.debug;
      case LogLevel.info:
        return pkg.Level.info;
      case LogLevel.warning:
        return pkg.Level.warning;
      case LogLevel.error:
        return pkg.Level.error;
      case LogLevel.wtf:
        return pkg.Level.fatal;
      case LogLevel.none:
        return pkg.Level.off;
    }
  }

  // ===== In-memory buffer helpers =====
  static void setMemoryCapacity(int max) {
    if (max <= 0) return;
    _memoryMax = max;
    // Trim immediately if needed
    if (_memory.length > _memoryMax) {
      _memory.removeRange(0, _memory.length - _memoryMax);
    }
  }

  static List<String> dumpMemoryLogs() => List.unmodifiable(_memory);

  static void clearMemoryLogs() => _memory.clear();

  static void _appendToMemory(String line) {
    _memory.add(line);
    final overflow = _memory.length - _memoryMax;
    if (overflow > 0) {
      _memory.removeRange(0, overflow);
    }
  }

  static String _levelLabel(LogLevel level) {
    switch (level) {
      case LogLevel.verbose:
        return '[V]';
      case LogLevel.debug:
        return '[D]';
      case LogLevel.info:
        return '[I]';
      case LogLevel.warning:
        return '[W]';
      case LogLevel.error:
        return '[E]';
      case LogLevel.wtf:
        return '[WTF]';
      case LogLevel.none:
        return '[X]';
    }
  }
}

enum LogLevel { verbose, debug, info, warning, error, wtf, none }

/// Minimal Bloc observer that routes events to AppLogger.
class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    AppLogger.debug(
      'change: ${change.currentState} -> ${change.nextState}',
      name: bloc.runtimeType.toString(),
    );
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    AppLogger.debug(
      'transition: ${transition.currentState} --(${transition.event})--> ${transition.nextState}',
      name: bloc.runtimeType.toString(),
    );
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    AppLogger.error(
      'bloc error: $error',
      name: bloc.runtimeType.toString(),
      error: error,
      stackTrace: stackTrace,
    );
    super.onError(bloc, error, stackTrace);
  }
}

class LogTimer {
  LogTimer(this.label, {required this.name}) : _sw = Stopwatch()..start();

  final String label;
  final String name;
  final Stopwatch _sw;

  void end({LogLevel level = LogLevel.debug}) {
    _sw.stop();
    AppLogger.log(
      level,
      '$label took ${_sw.elapsedMilliseconds}ms',
      name: name,
    );
  }
}
