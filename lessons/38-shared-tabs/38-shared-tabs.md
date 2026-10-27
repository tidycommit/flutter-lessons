# Lesson 38: Shared tabs pattern

**Date:** Oct 27, 2026

This is lesson 8 of the design-system series: tabs with a shared TabBar pattern.

Back in lesson 27 you built tabs by hand with `DefaultTabController`, a `TabBar` and a `TabBarView`. That works, but if every screen copies those three pieces, the tabs slowly drift apart: one screen gets a different indicator, another forgets to match the number of tabs. Tabs are a navigation pattern, so treat them like the shared button and dialog from the last few lessons: wrap them once in a small `AppTabs` widget that takes a list of `labels` and a matching list of `children`, and use it everywhere.

The one rule `AppTabs` enforces is that the number of labels must equal the number of pages. An `assert` catches a mismatch while you're developing. For a simple demo, `DefaultTabController` is fine; if you later need to react when the tab changes, own a `TabController` inside a `State` class instead. Keep each tab body its own small widget so the tabs stay independent. It's the same Flutter APIs as lesson 27, just packaged so every screen gets them right.

## Key points

- Wrap `DefaultTabController` + `TabBar` + `TabBarView` once in `AppTabs`, which takes `labels` and `children`.
- The number of labels must match the number of children; an `assert` checks it in debug builds.
- `DefaultTabController` is fine for demos; own a `TabController` in `State` when you need to listen for tab changes.
- Keep tab bodies independent widgets (here, `_TabPage`).
- Don't call `AppTabs` with `const`: its assert reads `labels.length`, which can't run in a constant expression. Make the lists `const` instead.

No new packages today (no `flutter pub add` needed): the tab widgets are all in `package:flutter/material.dart`.

## Code

The tip's snippet, verbatim:

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: TabsDemo()));

/// One shared tabs widget: labels on top, matching pages below.
class AppTabs extends StatelessWidget {
  const AppTabs({super.key, required this.labels, required this.children})
      : assert(labels.length == children.length,
            'Each tab label needs exactly one page.');

  final List<String> labels;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: labels.length,
      child: Column(
        children: [
          TabBar(tabs: [for (final label in labels) Tab(text: label)]),
          Expanded(child: TabBarView(children: children)),
        ],
      ),
    );
  }
}

class TabsDemo extends StatelessWidget {
  const TabsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AppTabs')),
      body: const AppTabs(
        labels: ['Overview', 'Details', 'Settings'],
        children: [
          _TabPage(text: 'Overview content'),
          _TabPage(text: 'Details content'),
          _TabPage(text: 'Settings content'),
        ],
      ),
    );
  }
}

/// Each tab body is its own small, independent widget.
class _TabPage extends StatelessWidget {
  const _TabPage({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(text, style: Theme.of(context).textTheme.headlineSmall),
    );
  }
}
```

## On screen

The AppBar reads "AppTabs". Right under it is a row of three tabs, "Overview", "Details" and "Settings", with "Overview" highlighted in purple and underlined by a short indicator bar. The rest of the screen shows "Overview content" centered in large text. Tapping "Details" slides the indicator over and the page slides sideways to show "Details content"; tapping "Settings" shows "Settings content". You can also swipe left or right on the page to move between tabs, and the indicator follows along.

## How it is adapted in this app

- This lesson is its own Flutter project. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` is a `LessonApp` from the shared `lesson_kit` package: a `MaterialApp` with the shared theme and the lesson heading as its title, whose `home` is `Lesson38SharedTabs`.
- `TabsDemo` is renamed `Lesson38SharedTabs`. `AppTabs` and `_TabPage` keep their names, because they are the idea being taught.
- The AppBar keeps `title: const Text('AppTabs')` with default styling, and gets `actions: const [LessonInfoButton(lessonId: 38)]`, the button that opens these notes.
- **Fix:** the snippet as written does not compile. `body: const AppTabs(...)` makes Dart evaluate the constructor's `assert` at compile time, and `labels.length` is not allowed in a constant expression (`const_eval_property_access`). The example drops `const` from the `AppTabs(...)` call and puts it on the two lists instead, so the assert still runs at runtime.
- `dart format` reflows the assert and a doc comment is added to the page; the code is otherwise unchanged.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 38,
  title: 'Shared tabs pattern',
  notesAsset: '38-shared-tabs.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: Lesson38SharedTabs());

void main() => runApp(lessonApp);

/// One shared tabs widget: labels on top, matching pages below.
class AppTabs extends StatelessWidget {
  const AppTabs({super.key, required this.labels, required this.children})
    : assert(
        labels.length == children.length,
        'Each tab label needs exactly one page.',
      );

  final List<String> labels;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: labels.length,
      child: Column(
        children: [
          TabBar(tabs: [for (final label in labels) Tab(text: label)]),
          Expanded(child: TabBarView(children: children)),
        ],
      ),
    );
  }
}

/// The page: three tabs built with the shared [AppTabs] widget.
class Lesson38SharedTabs extends StatelessWidget {
  const Lesson38SharedTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppTabs'),
        actions: const [LessonInfoButton(lessonId: 38)],
      ),
      // Not `const AppTabs(...)`: a const call would evaluate the assert
      // at compile time, and `List.length` isn't allowed there.
      body: AppTabs(
        labels: const ['Overview', 'Details', 'Settings'],
        children: const [
          _TabPage(text: 'Overview content'),
          _TabPage(text: 'Details content'),
          _TabPage(text: 'Settings content'),
        ],
      ),
    );
  }
}

/// Each tab body is its own small, independent widget.
class _TabPage extends StatelessWidget {
  const _TabPage({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(text, style: Theme.of(context).textTheme.headlineSmall),
    );
  }
}
```
