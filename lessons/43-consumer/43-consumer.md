# Lesson 43: Consumer for local rebuilds

**Date:** Nov 1, 2026

When a `ConsumerWidget` calls `ref.watch` in its `build`, the whole widget redraws every time that value changes, including parts that never use it. On a small screen that's fine, but picture a heavy header, an image, or a long form sitting above one little number: all of it gets rebuilt on every tap. The `Consumer` widget fixes that by drawing a tight box around just the part that needs live data. Only what's inside its `builder` reruns when the provider changes, and the rest of the screen can stay a plain `StatelessWidget`.

`Consumer` also has a neat trick: its `child:` parameter. Anything you pass there is built once and handed back to the builder each time, so it isn't rebuilt when the count changes. In the demo below, the header card goes in as `child`, and only the count text is rebuilt on each tap. The header has a `debugPrint` in its `build`, so if you watch the debug console you'll see "StaticHeader build" once at startup and never again while you tap. The button sits in its own tiny `Consumer` that only uses `ref.read`, so it never rebuilds either. The habit to build is to use lots of small consumers rather than one giant screen that watches everything. No new packages today, since `flutter_riverpod` was added in lesson 41.

## Key points

- `Consumer(builder: (context, ref, child) { … })` redraws only that builder when a watched provider changes.
- Pass static UI as `child` so it is built once and handed back on every rebuild.
- Prefer several small consumers over one screen that watches everything.
- A `Consumer` that only calls `ref.read` does not subscribe, so it does not rebuild when the value changes.

The tip says no new packages are needed because lesson 41 added `flutter_riverpod`. Each lesson here is its own project, so this one adds it to its own `pubspec.yaml` too:

```sh
flutter pub add flutter_riverpod
```

## Code

The tip's snippet, verbatim:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(
    child: MaterialApp(home: ConsumerLesson()),
  ));
}

class Counter extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state++;
}

final counterProvider = NotifierProvider<Counter, int>(Counter.new);

// A plain StatelessWidget: the screen itself never watches anything.
class ConsumerLesson extends StatelessWidget {
  const ConsumerLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consumer')),
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
```

## On screen

The AppBar reads "Consumer". Near the top is a light card with a dashboard icon, the title "Static header", and the line "Passed as child, so it is not rebuilt". Below it, centered, is a big "Count: 0", and a purple + button sits in the bottom-right corner. Each tap on + bumps the number (1, 2, 3, ...) while the header card stays exactly as it is; in the debug console, "StaticHeader build" appears only once. The mockup shows the screen after three taps, so it reads "Count: 3".

## How it is adapted in this app

- This lesson is its own Flutter project. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` is a `ProviderScope` around a `LessonApp` from the shared `lesson_kit` package: a `MaterialApp` with the shared theme and the lesson heading as its title, whose `home` is `Lesson43Consumer`.
- `ConsumerLesson` is renamed `Lesson43Consumer`. `Counter`, `counterProvider` and `StaticHeader` keep their names, because they are the idea being taught.
- The snippet's `main` wraps `MaterialApp` in `ProviderScope`. Here the same `ProviderScope` wraps `LessonApp` in `lessonApp`, so it still sits above every widget that uses `ref`.
- The AppBar keeps `title: const Text('Consumer')` with default styling, and gets `actions: const [LessonInfoButton(lessonId: 43)]`, the button that opens these notes.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
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
```
