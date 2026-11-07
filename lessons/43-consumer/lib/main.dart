import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lesson_kit/lesson_kit.dart';

/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 43,
  title: 'Consumer for local rebuilds',
  notesAsset: '43-consumer.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
///
/// ProviderScope stores every provider's state. It must sit above any
/// widget that uses ref.
const lessonApp = ProviderScope(
  child: LessonApp(lesson: lesson, home: Lesson43Consumer()),
);

void main() => runApp(lessonApp);

class Counter extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state++;
}

final counterProvider = NotifierProvider<Counter, int>(Counter.new);

// A plain StatelessWidget: the screen itself never watches anything.
class Lesson43Consumer extends StatelessWidget {
  const Lesson43Consumer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consumer'),
        actions: const [LessonInfoButton(lessonId: 43)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Consumer(
          // child is built once and reused on every rebuild below.
          child: const StaticHeader(),
          builder: (context, ref, child) {
            // Only this builder reruns when the count changes.
            final count = ref.watch(counterProvider);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                child!,
                const SizedBox(height: 48),
                Text(
                  'Count: $count',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: Consumer(
        // No watch here, so this button never rebuilds.
        builder: (context, ref, _) => FloatingActionButton(
          onPressed: () => ref.read(counterProvider.notifier).increment(),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class StaticHeader extends StatelessWidget {
  const StaticHeader({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('StaticHeader build'); // prints once, not on every tap
    return const Card(
      child: ListTile(
        leading: Icon(Icons.dashboard_outlined),
        title: Text('Static header'),
        subtitle: Text('Passed as child, so it is not rebuilt'),
      ),
    );
  }
}
