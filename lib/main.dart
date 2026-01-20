import 'package:flutter/material.dart';
import 'app_state.dart';
import 'theme/app_theme.dart';
import 'screens/today_reading_screen.dart';

Future<void> main() async {
  /// ⏳ Flutter binding
  WidgetsFlutterBinding.ensureInitialized();

  /// ✅ BETÖLTJÜK A MENTETT BEÁLLÍTÁSOKAT
  await AppState.loadFromPrefs();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppState.themeMode,
      builder: (_, themeMode, __) {
        return ValueListenableBuilder<double>(
          valueListenable: AppState.fontScale,
          builder: (_, scale, __) {
            return ValueListenableBuilder<String>(
              /// 📖 FORDÍTÁS FIGYELÉSE
              valueListenable: AppState.bibleTranslation,
              builder: (_, __, ___) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Biblia',
                  theme: AppTheme.light,
                  darkTheme: AppTheme.dark,
                  themeMode: themeMode,

                  /// 🔤 globális betűskála (igeversekre is)
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        textScaleFactor: scale,
                      ),
                      child: child!,
                    );
                  },

                  home: const TodayReadingScreen(),
                );
              },
            );
          },
        );
      },
    );
  }
}
