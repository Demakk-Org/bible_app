import 'package:hive_flutter/hive_flutter.dart';
import 'package:bible_app/common/utils/logger.dart';

// UpsertStats is a data class that tracks the results of
// upsert(Update or Insert) operations in a Hive database.

class UpsertStats {
  const UpsertStats({
    required this.inserts,
    required this.updates,
    required this.skips,
  });

  final int inserts;
  final int updates;
  final int skips;

  @override
  String toString() =>
      'UpsertStats('
      'inserts=$inserts, '
      'updates=$updates, '
      'skips=$skips)';
}

Future<UpsertStats> upsertById<T>({
  required Box<T> box,
  required Iterable<T> incoming,
  required String Function(T) idOf,
  T Function(T current, T incoming)? merge,
  String logName = 'HiveCacheUtils:upsertById',
}) async {
  if (incoming.isEmpty) {
    AppLogger.debug('[upsertById] No incoming items', name: logName);
    return const UpsertStats(inserts: 0, updates: 0, skips: 0);
  }

  final incomingById = <String, T>{};
  for (final item in incoming) {
    incomingById[idOf(item)] = item;
  }

  final indexById = <String, int>{};
  for (var i = 0; i < box.length; i++) {
    final item = box.getAt(i);
    if (item != null) indexById[idOf(item)] = i;
  }

  var inserts = 0;
  var updates = 0;
  var skips = 0;

  for (final entry in incomingById.entries) {
    final id = entry.key;
    final incomingItem = entry.value;
    final idx = indexById[id];

    if (idx != null) {
      final current = box.getAt(idx) as T;
      final merged = merge != null
          ? merge(current, incomingItem)
          : incomingItem;
      if (current == merged) {
        skips++;
        continue;
      }
      await box.putAt(idx, merged);
      updates++;
    } else {
      await box.add(incomingItem);
      inserts++;
    }
  }

  AppLogger.debug(
    '[upsertById] done. '
    'inserts=$inserts, '
    'updates=$updates, '
    'skips=$skips, '
    'total=${box.length}',
    name: logName,
  );

  return UpsertStats(inserts: inserts, updates: updates, skips: skips);
}
