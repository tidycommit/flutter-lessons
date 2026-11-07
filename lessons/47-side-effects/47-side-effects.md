# Lesson 47: Side effects outside build

**Date:** Nov 5, 2026

`build` is for describing the UI from the current state. It is not the place to fire network calls, open dialogs, or show SnackBars. Those are side effects: they should run once when something changes, not every time Flutter rebuilds the widget. In Riverpod, `ref.listen` is the tool for that. You call it next to your `ref.watch`, and it runs a callback when the provider's value changes — for example, when an async load flips into an error — without putting that logic inside the widget tree itself.

Today's screen watches an `AsyncNotifier` that loads a short string. Flip "Force error" on and tap Reload: the body shows the failure, and `ref.listen` pops a SnackBar once for that error. The comment at the bottom is the anti-pattern: never call `showDialog` or `showSnackBar` directly inside `build` when `status.hasError`, because rebuilds would keep re-firing it. Prefer notifier methods for the work, and `ref.listen` (or a post-frame callback) for the one-shot UI reaction. No new packages today — still on `flutter_riverpod` from lesson 41.

## Key points

- `build` describes the UI. It does not open dialogs, show SnackBars, or start work.
- `ref.listen` runs beside `build` and reacts when the provider changes.
- Prefer a notifier method, here `reload()`, for the work itself.
- The `showDialog` call inside `build` stays a comment so it cannot run.

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
  runApp(const ProviderScope(child: MaterialApp(home: SideEffectsLesson())));
}

class ForceError extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool value) => state = value;
}

class LoadStatus extends AsyncNotifier<String> {
  @override
  Future<String> build() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (ref.read(forceErrorProvider)) {
      throw 'Network down';
    }
    return 'Loaded OK';
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await Future<void>.delayed(const Duration(milliseconds: 400));
      if (ref.read(forceErrorProvider)) {
        throw 'Network down';
      }
      return 'Loaded OK';
    });
  }
}

final forceErrorProvider = NotifierProvider<ForceError, bool>(ForceError.new);
final loadStatusProvider =
    AsyncNotifierProvider<LoadStatus, String>(LoadStatus.new);

class SideEffectsLesson extends ConsumerWidget {
  const SideEffectsLesson({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Side effect beside build — not inside the tree construction.
    ref.listen<AsyncValue<String>>(loadStatusProvider, (prev, next) {
      next.whenOrNull(
        error: (err, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $err')),
          );
        },
      );
    });

    final status = ref.watch(loadStatusProvider);
    final forceError = ref.watch(forceErrorProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Side effects')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Force error'),
            value: forceError,
            onChanged: (v) => ref.read(forceErrorProvider.notifier).set(v),
          ),
          const SizedBox(height: 8),
          status.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text(
              'Failed: $e',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            data: (v) => Text(
              v,
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => ref.read(loadStatusProvider.notifier).reload(),
            icon: const Icon(Icons.refresh),
            label: const Text('Reload'),
          ),
          const SizedBox(height: 16),
          // WRONG — never do this (left as a comment so it won't compile):
          // if (status.hasError) {
          //   showDialog(context: context, builder: ...); // side effect in build!
          // }
          Text(
            'Wrong (don’t): calling showDialog or showSnackBar '
            'directly inside build when status.hasError.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
```

## On screen

The AppBar reads "Side effects". Below it a "Force error" switch starts off, and the body briefly shows a spinner then big text "Loaded OK", with a purple "Reload" button under it and a small note about not calling dialogs inside build. Flip Force error on and tap Reload: you get a short spinner, then red "Failed: Network down", and a dark SnackBar at the bottom that says "Error: Network down" once for that failure. Flip the switch off and Reload again to get back to "Loaded OK" with no SnackBar. The mockup shows the error state with the SnackBar visible.

## How it is adapted in this app

- This lesson is its own Flutter project. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` is a `ProviderScope` around a `LessonApp` from the shared `lesson_kit` package, whose `home` is `Lesson47SideEffects`.
- `SideEffectsLesson` is renamed `Lesson47SideEffects`. `ForceError`, `LoadStatus`, `forceErrorProvider` and `loadStatusProvider` keep their names.
- `ref.listen` still shows one SnackBar when the load becomes an error. The commented `showDialog` inside `build` is unchanged.
- The AppBar keeps `title: const Text('Side effects')` with default styling, and gets `actions: const [LessonInfoButton(lessonId: 47)]`, the button that opens these notes.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 47,
  title: 'Side effects outside build',
  notesAsset: '47-side-effects.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
///
/// ProviderScope stores every provider's state. It must sit above any
/// widget that uses ref.
const lessonApp = ProviderScope(
  child: LessonApp(lesson: lesson, home: Lesson47SideEffects()),
);

void main() => runApp(lessonApp);

class ForceError extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool value) => state = value;
}

class LoadStatus extends AsyncNotifier<String> {
  @override
  Future<String> build() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (ref.read(forceErrorProvider)) {
      throw 'Network down';
    }
    return 'Loaded OK';
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await Future<void>.delayed(const Duration(milliseconds: 400));
      if (ref.read(forceErrorProvider)) {
        throw 'Network down';
      }
      return 'Loaded OK';
    });
  }
}

final forceErrorProvider = NotifierProvider<ForceError, bool>(ForceError.new);
final loadStatusProvider = AsyncNotifierProvider<LoadStatus, String>(
  LoadStatus.new,
);

class Lesson47SideEffects extends ConsumerWidget {
  const Lesson47SideEffects({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Side effect beside build — not inside the tree construction.
    ref.listen<AsyncValue<String>>(loadStatusProvider, (prev, next) {
      next.whenOrNull(
        error: (err, _) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Error: $err')));
        },
      );
    });

    final status = ref.watch(loadStatusProvider);
    final forceError = ref.watch(forceErrorProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Side effects'),
        actions: const [LessonInfoButton(lessonId: 47)],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Force error'),
            value: forceError,
            onChanged: (v) => ref.read(forceErrorProvider.notifier).set(v),
          ),
          const SizedBox(height: 8),
          status.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text(
              'Failed: $e',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            data: (v) =>
                Text(v, style: Theme.of(context).textTheme.displaySmall),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => ref.read(loadStatusProvider.notifier).reload(),
            icon: const Icon(Icons.refresh),
            label: const Text('Reload'),
          ),
          const SizedBox(height: 16),
          // WRONG — never do this (left as a comment so it won't compile):
          // if (status.hasError) {
          //   showDialog(context: context, builder: ...); // side effect in build!
          // }
          Text(
            'Wrong (don’t): calling showDialog or showSnackBar '
            'directly inside build when status.hasError.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
```
