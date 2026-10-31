# Lesson 41: From setState to Riverpod

**Date:** Oct 30, 2026

This is lesson 1 of the Riverpod series: from `setState` to `ProviderScope`.

Today starts a new track: Riverpod, a popular way to manage state. Back in the early lessons, the counter kept its number inside the widget and called `setState` to redraw. That works, but the number is stuck in that one widget, so no other screen can see or change it. Riverpod moves the state out into a "provider", a small object that lives outside your widgets. Widgets ask the provider for the value, and Riverpod redraws them whenever it changes.

Three pieces make that happen. A `Notifier` holds the value and the methods that change it (here, `increment`), and a `NotifierProvider` makes it available to the app. A `ConsumerWidget` is like a `StatelessWidget`, except its `build` also gets a `WidgetRef ref`, which is how it talks to providers. And `ProviderScope` has to wrap the app (or at least everything above any consumer), because that's where Riverpod actually stores the values. The rule of thumb: use `ref.watch` inside `build` so the screen redraws on changes, and `ref.read` inside callbacks like `onPressed`, where you only need to act once. This is the first lesson with a package, so add it first with `flutter pub add flutter_riverpod`.

## Key points

- `ProviderScope` sits at the root of the lesson, above every widget that uses `ref`.
- A `Notifier` holds the state and its methods; a `NotifierProvider` makes it available.
- A `ConsumerWidget`'s `build` gets a `WidgetRef ref` to talk to providers.
- `ref.watch` in `build` (redraw on change), `ref.read` in callbacks like `onPressed`.

This is the first lesson with a third-party package. Add it in the lesson folder with:

```sh
flutter pub add flutter_riverpod
```

## Code

The tip's snippet, verbatim:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  // ProviderScope stores every provider's state. It must sit above any
  // widget that uses ref.
  runApp(const ProviderScope(
    child: MaterialApp(home: RiverpodCounterLesson()),
  ));
}

// The state lives here, outside any widget.
class Counter extends Notifier<int> {
  @override
  int build() => 0; // starting value

  void increment() => state++;
}

final counterProvider = NotifierProvider<Counter, int>(Counter.new);

class RiverpodCounterLesson extends ConsumerWidget {
  const RiverpodCounterLesson({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watch in build: this widget redraws whenever the count changes.
    final count = ref.watch(counterProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Riverpod counter')),
      body: Center(
        child: Text(
          '$count',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // read in callbacks: grab the notifier once and call its method.
        onPressed: () => ref.read(counterProvider.notifier).increment(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

## On screen

The AppBar reads "Riverpod counter". A big "0" sits in the middle of an otherwise empty screen, and a light-purple rounded-square button with a plus sign floats in the bottom-right corner. Each tap on the plus button raises the number by one (1, 2, 3, ...). It looks just like the old setState counter, but now the number lives in `counterProvider`, so any other widget under the same `ProviderScope` could watch it too.

## How it is adapted in this app

- This lesson is its own Flutter project. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` is a `ProviderScope` around a `LessonApp` from the shared `lesson_kit` package: a `MaterialApp` with the shared theme and the lesson heading as its title, whose `home` is `Lesson41RiverpodCounter`.
- `RiverpodCounterLesson` is renamed `Lesson41RiverpodCounter`. `Counter` and `counterProvider` keep their names, because they are the idea being taught.
- The snippet's `main` wraps `MaterialApp` in `ProviderScope`. Here the same `ProviderScope` wraps `LessonApp` in `lessonApp`, so it still sits above every widget that uses `ref`.
- The AppBar keeps `title: const Text('Riverpod counter')` with default styling, and gets `actions: const [LessonInfoButton(lessonId: 41)]`, the button that opens these notes.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
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
```
