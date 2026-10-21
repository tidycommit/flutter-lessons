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

- `main()` is dropped. The snippet's own `MaterialApp` is kept, nested inside the app's, because its `theme`, `darkTheme` and `themeMode` are the lesson: the switch restyles everything under that inner `MaterialApp` and nothing outside it.
- `ThemeDataDemo` is renamed `Lesson32ThemeData` and `ThemedCard` is renamed `Lesson32ThemedCard`. The themes, the switch and the card are unchanged; `dart format` only wraps the long `ThemeData(...)` and `copyWith` lines.
- The AppBar keeps `title: const Text('ThemeData')` with default styling, and gets `actions: const [LessonInfoButton(lessonId: 32)]`, the button that opens these notes. The notes sheet opens inside the nested app, so it follows the light or dark theme too.
- The nested `MaterialApp` brings its own `Navigator`, and the Scaffold is that navigator's first route, so the AppBar would show no back arrow. As in lesson 24, the AppBar gets `leading: BackButton(...)`, which pops the lesson off the app's navigator (`rootNavigator: true`) back to the lesson list.
- System and browser back go to the app's navigator, so on their own they would pop the whole lesson even while the notes sheet (which lives in the nested app) is open. The lesson wraps the nested `MaterialApp` in a `PopScope` with `canPop: false`: back first closes the nested app's top route if there is one (the notes sheet), and otherwise leaves the lesson. One side effect is that the iOS edge swipe doesn't leave this lesson; use the back arrow.

## Example

This is the runnable example in `lib/lessons/32_theme_data.dart`:

```dart
/// Lesson 32: ThemeData as the single source of visual truth.
///
/// The snippet owns a nested MaterialApp so its theme and themeMode apply to
/// the whole demo. That MaterialApp brings its own Navigator, so the AppBar
/// gets an explicit back arrow to the lesson list, as in lesson 24, and a
/// PopScope routes system back to the nested Navigator first.
class Lesson32ThemeData extends StatefulWidget {
  const Lesson32ThemeData({super.key});

  @override
  State<Lesson32ThemeData> createState() => _Lesson32ThemeDataState();
}

class _Lesson32ThemeDataState extends State<Lesson32ThemeData> {
  bool _dark = false;
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    // System and browser back go to the app's navigator, which would pop
    // the whole lesson even while the nested app shows the notes sheet. So
    // this route handles back itself: close the nested app's top route if
    // there is one, otherwise leave the lesson.
    return PopScope<Object?>(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        final nested = _navigatorKey.currentState;
        if (nested != null && nested.canPop()) {
          nested.pop();
        } else {
          Navigator.of(context).pop();
        }
      },
      child: MaterialApp(
        navigatorKey: _navigatorKey,
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
            // The nested MaterialApp has its own Navigator, where this is the
            // first route, so there is no implied back arrow. This one pops the
            // lesson off the app's navigator, back to the lesson list.
            leading: BackButton(
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            ),
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
