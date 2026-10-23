# Lesson 32: ThemeData as the source of truth

**Date:** Oct 21, 2026

This is lesson 2 of the design-system series.

Yesterday we built a small shared kit. Today we give that kit one place to get its look from: `ThemeData`. Instead of writing `Colors.blue` or a font size on every widget, you describe colors, typography, and component styles once on `MaterialApp`, and every widget below reads them with `Theme.of(context)`. Cards, buttons, and text then all agree, with no extra effort.

The payoff shows up when the look changes. Flip one switch from light to dark and the whole screen restyles together, because nothing has its own hardcoded color. If one part of the screen really does need a different look, wrap it in `Theme(data: ..., child: ...)` instead of styling each widget inside it one by one.

## Key points

- Read values from `Theme.of(context).colorScheme` and `.textTheme`.
- Override a subtree with `Theme(data: …, child: …)` when needed.
- Avoid sprinkling `Colors.blue` in widgets when the theme already defines primary.

No new packages today (no `flutter pub add` needed).

## Code

```dart
import 'package:flutter/material.dart';

void main() => runApp(const ThemeDataDemo());

class ThemeDataDemo extends StatefulWidget {
  const ThemeDataDemo({super.key});

  @override
  State<ThemeDataDemo> createState() => _ThemeDataDemoState();
}

class _ThemeDataDemoState extends State<ThemeDataDemo> {
  bool _dark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // One place decides the look of the whole tree.
      theme: ThemeData(colorSchemeSeed: Colors.indigo, brightness: Brightness.light),
      darkTheme: ThemeData(colorSchemeSeed: Colors.indigo, brightness: Brightness.dark),
      themeMode: _dark ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(title: const Text('ThemeData')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SwitchListTile(
              title: const Text('Dark mode'),
              value: _dark,
              onChanged: (value) => setState(() => _dark = value),
            ),
            const SizedBox(height: 12),
            const ThemedCard(),
          ],
        ),
      ),
    );
  }
}

class ThemedCard extends StatelessWidget {
  const ThemedCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Read values from the theme instead of hardcoding Colors.blue.
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order summary', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Every color here comes from Theme.of(context).',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Primary color',
              style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () {}, child: const Text('Checkout')),
          ],
        ),
      ),
    );
  }
}
```

## On screen

An AppBar titled "ThemeData" above a "Dark mode" switch row and a card. The card shows the heading "Order summary", the line "Every color here comes from Theme.of(context).", the label "Primary color" in the indigo primary color, and a "Checkout" button. Tapping the switch turns the whole screen dark at once: the background, card, text, and button all switch to their dark-theme colors. Tapping it again brings back the light theme.

## How it is adapted in this app

- This lesson is its own Flutter project, and it keeps the snippet's own `MaterialApp`, because its `theme`, `darkTheme` and `themeMode` are the lesson: the switch restyles the whole app.
- `main()` is `void main() => runApp(lessonApp);`. `lessonApp` wraps the app in a `LessonScope` from the shared `lesson_kit` package, so the info button can find these notes.
- `ThemeDataDemo` is renamed `Lesson32ThemeData` and `ThemedCard` is renamed `Lesson32ThemedCard`. The themes, the switch and the card are unchanged; `dart format` only wraps the long `ThemeData(...)` and `copyWith` lines.
- The AppBar keeps `title: const Text('ThemeData')` with default styling, and gets `actions: const [LessonInfoButton(lessonId: 32)]`, the button that opens these notes. The notes sheet opens inside this app, so it follows the light or dark theme too.
- System and browser back close the notes sheet first, like any other route on the app's navigator.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 32,
  title: 'ThemeData as the source of truth',
  notesAsset: '32-theme-data.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonScope(lesson: lesson, child: Lesson32ThemeData());

void main() => runApp(lessonApp);

/// Lesson 32: ThemeData as the single source of visual truth.
///
/// The project owns its `MaterialApp`, so the snippet's `theme`,
/// `darkTheme` and `themeMode` apply to the whole app. A [LessonScope]
/// around it (see `main.dart`) lets the info button find the notes.
class Lesson32ThemeData extends StatefulWidget {
  const Lesson32ThemeData({super.key});

  @override
  State<Lesson32ThemeData> createState() => _Lesson32ThemeDataState();
}

class _Lesson32ThemeDataState extends State<Lesson32ThemeData> {
  bool _dark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // One place decides the look of the whole tree.
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
      ),
      themeMode: _dark ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ThemeData'),
          actions: const [LessonInfoButton(lessonId: 32)],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SwitchListTile(
              title: const Text('Dark mode'),
              value: _dark,
              onChanged: (value) => setState(() => _dark = value),
            ),
            const SizedBox(height: 12),
            const Lesson32ThemedCard(),
          ],
        ),
      ),
    );
  }
}

class Lesson32ThemedCard extends StatelessWidget {
  const Lesson32ThemedCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Read values from the theme instead of hardcoding Colors.blue.
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order summary', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Every color here comes from Theme.of(context).',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Primary color',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () {}, child: const Text('Checkout')),
          ],
        ),
      ),
    );
  }
}
```
