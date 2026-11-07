# Lesson 46: keepAlive shared state

**Date:** Nov 4, 2026

An auto-dispose provider cleans itself up as soon as no widget is listening to it. That's great for a search box or a screen's temporary data, but terrible for "who is logged in": walk away from the Profile screen and, without warning, the user is logged out. For session or auth-style state, you call `ref.keepAlive()` inside `build()`. That tells Riverpod "keep this one around even when nobody is watching." The state still has an off switch: a `logout()` method that resets it to `null`. And in tests you can still override it like any other provider (lesson 45).

Today's demo has two tabs. "Profile" watches two auto-dispose providers that are identical except that one, `sessionProvider`, calls `keepAlive()`, and the other, `tempSessionProvider`, doesn't. "Log in" signs both in as Ada. Now switch to the "Other" tab, which watches nothing, and come back: the kept session still says Ada, but the temporary one was disposed while you were away and is back to "Signed out". "Log out" clears both. No new packages today, since `flutter_riverpod` was added in lesson 41.

## Key points

- An auto-dispose provider is disposed when nothing is listening.
- `ref.keepAlive()` inside `build()` keeps session state after the listener goes away.
- `logout()` sets the state back to null. An override can still replace the provider in a test.
- Only the visible tab is built, so leaving Profile drops its listeners.

The tip says no new packages are needed because lesson 41 added `flutter_riverpod`. Each lesson here is its own project, so this one adds it to its own `pubspec.yaml` too:

```sh
flutter pub add flutter_riverpod
```

## Code

The tip's snippet, verbatim:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MaterialApp(home: SessionLesson())));
}

// Survives when nobody is listening.
class Session extends Notifier<String?> {
  @override
  String? build() {
    ref.keepAlive();
    return null;
  }

  void login(String name) => state = name;
  void logout() => state = null;
}

// Same thing without keepAlive: it resets once unwatched.
class TempSession extends Notifier<String?> {
  @override
  String? build() => null;

  void login(String name) => state = name;
  void logout() => state = null;
}

final sessionProvider =
    NotifierProvider.autoDispose<Session, String?>(Session.new);
final tempSessionProvider =
    NotifierProvider.autoDispose<TempSession, String?>(TempSession.new);

class SessionLesson extends StatefulWidget {
  const SessionLesson({super.key});

  @override
  State<SessionLesson> createState() => _SessionLessonState();
}

class _SessionLessonState extends State<SessionLesson> {
  int tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Session')),
      // Only the current tab is built, so Profile stops listening when hidden.
      body: tab == 0 ? const ProfileTab() : const OtherTab(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (i) => setState(() => tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          NavigationDestination(icon: Icon(Icons.apps), label: 'Other'),
        ],
      ),
    );
  }
}

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kept = ref.watch(sessionProvider);
    final temp = ref.watch(tempSessionProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          leading: const Icon(Icons.lock),
          title: const Text('Session (keepAlive)'),
          subtitle: Text(kept ?? 'Signed out'),
        ),
        ListTile(
          leading: const Icon(Icons.timer_outlined),
          title: const Text('Temp session (auto-dispose)'),
          subtitle: Text(temp ?? 'Signed out'),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: FilledButton(
                onPressed: () {
                  ref.read(sessionProvider.notifier).login('Ada');
                  ref.read(tempSessionProvider.notifier).login('Ada');
                },
                child: const Text('Log in'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  ref.read(sessionProvider.notifier).logout();
                  ref.read(tempSessionProvider.notifier).logout();
                },
                child: const Text('Log out'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class OtherTab extends StatelessWidget {
  const OtherTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Nothing here watches the session.\nNow go back to Profile.',
          textAlign: TextAlign.center),
    );
  }
}
```

## On screen

The AppBar reads "Session" and a bottom bar has two tabs, "Profile" (a person icon) and "Other" (a grid icon). On Profile you see two rows: "Session (keepAlive)" with a lock icon and "Temp session (auto-dispose)" with a timer icon, both saying "Signed out", and below them a purple "Log in" button next to an outlined "Log out" button. Tap Log in and both rows say "Ada". Switch to Other, which just says "Nothing here watches the session. Now go back to Profile.", then go back: the keepAlive row still says "Ada" while the temp row has reset to "Signed out". Log out sets both back to "Signed out". The mockup shows Profile right after returning from Other.

## How it is adapted in this app

- This lesson is its own Flutter project. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` is a `ProviderScope` around a `LessonApp` from the shared `lesson_kit` package, whose `home` is `Lesson46KeepAliveSession`.
- `SessionLesson` is renamed `Lesson46KeepAliveSession`. `Session`, `TempSession`, `sessionProvider`, `tempSessionProvider`, `ProfileTab` and `OtherTab` keep their names. Log in still signs both in as Ada.
- `NavigationBar` is not a const call. Its constructor asserts on `destinations` and `selectedIndex`, and that constructor is not const. The destination list stays a const list literal, as in the snippet: `destinations: const [NavigationDestination(...), NavigationDestination(...)]`.
- The AppBar keeps `title: const Text('Session')` with default styling, and gets `actions: const [LessonInfoButton(lessonId: 46)]`, the button that opens these notes.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 46,
  title: 'keepAlive shared state',
  notesAsset: '46-keepalive-session.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
///
/// ProviderScope stores every provider's state. It must sit above any
/// widget that uses ref.
const lessonApp = ProviderScope(
  child: LessonApp(lesson: lesson, home: Lesson46KeepAliveSession()),
);

void main() => runApp(lessonApp);

// Survives when nobody is listening.
class Session extends Notifier<String?> {
  @override
  String? build() {
    ref.keepAlive();
    return null;
  }

  void login(String name) => state = name;
  void logout() => state = null;
}

// Same thing without keepAlive: it resets once unwatched.
class TempSession extends Notifier<String?> {
  @override
  String? build() => null;

  void login(String name) => state = name;
  void logout() => state = null;
}

final sessionProvider = NotifierProvider.autoDispose<Session, String?>(
  Session.new,
);
final tempSessionProvider = NotifierProvider.autoDispose<TempSession, String?>(
  TempSession.new,
);

class Lesson46KeepAliveSession extends StatefulWidget {
  const Lesson46KeepAliveSession({super.key});

  @override
  State<Lesson46KeepAliveSession> createState() =>
      _Lesson46KeepAliveSessionState();
}

class _Lesson46KeepAliveSessionState extends State<Lesson46KeepAliveSession> {
  int tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Session'),
        actions: const [LessonInfoButton(lessonId: 46)],
      ),
      // Only the current tab is built, so Profile stops listening when hidden.
      body: tab == 0 ? const ProfileTab() : const OtherTab(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (i) => setState(() => tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          NavigationDestination(icon: Icon(Icons.apps), label: 'Other'),
        ],
      ),
    );
  }
}

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kept = ref.watch(sessionProvider);
    final temp = ref.watch(tempSessionProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          leading: const Icon(Icons.lock),
          title: const Text('Session (keepAlive)'),
          subtitle: Text(kept ?? 'Signed out'),
        ),
        ListTile(
          leading: const Icon(Icons.timer_outlined),
          title: const Text('Temp session (auto-dispose)'),
          subtitle: Text(temp ?? 'Signed out'),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: FilledButton(
                onPressed: () {
                  ref.read(sessionProvider.notifier).login('Ada');
                  ref.read(tempSessionProvider.notifier).login('Ada');
                },
                child: const Text('Log in'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  ref.read(sessionProvider.notifier).logout();
                  ref.read(tempSessionProvider.notifier).logout();
                },
                child: const Text('Log out'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class OtherTab extends StatelessWidget {
  const OtherTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Nothing here watches the session.\nNow go back to Profile.',
        textAlign: TextAlign.center,
      ),
    );
  }
}
```
