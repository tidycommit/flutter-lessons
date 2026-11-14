# Lesson 50: ShellRoute bottom nav

**Date:** Nov 8, 2026

Most apps have something that never moves while you switch pages, like a bottom tab bar or a top AppBar. With go_router you get that from a `ShellRoute`. It wraps a group of child routes, and its `builder` receives a `child` widget, which is whatever page the current URL points to. You draw the shared parts (AppBar, bottom bar) once in the shell and drop `child` into the body. When the URL changes from `/home` to `/search`, only the `child` swaps out and the shell stays put.

The tabs themselves are just links. Tapping a tab in the `BottomNavigationBar` calls `context.go('/search')`, and the shell works out which tab to highlight by reading the current path from `GoRouterState.of(context)`. Today's demo also uses `NoTransitionPage` so switching tabs feels instant instead of sliding like a pushed screen. A plain shell like this rebuilds a tab's page when you come back to it. Keeping each tab's own history alive is a later upgrade (`StatefulShellRoute`), so don't worry about it yet. It reuses go_router from lesson 48, so if you skipped that one, run `flutter pub add go_router` first.

## Key points

- A `ShellRoute` `builder` receives `child` — the page for the current URL — and draws the shared AppBar and bottom bar around it.
- Tapping a tab calls `context.go` with that tab's path. The highlighted tab comes from `GoRouterState.of(context)`.
- `NoTransitionPage` makes tab switches instant. A later upgrade, `StatefulShellRoute`, keeps each tab's own history.

This lesson reuses `go_router`. Each lesson is its own project, so if it is not already in this folder's `pubspec.yaml`, add it:

```sh
flutter pub add go_router
```

## Code

The tip's snippet, verbatim:

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(MaterialApp.router(routerConfig: router));
}

final GoRouter router = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: TabPage(label: 'Home', icon: Icons.home, color: Colors.teal),
          ),
        ),
        GoRoute(
          path: '/search',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: TabPage(label: 'Search', icon: Icons.search, color: Colors.orange),
          ),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: TabPage(label: 'Profile', icon: Icons.person, color: Colors.indigo),
          ),
        ),
      ],
    ),
  ],
);

const List<String> tabPaths = ['/home', '/search', '/profile'];

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    final index = tabPaths.indexOf(path).clamp(0, tabPaths.length - 1);

    return Scaffold(
      appBar: AppBar(title: const Text('ShellRoute')),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => context.go(tabPaths[i]),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class TabPage extends StatelessWidget {
  const TabPage({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color.withValues(alpha: 0.15),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 72, color: color),
          const SizedBox(height: 12),
          Text(label, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 4),
          Text('Path: ${GoRouterState.of(context).uri.path}'),
        ],
      ),
    );
  }
}
```

## On screen

The app opens at `/home`. At the top is one AppBar titled "ShellRoute", and at the bottom is a bar with three tabs: Home, Search and Profile, with Home highlighted. The middle is a light teal page with a big teal house icon, the word "Home", and "Path: /home" underneath. Tap "Search" and the middle instantly turns light orange with a magnifying-glass icon, "Search" and "Path: /search", while the AppBar and bottom bar stay exactly where they were and the Search tab lights up. Tap "Profile" and you get a light indigo page with a person icon, "Profile" and "Path: /profile". The mockup shows the Home tab.

## How it is adapted in this app

- This lesson is its own Flutter project, and it keeps the snippet's `MaterialApp.router`. `Lesson50ShellRoute` returns that nested router. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` is a `LessonScope` from the shared `lesson_kit` package around that widget, so the info button can find these notes. It does not use `LessonApp`, because the snippet's router is the app.
- The router is created when the lesson mounts and disposed with it. A single global `GoRouter` would keep its stack the next time the app is pumped, so the first screen would not reliably be `/home`. The routes themselves are the snippet's routes, including `initialLocation: '/home'`, the `ShellRoute`, and the three `NoTransitionPage` tabs. `debugShowCheckedModeBanner` is false, and the theme is the plain `MaterialApp` theme, as the snippet has no `ThemeData`.
- The shell's AppBar keeps `title: const Text('ShellRoute')` and gets `actions: const [LessonInfoButton(lessonId: 50)]`. The AppBar and bottom bar stay on every tab, so the info button stays too. The `BottomNavigationBar` itself is not const, because its constructor asserts on the number of items; the `items` list literal is const, as in the snippet.
- `AppShell`, `TabPage`, and `tabPaths` keep the snippet's names and live in this lesson's `main.dart`.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 50,
  title: 'ShellRoute bottom nav',
  notesAsset: '50-shell-route.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonScope(lesson: lesson, child: Lesson50ShellRoute());

void main() => runApp(lessonApp);

const List<String> tabPaths = ['/home', '/search', '/profile'];

/// Lesson 50: ShellRoute with a shared AppBar and bottom bar.
///
/// The project owns a nested `MaterialApp.router`, so the snippet's paths
/// stay inside this lesson. A [LessonScope] around it (see `main.dart`) lets
/// the info button find the notes. Each mount builds its own [GoRouter] so
/// a test can open the app more than once.
class Lesson50ShellRoute extends StatefulWidget {
  const Lesson50ShellRoute({super.key});

  @override
  State<Lesson50ShellRoute> createState() => _Lesson50ShellRouteState();
}

class _Lesson50ShellRouteState extends State<Lesson50ShellRoute> {
  late final GoRouter _router = GoRouter(
    initialLocation: '/home',
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: TabPage(
                label: 'Home',
                icon: Icons.home,
                color: Colors.teal,
              ),
            ),
          ),
          GoRoute(
            path: '/search',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: TabPage(
                label: 'Search',
                icon: Icons.search,
                color: Colors.orange,
              ),
            ),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: TabPage(
                label: 'Profile',
                icon: Icons.person,
                color: Colors.indigo,
              ),
            ),
          ),
        ],
      ),
    ],
  );

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    final index = tabPaths.indexOf(path).clamp(0, tabPaths.length - 1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ShellRoute'),
        actions: const [LessonInfoButton(lessonId: 50)],
      ),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => context.go(tabPaths[i]),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class TabPage extends StatelessWidget {
  const TabPage({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color.withValues(alpha: 0.15),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 72, color: color),
          const SizedBox(height: 12),
          Text(label, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 4),
          Text('Path: ${GoRouterState.of(context).uri.path}'),
        ],
      ),
    );
  }
}
```
