# Lesson 51: Redirects and guards

**Date:** Nov 9, 2026

Sometimes a screen should only open for signed-in people. go_router handles that with `redirect`, a function that runs before every navigation. It receives the place the user is trying to go (`state.matchedLocation`) and either returns a different path to send them there instead, or `null` to say "let them through". So if you're signed out and ask for `/secret`, the redirect quietly sends you to `/login`. It should only depend on the sign-in state and the target location, and it must not send someone to `/login` when they're already on `/login`, or you'll get an endless loop.

The sign-in flag lives in a `ValueNotifier<bool>`. Passing it as `refreshListenable` tells go_router to run the redirect again whenever it changes, so tapping Log in or Log out moves you automatically. We also remember the page you wanted in a `from` query parameter, so after logging in you land on `/secret` instead of the home page. This builds on go_router from lesson 48; if you skipped it, run `flutter pub add go_router`.

## Key points

- `redirect` runs before every navigation. Return a path to send the user there, or `null` to let them through.
- Do not redirect to `/login` when the user is already on `/login`, or the router loops.
- A `ValueNotifier` passed as `refreshListenable` re-runs the redirect when sign-in changes. A `from` query parameter remembers the page they wanted.

This lesson reuses `go_router`. Each lesson is its own project, so if it is not already in this folder's `pubspec.yaml`, add it:

```sh
flutter pub add go_router
```

## Code

The tip's snippet, verbatim:

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() => runApp(MaterialApp.router(routerConfig: router));

final ValueNotifier<bool> loggedIn = ValueNotifier(false);

final GoRouter router = GoRouter(
  refreshListenable: loggedIn,
  redirect: (context, state) {
    final loggingIn = state.matchedLocation == '/login';
    if (!loggedIn.value && !loggingIn) {
      return '/login?from=${Uri.encodeComponent(state.matchedLocation)}';
    }
    if (loggedIn.value && loggingIn) {
      return state.uri.queryParameters['from'] ?? '/';
    }
    return null;
  },
  routes: [
    GoRoute(path: '/', builder: (c, s) => const Page(title: 'Home', goTo: '/secret', goLabel: 'Open secret')),
    GoRoute(path: '/secret', builder: (c, s) => const Page(title: 'Secret', goTo: '/', goLabel: 'Back home')),
    GoRoute(
      path: '/login',
      builder: (c, s) => Scaffold(
        appBar: AppBar(title: const Text('Auth redirect')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Please log in'),
              const SizedBox(height: 12),
              FilledButton(onPressed: () => loggedIn.value = true, child: const Text('Log in')),
            ],
          ),
        ),
      ),
    ),
  ],
);

class Page extends StatelessWidget {
  const Page({super.key, required this.title, required this.goTo, required this.goLabel});
  final String title, goTo, goLabel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth redirect'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: () => loggedIn.value = false),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            FilledButton(onPressed: () => context.go(goTo), child: Text(goLabel)),
          ],
        ),
      ),
    );
  }
}
```

## On screen

The app starts signed out, so even though the first route is `/`, it lands on a "Auth redirect" screen with the text "Please log in" and a Log in button. Tapping Log in flips the flag and moves you to the Home page, which shows "Home" and an "Open secret" button, with a logout icon in the AppBar. "Open secret" goes to the Secret page, which has a "Back home" button. Tapping the logout icon from either page sends you straight back to the login screen. If you log out while on Secret and log in again, you return to Secret, because the `from` parameter remembers it.

## How it is adapted in this app

- This lesson is its own Flutter project, and it keeps the snippet's `MaterialApp.router`. `Lesson51AuthRedirect` returns that nested router. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` is a `LessonScope` from the shared `lesson_kit` package around that widget, so the info button can find these notes. It does not use `LessonApp`, because the snippet's router is the app.
- The router and the `ValueNotifier<bool>` sign-in flag are created when the lesson mounts and disposed with it. A single global flag would stay signed in the next time the app is pumped. The redirect logic, the `from` query parameter, and the three paths (`/`, `/secret`, `/login`) are the snippet's. `debugShowCheckedModeBanner` is false.
- Login is the first screen you see, because the redirect sends a signed-out visitor there. Its AppBar keeps `title: const Text('Auth redirect')` and gets `actions: const [LessonInfoButton(lessonId: 51)]`. Home and Secret keep the snippet's logout action and do not need the info button.
- The snippet's `Page` widget is renamed `Lesson51Page` so it does not clash with Flutter's own `Page` type. `Lesson51Login` is the login screen. Both take the mount's `loggedIn` notifier instead of reading a global.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 51,
  title: 'Redirects and guards',
  notesAsset: '51-auth-redirect.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonScope(lesson: lesson, child: Lesson51AuthRedirect());

void main() => runApp(lessonApp);

/// Lesson 51: redirects and auth guards.
///
/// The project owns a nested `MaterialApp.router`, so the snippet's paths
/// stay inside this lesson. A [LessonScope] around it (see `main.dart`) lets
/// the info button find the notes. Each mount builds its own [GoRouter] and
/// sign-in flag so a test can open the app more than once without leftover
/// login state.
class Lesson51AuthRedirect extends StatefulWidget {
  const Lesson51AuthRedirect({super.key});

  @override
  State<Lesson51AuthRedirect> createState() => _Lesson51AuthRedirectState();
}

class _Lesson51AuthRedirectState extends State<Lesson51AuthRedirect> {
  late final ValueNotifier<bool> _loggedIn = ValueNotifier(false);

  late final GoRouter _router = GoRouter(
    refreshListenable: _loggedIn,
    redirect: (context, state) {
      final loggingIn = state.matchedLocation == '/login';
      if (!_loggedIn.value && !loggingIn) {
        return '/login?from=${Uri.encodeComponent(state.matchedLocation)}';
      }
      if (_loggedIn.value && loggingIn) {
        return state.uri.queryParameters['from'] ?? '/';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (c, s) => Lesson51Page(
          title: 'Home',
          goTo: '/secret',
          goLabel: 'Open secret',
          loggedIn: _loggedIn,
        ),
      ),
      GoRoute(
        path: '/secret',
        builder: (c, s) => Lesson51Page(
          title: 'Secret',
          goTo: '/',
          goLabel: 'Back home',
          loggedIn: _loggedIn,
        ),
      ),
      GoRoute(
        path: '/login',
        builder: (c, s) => Lesson51Login(loggedIn: _loggedIn),
      ),
    ],
  );

  @override
  void dispose() {
    _router.dispose();
    _loggedIn.dispose();
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

class Lesson51Login extends StatelessWidget {
  const Lesson51Login({super.key, required this.loggedIn});

  final ValueNotifier<bool> loggedIn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth redirect'),
        actions: const [LessonInfoButton(lessonId: 51)],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please log in'),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => loggedIn.value = true,
              child: const Text('Log in'),
            ),
          ],
        ),
      ),
    );
  }
}

class Lesson51Page extends StatelessWidget {
  const Lesson51Page({
    super.key,
    required this.title,
    required this.goTo,
    required this.goLabel,
    required this.loggedIn,
  });

  final String title;
  final String goTo;
  final String goLabel;
  final ValueNotifier<bool> loggedIn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth redirect'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => loggedIn.value = false,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => context.go(goTo),
              child: Text(goLabel),
            ),
          ],
        ),
      ),
    );
  }
}
```
