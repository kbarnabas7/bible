import 'dart:convert';
import 'package:flutter/services.dart';
import '../app_state.dart';

class BibleService {
  /// 📖 Biblia betöltése (fordításfüggő)
  static Future<Map<String, dynamic>> loadBible() async {
    final translation = AppState.bibleTranslation.value;

    final String assetPath;
    switch (translation) {
      case 'ruf':
        assetPath = 'assets/bible/ruf.json';
        break;
      case 'karoli':
      default:
        assetPath = 'assets/bible/karoli.json';
    }

    final jsonString = await rootBundle.loadString(assetPath);
    return json.decode(jsonString) as Map<String, dynamic>;
  }

  /// 📅 Olvasási terv betöltése
  static Future<Map<String, dynamic>> loadReadingPlan() async {
    final jsonString =
        await rootBundle.loadString('assets/reading_plan.json');
    return json.decode(jsonString) as Map<String, dynamic>;
  }
}
