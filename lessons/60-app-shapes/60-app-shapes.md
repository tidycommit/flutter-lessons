# Lesson 60: Package vs app vs add-to-app module

**Date:** Nov 18, 2026

Flutter projects come in three shapes, and the difference is who owns the entry point. A package is a reusable library of UI and logic with no `main()`. You test it on its own, and other apps depend on it. An app is the thing you launch: it has `main()`, it hosts one or more packages, and it sets the theme and the router. An add-to-app module is Flutter compiled into an existing iOS or Android app. The native shell still owns the chrome — the status bar, the tab bar, the system back stack — and Flutter fills one screen or a flow inside that shell.

You don't need a multi-package build to learn the idea. Today's demo stays in a single app: three cards, each opening a short detail screen that lists what that shape is responsible for. No new packages to add.

## Key points

- A **package** is a reusable library: UI and logic, no `main()`, tested on its own.
- An **app** has `main()`, hosts one or more packages, and sets the theme and the router.
- A **module (add-to-app)** is Flutter compiled into an existing native app. Native owns the chrome; Flutter fills one screen or a flow inside that shell.

## Code

The tip's snippet, verbatim:

```dart
import 'package:flutter/material.dart';

class AppShape {
  const AppShape({
    required this.title,
    required this.subtitle,
    required this.bullets,
  });

  final String title;
  final String subtitle;
  final List<String> bullets;
}

const shapes = [
  AppShape(
    title: 'Package',
    subtitle: 'Reusable library: UI + logic, no main().',
    bullets: [
      'No main() of its own',
      'Reusable UI and logic other apps can depend on',
      'Tested on its own',
    ],
  ),
  AppShape(
    title: 'App',
    subtitle: 'Has main(), hosts packages, sets theme and router.',
    bullets: [
      'Has main() — this is what you launch',
      'Hosts one or more packages',
      'Sets the theme and the router',
    ],
  ),
  AppShape(
    title: 'Module (add-to-app)',
    subtitle: 'Flutter compiled into an existing native app.',
    bullets: [
      'Lives inside an existing iOS or Android app',
      'Native owns the chrome (status bar, tabs, back stack)',
      'Flutter fills one screen or a flow inside that shell',
    ],
  ),
];

void main() => runApp(const MaterialApp(home: AppShapesPage()));

class AppShapesPage extends StatelessWidget {
  const AppShapesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App shapes')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final shape in shapes)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                child: ListTile(
                  title: Text(shape.title),
                  subtitle: Text(shape.subtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => ShapeDetailPage(shape: shape),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ShapeDetailPage extends StatelessWidget {
  const ShapeDetailPage({super.key, required this.shape});

  final AppShape shape;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(shape.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final bullet in shape.bullets)
            ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: Text(bullet),
            ),
        ],
      ),
    );
  }
}
```

## On screen

The AppBar says "App shapes". Below it are three tappable cards: "Package" with the subtitle "Reusable library: UI + logic, no main().", "App" with "Has main(), hosts packages, sets theme and router.", and "Module (add-to-app)" with "Flutter compiled into an existing native app." Each card has a chevron on the right. Tap Package and a detail screen titled "Package" lists three points: no main() of its own, reusable UI and logic other apps can depend on, and tested on its own. The back arrow returns to the list. Tap App or Module and you get the same kind of detail screen for that shape.

## How it is adapted in this app

- This lesson is its own Flutter project. The snippet's `MaterialApp` is this project's `LessonApp` from the shared `lesson_kit` package, so the info button can find these notes. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` uses `AppShapesPage` as home.
- `AppShapesPage`'s AppBar keeps `title: const Text('App shapes')` and gets `actions: const [LessonInfoButton(lessonId: 60)]`. The detail screens the lesson pushes keep their snippet AppBar and back arrow, and they do not get the info action. `AppShape`, `shapes`, `AppShapesPage`, and `ShapeDetailPage` keep the snippet's names and behavior.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 60,
  title: 'Package vs app vs add-to-app module',
  notesAsset: '60-app-shapes.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: AppShapesPage());

void main() => runApp(lessonApp);

class AppShape {
  const AppShape({
    required this.title,
    required this.subtitle,
    required this.bullets,
  });

  final String title;
  final String subtitle;
  final List<String> bullets;
}

const shapes = [
  AppShape(
    title: 'Package',
    subtitle: 'Reusable library: UI + logic, no main().',
    bullets: [
      'No main() of its own',
      'Reusable UI and logic other apps can depend on',
      'Tested on its own',
    ],
  ),
  AppShape(
    title: 'App',
    subtitle: 'Has main(), hosts packages, sets theme and router.',
    bullets: [
      'Has main() — this is what you launch',
      'Hosts one or more packages',
      'Sets the theme and the router',
    ],
  ),
  AppShape(
    title: 'Module (add-to-app)',
    subtitle: 'Flutter compiled into an existing native app.',
    bullets: [
      'Lives inside an existing iOS or Android app',
      'Native owns the chrome (status bar, tabs, back stack)',
      'Flutter fills one screen or a flow inside that shell',
    ],
  ),
];

class AppShapesPage extends StatelessWidget {
  const AppShapesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App shapes'),
        actions: const [LessonInfoButton(lessonId: 60)],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final shape in shapes)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                child: ListTile(
                  title: Text(shape.title),
                  subtitle: Text(shape.subtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => ShapeDetailPage(shape: shape),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ShapeDetailPage extends StatelessWidget {
  const ShapeDetailPage({super.key, required this.shape});

  final AppShape shape;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(shape.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final bullet in shape.bullets)
            ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: Text(bullet),
            ),
        ],
      ),
    );
  }
}
```
