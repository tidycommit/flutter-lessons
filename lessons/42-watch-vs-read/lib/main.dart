import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lesson_kit/lesson_kit.dart';

/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 42,
  title: 'watch vs read',
  notesAsset: '42-watch-vs-read.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
///
/// ProviderScope stores every provider's state. It must sit above any
/// widget that uses ref.
const lessonApp = ProviderScope(
  child: LessonApp(lesson: lesson, home: Lesson42WatchVsRead()),
);

void main() => runApp(lessonApp);

class Counter extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state++;
}

final counterProvider = NotifierProvider<Counter, int>(Counter.new);

class Lesson42WatchVsRead extends ConsumerWidget {
  const Lesson42WatchVsRead({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watch in build: this line redraws every time the count changes.
    final count = ref.watch(counterProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('watch vs read'),
        actions: const [LessonInfoButton(lessonId: 42)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Watched value: $count',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            const ReadOnceLabel(),
            const SizedBox(height: 32),
            FilledButton.icon(
              // read in a callback: grab the notifier once and call it.
              onPressed: () => ref.read(counterProvider.notifier).increment(),
              icon: const Icon(Icons.add),
              label: const Text('Increment'),
            ),
          ],
        ),
      ),
    );
  }
}

// A stateful child that only looks at the provider when you tap.
class ReadOnceLabel extends ConsumerStatefulWidget {
  const ReadOnceLabel({super.key});

  @override
  ConsumerState<ReadOnceLabel> createState() => _ReadOnceLabelState();
}

class _ReadOnceLabelState extends ConsumerState<ReadOnceLabel> {
  int? _snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Read snapshot: ${_snapshot ?? '-'}',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () {
            // read is a one-shot lookup: no subscription, so this
            // number goes stale as soon as the count changes again.
            setState(() => _snapshot = ref.read(counterProvider));
          },
          child: const Text('Read once into a local label'),
        ),
      ],
    );
  }
}
