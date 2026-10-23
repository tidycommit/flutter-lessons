# Lesson 24: Named routes with routes and Navigator.pushNamed

**Date:** Oct 13, 2026

This is lesson 4 of the navigation series.

So far we've opened screens by building a `MaterialPageRoute` right where the button is. That works, but once an app has lots of screens it gets messy.

Named routes let you give each screen a short name, like `'/settings'`, and list them all in one place on `MaterialApp` with the `routes` map. Then any button can open a screen just by saying its name with `Navigator.pushNamed(context, '/settings')`.

The `'/'` route is the home screen, and `initialRoute: '/'` tells the app to start there (don't also set `home:` when `'/'` is in `routes`). Going back still works the same way: the AppBar back arrow, or `Navigator.pop(context)`.

The nice part is that all your screens are listed together, so you can see the whole app's map at a glance.

## Key points

- `routes` maps a name to a builder: `'/settings': (context) => const SettingsScreen()`.
- `Navigator.pushNamed(context, '/settings')` opens a screen by name.
- `'/'` is the home route; use `initialRoute: '/'` and don't also set `home:`.
- Back works as before: the AppBar back arrow or `Navigator.pop(context)`.

## Code

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/about': (context) => const AboutScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/settings'),
              child: const Text('Settings'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/about'),
              child: const Text('About'),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings screen')),
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: const Center(child: Text('About this app')),
    );
  }
}
```

## On screen

Home has an AppBar titled Home with two buttons stacked in the middle, Settings and About. Tapping Settings slides in a screen with an AppBar titled Settings, a back arrow and "Settings screen" in the center. Tapping About opens an About screen that says "About this app". The back arrow on either one returns to Home.

## How it is adapted in this app

- This lesson is its own Flutter project, and it keeps the snippet's own `MaterialApp`, because `initialRoute` and `routes` are the lesson. `MyApp` becomes `Lesson24NamedRoutes`, whose `build` returns `MaterialApp(initialRoute: '/', routes: routes)` with the same route map (`'/'`, `'/settings'`, `'/about'`). It uses the plain `MaterialApp` theme, as the snippet does.
- `main()` is `void main() => runApp(lessonApp);`. `lessonApp` wraps the app in a `LessonScope` from the shared `lesson_kit` package, so the info button can find these notes.
- The screens are named `Lesson24Home`, `Lesson24Settings` and `Lesson24About`. Their titles, text and buttons are unchanged, and Home still calls `Navigator.pushNamed(context, '/settings')` and `'/about'`.
- Home's AppBar keeps `title: const Text('Home')` and gets `actions: const [LessonInfoButton(lessonId: 24)]`, the button that opens these notes. Home is the first route, so it has no back arrow.
- Settings and About show their own back arrows, which return to Home, and so does system or browser back.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 24,
  title: 'Named routes with routes and Navigator.pushNamed',
  notesAsset: '24-named-routes.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonScope(lesson: lesson, child: Lesson24NamedRoutes());

void main() => runApp(lessonApp);

/// Lesson 24: Named routes with `routes` and `Navigator.pushNamed`.
///
/// The project owns its `MaterialApp`, so the snippet's `initialRoute` and
/// `routes` map are used as written. A [LessonScope] around it (see
/// `main.dart`) lets the info button find the notes.
class Lesson24NamedRoutes extends StatelessWidget {
  const Lesson24NamedRoutes({super.key});

  /// The snippet's MaterialApp `routes`.
  static final routes = <String, WidgetBuilder>{
    '/': (context) => const Lesson24Home(),
    '/settings': (context) => const Lesson24Settings(),
    '/about': (context) => const Lesson24About(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: routes,
    );
  }
}

class Lesson24Home extends StatelessWidget {
  const Lesson24Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: const [LessonInfoButton(lessonId: 24)],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/settings'),
              child: const Text('Settings'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/about'),
              child: const Text('About'),
            ),
          ],
        ),
      ),
    );
  }
}

class Lesson24Settings extends StatelessWidget {
  const Lesson24Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings screen')),
    );
  }
}

class Lesson24About extends StatelessWidget {
  const Lesson24About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: const Center(child: Text('About this app')),
    );
  }
}
```
