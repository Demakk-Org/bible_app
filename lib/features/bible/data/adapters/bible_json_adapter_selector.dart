import 'package:bible_app/features/bible/data/adapters/amharic_bible_adapter.dart';
import 'package:bible_app/features/bible/data/adapters/bible_adapters.dart';
import 'package:bible_app/features/bible/data/adapters/kjv_bible_adapter.dart';
import 'package:bible_app/features/bible/data/model/bible.dart';

/// Selector that tries all known adapters and returns the first successful
/// parse.
class BibleJsonAdapterSelector {
  static final List<BibleJsonAdapter> _adapters = <BibleJsonAdapter>[
    KjvBibleAdapter(),
    AmharicBibleAdapter(),
  ];

  /// Pick an adapter by inspecting the JSON shape and parse to [Bible].
  static Bible parse({required String id, required Map<String, dynamic> json}) {
    // 1) Prefer adapter hint from metadata if present.
    final md = json['metadata'];
    if (md is Map<String, dynamic>) {
      final hint = md['adapter']?.toString().toLowerCase();
      if (hint == 'flat') {
        return KjvBibleAdapter().parse(id: id, json: json);
      } else if (hint == 'nested') {
        return AmharicBibleAdapter().parse(id: id, json: json);
      }
    }

    // 2) Otherwise attempt auto-detection via canParse.
    for (final adapter in _adapters) {
      try {
        if (adapter.canParse(json)) {
          return adapter.parse(id: id, json: json);
        }
      } on Object {
        // If one adapter throws during canParse/parse, continue to the next.
        continue;
      }
    }

    // 3) Fallback to KJV parser as a conservative default.
    return KjvBibleAdapter().parse(id: id, json: json);
  }
}
