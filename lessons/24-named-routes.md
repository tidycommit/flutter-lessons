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

A lesson can't own the app's `MaterialApp`; there is one, in `lib/main.dart`, and it runs the lesson list. So this lesson uses the pattern the teacher suggested: a **nested `Navigator`** that plays the part of the snippet's `MaterialApp`.

- `MyApp` becomes `Lesson24NamedRoutes`, which holds the same route map (`'/'`, `'/settings'`, `'/about'`) in `Lesson24NamedRoutes.routes` and builds a `Navigator` with `initialRoute: '/'`. A `Navigator` has no `routes` parameter, so its `onGenerateRoute` looks the name up in that map and wraps the builder in a `MaterialPageRoute`.
- The screens are named `Lesson24Home`, `Lesson24Settings` and `Lesson24About`. Their titles, text and buttons are unchanged, and Home still calls `Navigator.pushNamed(context, '/settings')` and `Navigator.pushNamed(context, '/about')`. Inside the nested `Navigator`, `Navigator.pushNamed(context, ...)` finds that nested navigator, so the names resolve against the lesson's own map.
- Home is the nested navigator's first route, so its AppBar would not show a back arrow on its own. It gets an explicit `leading: BackButton(...)` that pops the lesson off the app's navigator (`Navigator.of(context, rootNavigator: true).pop()`), back to the lesson list. Home's AppBar also has `actions: const [LessonInfoButton(lessonId: 24)]`, the button that opens these notes.
- Settings and About show their own back arrows, which return to Home.
- A `NavigatorPopHandler` makes the system or browser back button behave sensibly. On Settings or About it returns to Home. On Home it leaves the lesson.

## Example

This is the runnable example in `lib/lessons/24_named_routes.dart`:

```dart
///
/// The lesson can't own the app's MaterialApp, so it hosts its own nested
/// Navigator with the same route names.
class Lesson24NamedRoutes extends StatefulWidget {
  const Lesson24NamedRoutes({super.key});

  /// The same route map as the snippet's MaterialApp `routes`.
  static final routes = <String, WidgetBuilder>{
    '/': (context) => const Lesson24Home(),
    '/settings': (context) => const Lesson24Settings(),
    '/about': (context) => const Lesson24About(),
  };

  @override
  State<Lesson24NamedRoutes> createState() => _Lesson24NamedRoutesState();
}

class _Lesson24NamedRoutesState extends State<Lesson24NamedRoutes> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    // System and browser back pop the nested Navigator first (Settings or
    // About back to Home); on Home they leave the lesson.
    return NavigatorPopHandler<Object?>(
      onPopWithResult: (_) => _navigatorKey.currentState!.maybePop(),
      child: Navigator(
        key: _navigatorKey,
        initialRoute: '/',
        onGenerateRoute: (settings) {
          final builder = Lesson24NamedRoutes.routes[settings.name];
          if (builder == null) return null;
          return MaterialPageRoute<void>(builder: builder, settings: settings);
        },
      ),
    );
  }
}

class Lesson24Home extends StatelessWidget {
  const Lesson24Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Home is the nested Navigator's first route, so there is no implied
        // back arrow. This one pops the lesson off the app's navigator.
        leading: BackButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
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
