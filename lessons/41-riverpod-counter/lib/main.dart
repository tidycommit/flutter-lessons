import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lesson_kit/lesson_kit.dart';

/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 41,
  title: 'From setState to Riverpod',
  notesAsset: '41-riverpod-counter.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
///
/// ProviderScope stores every provider's state. It must sit above any
/// widget that uses ref.
const lessonApp = ProviderScope(
  child: LessonApp(lesson: lesson, home: Lesson41RiverpodCounter()),
);

void main() => runApp(lessonApp);

// The state lives here, outside any widget.
class Counter extends Notifier<int> {
  @override
  int build() => 0; // starting value

  void increment() => state++;
}

final counterProvider = NotifierProvider<Counter, int>(Counter.new);

class Lesson41RiverpodCounter extends ConsumerWidget {
  const Lesson41RiverpodCounter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watch in build: this widget redraws whenever the count changes.
    final count = ref.watch(counterProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod counter'),
        actions: const [LessonInfoButton(lessonId: 41)],
      ),
      body: Center(
        child: Text('$count', style: Theme.of(context).textTheme.displayMedium),
      ),
      floatingActionButton: FloatingActionButton(
        // read in callbacks: grab the notifier once and call its method.
        onPressed: () => ref.read(counterProvider.notifier).increment(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
