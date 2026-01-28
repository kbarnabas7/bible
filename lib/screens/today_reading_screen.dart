import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/bible_service.dart';
import '../services/today_service.dart';
import '../services/reading_extractor.dart';
import '../widgets/settings_sheet.dart';
import '../app_state.dart';

/// 📖 Könyvnevek
const Map<String, String> bookNames = {
  'MAT': 'Máté evangéliuma',
  'MRK': 'Márk evangéliuma',
  'LUK': 'Lukács evangéliuma',
  'JHN': 'János evangéliuma',
};

class TodayReadingScreen extends StatefulWidget {
  const TodayReadingScreen({super.key});

  @override
  State<TodayReadingScreen> createState() => _TodayReadingScreenState();
}

class _TodayReadingScreenState extends State<TodayReadingScreen> {
  late Future<void> _loader;

  Map<String, dynamic> bible = {};
  Map<String, dynamic> plan = {};

  DateTime currentDay = DateTime.now();

  /// 🔑 kijelölt versek → verseKey : colorValue
  Map<String, int> highlightedVerses = {};

  /// 📝 napi jegyzet
  final TextEditingController _noteController =
      TextEditingController();
  final FocusNode _noteFocusNode = FocusNode();

  final ScrollController _scrollController =
      ScrollController();
  Timer? _autoScrollTimer;

  /* ------------------------------------------------------------ */
  /* 🔁 INIT / DISPOSE                                            */
  /* ------------------------------------------------------------ */

  @override
  void initState() {
    super.initState();
    _loader = _loadData();

    AppState.bibleTranslation.addListener(() {
      setState(() {
        _loader = _loadData();
      });
    });

    AppState.autoScrollEnabled
        .addListener(_handleAutoScroll);
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _scrollController.dispose();
    _noteController.dispose();
    _noteFocusNode.dispose();
    super.dispose();
  }

  /* ------------------------------------------------------------ */
  /* 📦 ADAT + KIEMELÉSEK + JEGYZET                               */
  /* ------------------------------------------------------------ */

  Future<void> _loadData() async {
    bible = await BibleService.loadBible();
    plan = await BibleService.loadReadingPlan();

    highlightedVerses =
        await AppState.loadHighlights(currentDay);

    _noteController.text =
        await AppState.loadNote(currentDay);
  }

  /* ------------------------------------------------------------ */
  /* ▶️ AUTO SCROLL                                               */
  /* ------------------------------------------------------------ */

  void _handleAutoScroll() {
    if (AppState.autoScrollEnabled.value) {
      _startAutoScroll();
    } else {
      _stopAutoScroll();
    }
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(
      const Duration(milliseconds: 40),
      (_) {
        if (!_scrollController.hasClients) return;

        final max =
            _scrollController.position.maxScrollExtent;
        final next =
            _scrollController.offset + 0.6;

        if (next >= max) {
          _stopAutoScroll();
        } else {
          _scrollController.jumpTo(next);
        }
      },
    );
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
    AppState.setAutoScroll(false);
  }

  /* ------------------------------------------------------------ */
  /* 📅 NAP VÁLTÁS                                                */
  /* ------------------------------------------------------------ */

  void _previousDay() {
    setState(() {
      currentDay =
          currentDay.subtract(const Duration(days: 1));
      _loader = _loadData();
    });
  }

  void _nextDay() {
    setState(() {
      currentDay =
          currentDay.add(const Duration(days: 1));
      _loader = _loadData();
    });
  }

  String _formatDate(DateTime d) =>
      "${d.year}.${d.month.toString().padLeft(2, '0')}.${d.day.toString().padLeft(2, '0')}";

  int _getLastVerse(String book, int chapter) {
    final key = "${book}_$chapter";
    if (bible[key] is List &&
        (bible[key] as List).isNotEmpty) {
      return (bible[key] as List).last['v']
          as int;
    }
    return 0;
  }

  /* ------------------------------------------------------------ */
  /* 🖥 UI                                                        */
  /* ------------------------------------------------------------ */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: _previousDay,
        ),
        title: Text(
          _formatDate(currentDay),
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _nextDay,
          ),
          ValueListenableBuilder<bool>(
            valueListenable:
                AppState.autoScrollEnabled,
            builder: (_, enabled, __) {
              return IconButton(
                icon: Icon(enabled
                    ? Icons.pause_circle
                    : Icons.play_circle),
                onPressed: () {
                  AppState.setAutoScroll(!enabled);
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                showDragHandle: true,
                isScrollControlled: true,
                builder: (_) =>
                    const SettingsSheet(),
              );
            },
          ),
        ],
      ),

      body: FutureBuilder<void>(
        future: _loader,
        builder: (context, snapshot) {
          if (snapshot.connectionState !=
              ConnectionState.done) {
            return const Center(
                child: CircularProgressIndicator());
          }

          final todayPlan =
              TodayService.getTodayPlan(
                  plan, currentDay);

          final List readings =
              (todayPlan != null &&
                      todayPlan['readings']
                          is List)
                  ? todayPlan['readings']
                  : [];

          final String summaryText =
              (todayPlan != null &&
                      todayPlan['summary']
                          is String &&
                      (todayPlan['summary'] as String)
                          .trim()
                          .isNotEmpty)
                  ? todayPlan['summary']
                  : "Nincs összefoglaló a mai naphoz.";

          return ListView(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            children: [
              /// 🏷 SUMMARY
              Container(
                margin:
                    const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                              .brightness ==
                          Brightness.dark
                      ? Colors.white10
                      : Colors.black
                          .withOpacity(0.05),
                  borderRadius:
                      BorderRadius.circular(14),
                ),
                child: Text(
                  summaryText,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
              ),

              ...readings.expand<Widget>((r) {
                final bookCode = r['book'];
                final bookName =
                    bookNames[bookCode] ??
                        bookCode;
                final from = r['from'];
                final to =
                    r['to'] ??
                        _getLastVerse(
                            bookCode, r['chapter']);

                final verses = extractVerses(
                  bible: bible,
                  book: bookCode,
                  chapter: r['chapter'],
                  from: from,
                  to: to,
                );

                return [
                  Text(
                    "$bookName ${r['chapter']}:$from–$to",
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),

                  ...verses.map((v) {
                    final verseKey =
                        "${bookCode}_${r['chapter']}_${v['v']}";
                    final colorValue =
                        highlightedVerses[verseKey];

                    final fullText = [
                      "${v['v']}",
                      ...(v['parts'] ?? []).map(
                          (p) =>
                              (p['t'] ?? '').trim()),
                    ].join(' ');

                    return InkWell(
                      onTap: () async {
                        setState(() {
                          if (highlightedVerses
                              .containsKey(verseKey)) {
                            highlightedVerses
                                .remove(verseKey);
                          } else {
                            highlightedVerses[
                                    verseKey] =
                                AppState.highlightColor
                                    .value
                                    .value;
                          }
                        });
                        await AppState.saveHighlights(
                            currentDay,
                            highlightedVerses);
                      },
                      onLongPress: () {
                        Clipboard.setData(
                            ClipboardData(
                                text: fullText));
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                                "Igevers kimásolva"),
                            duration:
                                Duration(seconds: 1),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                            bottom: 6),
                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(8),
                          color: colorValue != null
                              ? Color(colorValue)
                                  .withOpacity(0.25)
                              : Colors.transparent,
                        ),
                        child: Text(
                          fullText,
                          textAlign:
                              TextAlign.justify,
                          style: const TextStyle(
                              height: 1.4),
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 16),
                ];
              }),

              /// 📝 JEGYZET
              /// 📝 JEGYZET
              const SizedBox(height: 12),
              const Text(
                "Jegyzet",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),

              TextField(
                controller: _noteController,
                focusNode: _noteFocusNode,
                maxLines: null,
                minLines: 3,
                decoration: InputDecoration(
                  hintText:
                      "Írd le amit ma Isten mutatott neked!",
                  filled: true,
                  fillColor: Theme.of(context)
                              .brightness ==
                          Brightness.dark
                      ? Colors.white10
                      : Colors.black
                          .withOpacity(0.04),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (text) {
                  AppState.saveNote(currentDay, text);
                },
              ),

              const SizedBox(height: 10),

              /// ✅ KÉSZ GOMB – EZ AZ ÚJ RÉSZ
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text("Kész"),
                  onPressed: () {
                    _noteFocusNode.unfocus();
                  },
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "⚠️ Megjegyzés: a jegyzetek és kiemelések helyben kerülnek mentésre. "
                "Böngésző adatok törlése esetén ezek elveszhetnek.",
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey),
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}
