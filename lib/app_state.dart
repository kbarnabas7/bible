import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState {
  /* -------------------------------------------------- */
  /* 🌗 THEME                                           */
  /* -------------------------------------------------- */

  static final ValueNotifier<ThemeMode> themeMode =
      ValueNotifier(ThemeMode.light);

  /* -------------------------------------------------- */
  /* 🔤 FONT SCALE                                      */
  /* -------------------------------------------------- */

  static final ValueNotifier<double> fontScale =
      ValueNotifier(1.0);

  /* -------------------------------------------------- */
  /* 🎨 HIGHLIGHT COLOR                                 */
  /* -------------------------------------------------- */

  static final ValueNotifier<Color> highlightColor =
      ValueNotifier(Colors.yellowAccent);

  /// 👉 választható színek
  static const List<Color> highlightOptions = [
    Colors.yellowAccent,
    Colors.lightGreenAccent,
    Colors.pinkAccent,
    Colors.lightBlueAccent,
    Colors.orangeAccent,
    Colors.purpleAccent,
  ];

  /* -------------------------------------------------- */
  /* 📖 BIBLE TRANSLATION                                */
  /* -------------------------------------------------- */

  /// 'karoli', 'ruf'
  static final ValueNotifier<String> bibleTranslation =
      ValueNotifier('karoli');

  /* -------------------------------------------------- */
  /* ▶️ AUTO SCROLL                                     */
  /* -------------------------------------------------- */

  static final ValueNotifier<bool> autoScrollEnabled =
      ValueNotifier(false);

  /* -------------------------------------------------- */
  /* 🔁 LOAD FROM PREFS                                 */
  /* -------------------------------------------------- */

  static Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    themeMode.value =
        (prefs.getBool('darkMode') ?? false)
            ? ThemeMode.dark
            : ThemeMode.light;

    fontScale.value = prefs.getDouble('fontScale') ?? 1.0;

    highlightColor.value = Color(
      prefs.getInt('highlightColor')
          ?? Colors.yellowAccent.value,
    );

    bibleTranslation.value =
        prefs.getString('bibleTranslation') ?? 'karoli';

    autoScrollEnabled.value =
        prefs.getBool('autoScroll') ?? false;
  }

  /* -------------------------------------------------- */
  /* 🌗 THEME SET                                       */
  /* -------------------------------------------------- */

  static Future<void> toggleTheme(bool isDark) async {
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', isDark);
  }

  /* -------------------------------------------------- */
  /* 🔤 FONT SCALE SET                                  */
  /* -------------------------------------------------- */

  static Future<void> setFontScale(double scale) async {
    fontScale.value = scale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontScale', scale);
  }

  /* -------------------------------------------------- */
  /* 🎨 HIGHLIGHT COLOR SET                              */
  /* -------------------------------------------------- */

  static Future<void> setHighlightColor(Color color) async {
    highlightColor.value = color;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('highlightColor', color.value);
  }

  /* -------------------------------------------------- */
  /* 📖 BIBLE TRANSLATION SET                            */
  /* -------------------------------------------------- */

  static Future<void> setBibleTranslation(String key) async {
    bibleTranslation.value = key;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('bibleTranslation', key);
  }

  /* -------------------------------------------------- */
  /* ▶️ AUTO SCROLL SET                                 */
  /* -------------------------------------------------- */

  static Future<void> setAutoScroll(bool enabled) async {
    autoScrollEnabled.value = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('autoScroll', enabled);
  }
}
