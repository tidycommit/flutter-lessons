import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lesson_kit/lesson_kit.dart';

/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 63,
  title: 'Test harness mindset',
  notesAsset: '63-test-harness.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
///
/// The snippet's own [MaterialApp] keeps the `/notes` named route. A
/// [LessonScope] around it lets the info button find the notes.
const lessonApp = ProviderScope(
  child: LessonScope(lesson: lesson, child: HarnessApp()),
);

void main() => runApp(lessonApp);

const List<String> fewNotes = ['Buy milk', 'Call mom'];
const List<String> manyNotes = [
  'Buy milk',
  'Call mom',
  'Read chapter 3',
  'Pay rent',
  'Water plants',
  'Plan trip',
];

// Binding 1: the fake repo (a data set the harness can swap).
class DataSetNotifier extends Notifier<List<String>> {
  @override
  List<String> build() => fewNotes;

  void useFew() => state = fewNotes;
  void useMany() => state = manyNotes;
}

final dataSetProvider = NotifierProvider<DataSetNotifier, List<String>>(
  DataSetNotifier.new,
);

// Binding 2: the fake flags.
final showCountProvider = Provider<bool>((ref) => true);

class HarnessApp extends StatelessWidget {
  const HarnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Binding 3: the initial route.
    return MaterialApp(
      initialRoute: '/notes',
      routes: {'/notes': (_) => const HarnessScreen()},
    );
  }
}

class HarnessScreen extends ConsumerWidget {
  const HarnessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(dataSetProvider);
    final showCount = ref.watch(showCountProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test harness'),
        actions: const [LessonInfoButton(lessonId: 63)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Card(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'Bindings\n'
                  '- repo: fake in-memory notes\n'
                  '- flags: showCount = on\n'
                  '- initial route: /notes',
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                FilledButton(
                  onPressed: () => ref.read(dataSetProvider.notifier).useFew(),
                  child: const Text('Few notes'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () => ref.read(dataSetProvider.notifier).useMany(),
                  child: const Text('Many notes'),
                ),
              ],
            ),
            if (showCount)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text('${notes.length} notes'),
              ),
            Expanded(
              child: ListView(
                children: [for (final n in notes) ListTile(title: Text(n))],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
