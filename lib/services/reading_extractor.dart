import 'package:flutter/foundation.dart';
List<Map<String, dynamic>> extractVerses({
  required Map<String, dynamic> bible,
  required String book,
  required int chapter,
  required int from,
  int? to,
}) {
  final key = "${book}_$chapter";

  if (!bible.containsKey(key)) {
    debugPrint("❌ Hiányzó biblia kulcs: $key");
    return [];
  }

  final List rawVerses = bible[key];
  final int end = to ?? rawVerses.length;

  final result = <Map<String, dynamic>>[];

  for (final v in rawVerses) {
    final verseNum = v['v'];
    if (verseNum < from || verseNum > end) continue;

    // ✅ ÚJ FORMÁTUM: parts
    if (v['parts'] is List) {
      result.add({
        'v': verseNum,
        'parts': List<Map<String, dynamic>>.from(
          v['parts'].map((p) => {
                't': p['t'] ?? '',
                'jesus': p['jesus'] == true,
              }),
        ),
      });
    }
    // 🔄 RÉGI FORMÁTUM: t
    else if (v['t'] != null) {
      result.add({
        'v': verseNum,
        'parts': [
          {
            't': v['t'],
            'jesus': false,
          }
        ],
      });
    }
  }

  return result;
}
