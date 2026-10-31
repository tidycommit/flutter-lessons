# Lesson 42: watch vs read

**Date:** Oct 31, 2026

This is lesson 2 of the Riverpod series: `ref.watch` vs `ref.read`.

Yesterday's counter used two different ways to reach a provider, and today is about why. `ref.watch(provider)` subscribes: it hands you the current value and tells Riverpod "redraw me whenever this changes." `ref.read(provider)` is a one-time lookup: it gives you the value right now and then forgets about you. So if you use `read` inside `build`, the screen shows whatever the value was the first time and never updates again. That's the classic bug this lesson helps you spot.

The rule of thumb is simple. Use `watch` in `build`, where the screen should always reflect the latest value. Use `read` in callbacks like `onPressed`, where you just need to do something once, and use `ref.read(provider.notifier)` when you want to call a method like `increment`. Watching the notifier object itself is rarely useful; watch the state. The demo below makes the difference visible: one line watches the count and stays live, while a second line grabs a snapshot with `read` and keeps showing that old number until you tap again. No new packages today, since `flutter_riverpod` was added in lesson 41.

## Key points

- `ref.watch` subscribes: use it in `build`, so the screen always shows the latest value.
- `ref.read` is a one-shot lookup: use it in callbacks such as `onPressed`.
- `ref.read(provider.notifier)` gets the notifier so you can call a method like `increment`.
- Watching the notifier object itself is rarely what you want; watch the state.

Every lesson is its own project, so this one adds the package to its own `pubspec.yaml` too, with the same command as lesson 41:

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
    child: MaterialApp(home: WatchVsReadLesson()),
  ));
}

class Counter extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state++;
}

final counterProvider = NotifierProvider<Counter, int>(Counter.new);

class WatchVsReadLesson extends ConsumerWidget {
  const WatchVsReadLesson({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watch in build: this line redraws every time the count changes.
    final count = ref.watch(counterProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('watch vs read')),
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
```

## On screen

The AppBar reads "watch vs read". Near the top-left, a large line says "Watched value: 0", and below it "Read snapshot: -", followed by an outlined button labeled "Read once into a local label". Further down is a filled purple "+ Increment" button. Each tap on Increment bumps the watched line right away (1, 2, 3, ...), while the snapshot line doesn't move. Tap "Read once into a local label" and the snapshot jumps to the current count, then sits frozen there as you keep incrementing. In the mockup, Increment was tapped once, the snapshot was read (1), and then Increment was tapped twice more, so it shows "Watched value: 3" and "Read snapshot: 1".

## How it is adapted in this app

- This lesson is its own Flutter project. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` is a `ProviderScope` around a `LessonApp` from the shared `lesson_kit` package: a `MaterialApp` with the shared theme and the lesson heading as its title, whose `home` is `Lesson42WatchVsRead`.
- `WatchVsReadLesson` is renamed `Lesson42WatchVsRead`. `Counter`, `counterProvider` and `ReadOnceLabel` keep their names, because they are the idea being taught.
- The snippet's `main` wraps `MaterialApp` in `ProviderScope`. Here the same `ProviderScope` wraps `LessonApp` in `lessonApp`, so it still sits above every widget that uses `ref`.
- The tip says no new packages are needed because lesson 41 added `flutter_riverpod`; since each lesson here is a standalone project, this one adds it to its own `pubspec.yaml`.
- The AppBar keeps `title: const Text('watch vs read')` with default styling, and gets `actions: const [LessonInfoButton(lessonId: 42)]`, the button that opens these notes.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
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
```
