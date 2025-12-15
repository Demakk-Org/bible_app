import 'package:bible_app/features/bible/data/model/bible.dart';

/// Adapter interface for parsing different Bible JSON formats into a
/// unified [Bible].
abstract class BibleJsonAdapter {
  /// Quick check to determine if this adapter can parse the given JSON.
  bool canParse(Map<String, dynamic> json);

  /// Parse the given JSON into a [Bible].
  ///
  /// [id] should uniquely identify the bible source in storage.
  Bible parse({required String id, required Map<String, dynamic> json});
}
