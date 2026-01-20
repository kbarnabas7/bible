import 'package:flutter/material.dart';
import '../app_state.dart';

class SettingsSheet extends StatelessWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🧾 CÍM
            const Center(
              child: Text(
                "Beállítások",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 24),

            /* ---------------------------------------------------------- */
            /* 🌗 DARK / LIGHT MÓD                                        */
            /* ---------------------------------------------------------- */
            ValueListenableBuilder<ThemeMode>(
              valueListenable: AppState.themeMode,
              builder: (_, mode, __) {
                return SwitchListTile(
                  title: const Text("Sötét mód"),
                  value: mode == ThemeMode.dark,
                  onChanged: AppState.toggleTheme,
                );
              },
            ),

            const SizedBox(height: 16),

            /* ---------------------------------------------------------- */
            /* 📖 BIBLIAFORDÍTÁS                                         */
            /* ---------------------------------------------------------- */
            ValueListenableBuilder<String>(
              valueListenable: AppState.bibleTranslation,
              builder: (_, translation, __) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Biblia fordítás",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    RadioListTile<String>(
                      title: const Text("Károli Gáspár (1908)"),
                      value: 'karoli',
                      groupValue: translation,
                      onChanged: (v) {
                        if (v != null) {
                          AppState.setBibleTranslation(v);
                        }
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text("Revideált Új Fordítás"),
                      value: 'ruf',
                      groupValue: translation,
                      onChanged: (v) {
                        if (v != null) {
                          AppState.setBibleTranslation(v);
                        }
                      },
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 16),

            /* ---------------------------------------------------------- */
            /* 🔠 BETŰMÉRET                                              */
            /* ---------------------------------------------------------- */
            ValueListenableBuilder<double>(
              valueListenable: AppState.fontScale,
              builder: (_, scale, __) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Betűméret"),
                    Slider(
                      min: 0.8,
                      max: 1.6,
                      divisions: 8,
                      value: scale,
                      label: scale.toStringAsFixed(1),
                      onChanged: AppState.setFontScale,
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 16),

            /* ---------------------------------------------------------- */
            /* 🎨 KIEMELÉS SZÍNEK                                        */
            /* ---------------------------------------------------------- */
            ValueListenableBuilder<Color>(
              valueListenable: AppState.highlightColor,
              builder: (_, color, __) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Kijelölés színe",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      children: AppState.highlightOptions.map((c) {
                        final selected = c.value == color.value;
                        return GestureDetector(
                          onTap: () {
                            AppState.setHighlightColor(c);
                          },
                          child: CircleAvatar(
                            radius: selected ? 18 : 14,
                            backgroundColor: c,
                            child: selected
                                ? const Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Colors.black,
                                  )
                                : null,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 16),

            /* ---------------------------------------------------------- */
            /* ▶️ AUTOMATIKUS OLVASÁS                                    */
            /* ---------------------------------------------------------- */
            ValueListenableBuilder<bool>(
              valueListenable: AppState.autoScrollEnabled,
              builder: (_, enabled, __) {
                return SwitchListTile(
                  title: const Text("Automatikus olvasás"),
                  subtitle: const Text("Lassú, folyamatos görgetés"),
                  value: enabled,
                  onChanged: AppState.setAutoScroll,
                );
              },
            ),

            const SizedBox(height: 24),

            /* ---------------------------------------------------------- */
            /* ℹ️ NÉV + VERZIÓ                                           */
            /* ---------------------------------------------------------- */
            const Center(
              child: Text(
                "Biblia • v1.0.3\nKészítette: Kovács Barnabás",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
