# Lesson 63: Test harness mindset

**Date:** Nov 21, 2026

A test harness is a tiny app that hosts one feature with fakes, with no full production shell around it. You can develop, screenshot and test that feature alone, without logging in or navigating through ten screens first. It is the same idea as ProviderScope(overrides: ...) from lesson 45: the feature asks for a repository and flags, and the harness decides which fake ones to hand over.

The harness below documents its three bindings (fake repo, fake flags, initial route) in a small card, then launches a simple notes list. Two buttons swap the fake data set between "Few notes" and "Many notes"; the list rebuilds because the data set is a NotifierProvider. Needs flutter pub add flutter_riverpod.

## Key points

- A test harness is a tiny app that hosts one feature with fakes, with no full production shell around it.
- The feature asks for a repository and flags; the harness decides which fakes to hand over, the same idea as `ProviderScope(overrides: ...)` from lesson 45.
- Buttons swap the fake data set (`Few notes` / `Many notes`) through a `NotifierProvider`, and the list rebuilds.

This lesson needs `flutter_riverpod`. Each lesson is its own project, so if it is not already in this folder's `pubspec.yaml`, add it:

```sh
flutter pub add flutter_riverpod
```

## Code

The tip's snippet, verbatim:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() => runApp(const ProviderScope(child: HarnessApp()));

const List<String> fewNotes = ['Buy milk', 'Call mom'];
const List<String> manyNotes = [
  'Buy milk', 'Call mom', 'Read chapter 3', 'Pay rent',
  'Water plants', 'Plan trip',
];

// Binding 1: the fake repo (a data set the harness can swap).
class DataSetNotifier extends Notifier<List<String>> {
  @override
  List<String> build() => fewNotes;

  void useFew() => state = fewNotes;
  void useMany() => state = manyNotes;
}

final dataSetProvider =
    NotifierProvider<DataSetNotifier, List<String>>(DataSetNotifier.new);

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
      appBar: AppBar(title: const Text('Test harness')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Card(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text('Bindings\n'
                    '- repo: fake in-memory notes\n'
                    '- flags: showCount = on\n'
                    '- initial route: /notes'),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                FilledButton(
                  onPressed: () =>
                      ref.read(dataSetProvider.notifier).useFew(),
                  child: const Text('Few notes'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () =>
                      ref.read(dataSetProvider.notifier).useMany(),
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
```

## On screen

An app bar titled "Test harness". Below it a card listing the three bindings (fake in-memory notes, showCount flag on, initial route /notes), then two buttons, "Few notes" and "Many notes". Under them the text "2 notes" and a list with "Buy milk" and "Call mom". Tapping "Many notes" changes the count to "6 notes" and shows six rows; tapping "Few notes" goes back to two.

## How it is adapted in this app

- This lesson is its own Flutter project. The snippet's `MaterialApp` with the `/notes` named route stays, wrapped in `ProviderScope` and `LessonScope` so providers work and the info button can find these notes, the same pattern as lesson 24. `main()` is `void main() => runApp(lessonApp);`.
- `HarnessScreen`'s AppBar keeps `title: const Text('Test harness')` and gets `actions: const [LessonInfoButton(lessonId: 63)]`. `fewNotes`, `manyNotes`, `DataSetNotifier`, `showCountProvider`, `HarnessApp`, and `HarnessScreen` keep the snippet's names and behavior.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
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
```
