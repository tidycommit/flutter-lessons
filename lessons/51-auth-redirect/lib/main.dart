import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:lesson_kit/lesson_kit.dart';

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
