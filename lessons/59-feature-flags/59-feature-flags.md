# Lesson 59: Feature flags in the UI

**Date:** Nov 17, 2026

A feature flag is a true/false setting that turns a piece of the screen on or off without shipping a new app. The widget just asks a provider for the flags and branches: if the flag is on, show the new thing, otherwise show the old one. Because the flags live in one provider, a demo or a test can override them in a single line.

Defaults matter. If the flag service is down, the app should fall back to a safe value (usually "off"). Today's demo keeps the flags in a small provider, and a switch overrides the value. A real remote flag is the same provider with a different implementation that fetches from a server. Run `flutter pub add flutter_riverpod` first (added in lesson 41).

## Key points

- `featureFlagsProvider` holds a typed `FeatureFlags` object. The widget `watch`es it and branches with `if (flags.newBadge)`.
- Defaults matter: `newBadge` starts off, the safe value if a flag service is down.
- Override the provider in a demo or a test. A remote flag is the same provider with a different implementation.

This lesson needs `flutter_riverpod`. Each lesson is its own project, so if it is not already in this folder's `pubspec.yaml`, add it:

```sh
flutter pub add flutter_riverpod
```

## Code

The tip's snippet, verbatim:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeatureFlags {
  const FeatureFlags({this.newBadge = false});
  final bool newBadge; // safe default: off

  FeatureFlags copyWith({bool? newBadge}) =>
      FeatureFlags(newBadge: newBadge ?? this.newBadge);
}

class FeatureFlagsNotifier extends Notifier<FeatureFlags> {
  @override
  FeatureFlags build() => const FeatureFlags();

  void setNewBadge(bool value) => state = state.copyWith(newBadge: value);
}

final featureFlagsProvider =
    NotifierProvider<FeatureFlagsNotifier, FeatureFlags>(
  FeatureFlagsNotifier.new,
);

void main() => runApp(const ProviderScope(child: MaterialApp(home: FlagsPage())));

class FlagsPage extends ConsumerWidget {
  const FlagsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flags = ref.watch(featureFlagsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Feature flags')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Enable New Badge'),
            value: flags.newBadge,
            onChanged: (v) =>
                ref.read(featureFlagsProvider.notifier).setNewBadge(v),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              title: const Text('Trail Backpack'),
              subtitle: const Text('\$59.00'),
              trailing: flags.newBadge
                  ? const Chip(label: Text('NEW'))
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
```

## On screen

An app bar titled "Feature flags". Below it, a switch row "Enable New Badge" (off at first) and a card for "Trail Backpack, $59.00". With the switch off, the card has no badge. Flip the switch on and a "NEW" chip appears at the right of the card; flip it off and the chip disappears.

## How it is adapted in this app

- This lesson is its own Flutter project. The snippet's `MaterialApp` is this project's `LessonApp` from the shared `lesson_kit` package, wrapped in the same `ProviderScope` the snippet uses, so providers work and the info button can find these notes. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` uses `FlagsPage` as home.
- `FlagsPage`'s AppBar keeps `title: const Text('Feature flags')` and gets `actions: const [LessonInfoButton(lessonId: 59)]`. `FeatureFlags`, `FeatureFlagsNotifier`, `featureFlagsProvider`, and `FlagsPage` keep the snippet's names and behavior.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 59,
  title: 'Feature flags in the UI',
  notesAsset: '59-feature-flags.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = ProviderScope(
  child: LessonApp(lesson: lesson, home: FlagsPage()),
);

void main() => runApp(lessonApp);

class FeatureFlags {
  const FeatureFlags({this.newBadge = false});
  final bool newBadge; // safe default: off

  FeatureFlags copyWith({bool? newBadge}) =>
      FeatureFlags(newBadge: newBadge ?? this.newBadge);
}

class FeatureFlagsNotifier extends Notifier<FeatureFlags> {
  @override
  FeatureFlags build() => const FeatureFlags();

  void setNewBadge(bool value) => state = state.copyWith(newBadge: value);
}

final featureFlagsProvider =
    NotifierProvider<FeatureFlagsNotifier, FeatureFlags>(
      FeatureFlagsNotifier.new,
    );

class FlagsPage extends ConsumerWidget {
  const FlagsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flags = ref.watch(featureFlagsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feature flags'),
        actions: const [LessonInfoButton(lessonId: 59)],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Enable New Badge'),
            value: flags.newBadge,
            onChanged: (v) =>
                ref.read(featureFlagsProvider.notifier).setNewBadge(v),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              title: const Text('Trail Backpack'),
              subtitle: const Text('\$59.00'),
              trailing: flags.newBadge ? const Chip(label: Text('NEW')) : null,
            ),
          ),
        ],
      ),
    );
  }
}
```
