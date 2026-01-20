import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DebugChapterScreen extends StatefulWidget {
  const DebugChapterScreen({super.key});

  @override
  State<DebugChapterScreen> createState() => _DebugChapterScreenState();
}

class _DebugChapterScreenState extends State<DebugChapterScreen> {
  List<dynamic> verses = [];

  @override
  void initState() {
    super.initState();
    loadChapter();
  }

  Future<void> loadChapter() async {
    final jsonString = await rootBundle.loadString('assets/bible.json');
    final Map<String, dynamic> bible = json.decode(jsonString);

    final chapterKey = 'MAT_1';

    if (!bible.containsKey(chapterKey)) {
      debugPrint('❌ Nincs ilyen kulcs: $chapterKey');
      return;
    }

    setState(() {
      verses = bible[chapterKey];
    });

    debugPrint('✅ Betöltve: ${verses.length} vers');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debug – Máté 1')),
      body: verses.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: verses.length,
              itemBuilder: (context, index) {
                final v = verses[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${v['v']}. ${v['t']}',
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              },
            ),
    );
  }
}
