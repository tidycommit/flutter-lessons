# Lesson 44: AsyncNotifier loading and error

**Date:** Nov 2, 2026

Real apps wait on things: a server, a database, a file. While you wait, the data isn't there yet, and sometimes it never shows up because something failed. Riverpod's `AsyncNotifier` is built for this. Its `build()` is `async` and returns a `Future`, and Riverpod wraps the result in an `AsyncValue`, which is always in exactly one of three states: loading, error, or data. In your widget you call `.when(...)` on it and give one builder for each state, so the compiler won't let you forget the spinner or the error message. The rule worth keeping is simple: never show a screen that only handles the happy path.

Today's demo fakes a network call with `Future.delayed`, so there's no real server yet. It waits one second and returns three names, unless the "Force error" switch is on, in which case it throws. To try again you call `ref.invalidate(provider)`, which throws away the old result and runs `build()` fresh; both the Retry button and the refresh icon in the AppBar do exactly that. Passing `skipLoadingOnRefresh: false` makes the spinner show on every retry instead of leaving the old result up while it reloads. One more detail: newer Riverpod versions automatically retry a provider that failed, so the `ProviderScope` here turns that off with `retry:` to keep the error on screen where you can see it. No new packages today, since `flutter_riverpod` was added in lesson 41.

## Key points

- `AsyncValue` is loading, error, or data. `when(...)` needs a builder for each.
- `skipLoadingOnRefresh: false` shows the spinner again on retry instead of leaving the old list up.
- `ref.invalidate(provider)` runs `build()` again. The AppBar reload icon and the Retry button both call it.
- `ProviderScope(retry: (retryCount, error) => null)` turns off automatic retry so the error stays on screen.

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
  runApp(ProviderScope(
    // Turn off automatic retries so the error state stays visible.
    retry: (retryCount, error) => null,
    child: const MaterialApp(home: AsyncNotifierLesson()),
  ));
}

// A simple on/off switch that the fake request checks.
class ForceError extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool value) => state = value;
}

final forceErrorProvider = NotifierProvider<ForceError, bool>(ForceError.new);

class FakeItems extends AsyncNotifier<List<String>> {
  @override
  Future<List<String>> build() async {
    // Pretend this is a network call.
    await Future<void>.delayed(const Duration(seconds: 1));
    if (ref.read(forceErrorProvider)) {
      throw Exception('Network down');
    }
    return ['Alpha', 'Bravo', 'Charlie'];
  }
}

final fakeItemsProvider =
    AsyncNotifierProvider<FakeItems, List<String>>(FakeItems.new);

class AsyncNotifierLesson extends ConsumerWidget {
  const AsyncNotifierLesson({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(fakeItemsProvider);
    final forceError = ref.watch(forceErrorProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AsyncNotifier'),
        actions: [
          IconButton(
            tooltip: 'Reload',
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(fakeItemsProvider),
          ),
        ],
      ),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text('Force error'),
            subtitle: const Text('Applies on the next load'),
            value: forceError,
            onChanged: (value) =>
                ref.read(forceErrorProvider.notifier).set(value),
          ),
          const Divider(height: 1),
          Expanded(
            // One builder per state: nothing gets ignored.
            child: items.when(
              skipLoadingOnRefresh: false,
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_off, size: 48, color: Colors.red),
                    const SizedBox(height: 12),
                    Text('Something went wrong:\n$error',
                        textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => ref.invalidate(fakeItemsProvider),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (list) => ListView(
                children: [
                  for (final name in list)
                    ListTile(
                      leading: const Icon(Icons.label_outline),
                      title: Text(name),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

## On screen

The AppBar reads "AsyncNotifier" with a circular refresh icon on the right. Under it is a "Force error" row with the subtitle "Applies on the next load" and a switch that starts off. For the first second, the area below shows a spinning circle; then it fills in with a list of three rows, "Alpha", "Bravo", and "Charlie", each with a tag icon. If you turn the switch on and tap the refresh icon, the spinner comes back for a second and then you see a red cloud-off icon, the text "Something went wrong: Exception: Network down", and a purple "Retry" button. Turn the switch off and tap Retry, and after the spinner the three names return. The mockup shows the normal loaded state with the switch off.

## How it is adapted in this app

- This lesson is its own Flutter project. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` is a `ProviderScope` around a `LessonApp` from the shared `lesson_kit` package, whose `home` is `Lesson44AsyncNotifier`.
- The `ProviderScope` keeps the snippet's `retry: (retryCount, error) => null`, so a failed load is not retried on its own. That callback is not a constant, so `lessonApp` is not a `const` widget. The child `LessonApp` is const.
- `AsyncNotifierLesson` is renamed `Lesson44AsyncNotifier`. `ForceError`, `FakeItems`, `forceErrorProvider` and `fakeItemsProvider` keep their names.
- The AppBar keeps the reload `IconButton` and adds `const LessonInfoButton(lessonId: 44)`. The `actions` list is not const, because the reload callback is not a constant. `const Divider(height: 1)` stays as written.
- `items.when(skipLoadingOnRefresh: false, ...)` is unchanged.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 44,
  title: 'AsyncNotifier loading and error',
  notesAsset: '44-async-notifier.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
///
/// ProviderScope stores every provider's state. It must sit above any
/// widget that uses ref. `retry` returns null so a failed load stays on
/// screen instead of retrying itself.
final lessonApp = ProviderScope(
  // Turn off automatic retries so the error state stays visible.
  retry: (retryCount, error) => null,
  child: const LessonApp(lesson: lesson, home: Lesson44AsyncNotifier()),
);

void main() => runApp(lessonApp);

// A simple on/off switch that the fake request checks.
class ForceError extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool value) => state = value;
}

final forceErrorProvider = NotifierProvider<ForceError, bool>(ForceError.new);

class FakeItems extends AsyncNotifier<List<String>> {
  @override
  Future<List<String>> build() async {
    // Pretend this is a network call.
    await Future<void>.delayed(const Duration(seconds: 1));
    if (ref.read(forceErrorProvider)) {
      throw Exception('Network down');
    }
    return ['Alpha', 'Bravo', 'Charlie'];
  }
}

final fakeItemsProvider = AsyncNotifierProvider<FakeItems, List<String>>(
  FakeItems.new,
);

class Lesson44AsyncNotifier extends ConsumerWidget {
  const Lesson44AsyncNotifier({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(fakeItemsProvider);
    final forceError = ref.watch(forceErrorProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AsyncNotifier'),
        actions: [
          IconButton(
            tooltip: 'Reload',
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(fakeItemsProvider),
          ),
          const LessonInfoButton(lessonId: 44),
        ],
      ),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text('Force error'),
            subtitle: const Text('Applies on the next load'),
            value: forceError,
            onChanged: (value) =>
                ref.read(forceErrorProvider.notifier).set(value),
          ),
          const Divider(height: 1),
          Expanded(
            // One builder per state: nothing gets ignored.
            child: items.when(
              skipLoadingOnRefresh: false,
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_off, size: 48, color: Colors.red),
                    const SizedBox(height: 12),
                    Text(
                      'Something went wrong:\n$error',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => ref.invalidate(fakeItemsProvider),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (list) => ListView(
                children: [
                  for (final name in list)
                    ListTile(
                      leading: const Icon(Icons.label_outline),
                      title: Text(name),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```
