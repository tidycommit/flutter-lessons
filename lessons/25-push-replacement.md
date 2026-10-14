# Lesson 25: Leaving screens behind with pushReplacement and pushAndRemoveUntil

**Date:** Oct 14, 2026

This is lesson 5 of the navigation series.

Think of navigation as a stack of cards. Every `Navigator.push` puts a new card on top, and the back arrow takes the top card off again.

Sometimes a screen shouldn't stay in the stack. After logging in, the Login screen shouldn't sit under Home, waiting for someone to press back. So `Navigator.pushReplacement` swaps Login for Home: Home takes Login's place, and because there is nothing underneath it, Home gets no back arrow.

Logging out is the other direction. `Navigator.pushAndRemoveUntil(context, route, (route) => false)` pushes Login and clears everything beneath it. The last argument is asked about each screen below; answering `false` every time means "remove them all", so Login ends up alone, again with no back arrow.

An easy way to remember them: replacement means "move forward, no coming back"; remove-until means "start fresh".

## Key points

- Navigation is a stack: `push` adds a screen on top, back removes it.
- `Navigator.pushReplacement(context, route)` swaps the current screen for a new one, so there is nothing to go back to.
- `Navigator.pushAndRemoveUntil(context, route, (route) => false)` pushes a screen and clears every screen beneath it.
- Replacement means "move forward, no coming back"; remove-until means "start fresh".

## Code

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Flow Demo',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Replace Login with Home: nothing to go back to.
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
          child: const Text('Log in'),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')), // no back arrow appears
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Welcome! You are logged in.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
              child: const Text('Open Settings'),
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
      appBar: AppBar(title: const Text('Settings')), // back arrow to Home
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Push Login and clear every screen beneath it.
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
            );
          },
          child: const Text('Log out'),
        ),
      ),
    );
  }
}
```

## On screen

The app opens on Login: an AppBar titled Login and a Log in button in the middle. Tapping Log in replaces Login with Home, which has an AppBar titled Home with no back arrow, the text "Welcome! You are logged in." and an Open Settings button. Open Settings pushes a Settings screen with a back arrow and a Log out button. Tapping Log out clears the stack back to Login, which again has no back arrow.

## How it is adapted in this app

A lesson can't own the app's `MaterialApp`; there is one, in `lib/main.dart`, and it runs the lesson list. Calling `pushReplacement` or `pushAndRemoveUntil` on that navigator would replace or wipe the lesson list itself. So, like lesson 24, this lesson uses a **nested `Navigator`** that plays the part of the snippet's `MaterialApp`, and the two calls only change the lesson's own stack.

- `MyApp` becomes `Lesson25LoginFlow`, which builds a `Navigator` whose first route is the Login screen. The snippet's `title` and `theme` (indigo seed, Material 3) are already the app's own, so the screens look the same.
- The screens are named `Lesson25Login`, `Lesson25Home` and `Lesson25Settings`. Their titles, text and buttons are unchanged, and they still call `Navigator.pushReplacement`, `Navigator.push` and `Navigator.pushAndRemoveUntil(..., (route) => false)`. Inside the nested `Navigator`, `Navigator.of(context)` finds that nested navigator.
- Home, and Login after logging out, have no back arrow on purpose, so the way back to the lesson list is not a back arrow. Login's and Home's AppBars get two actions: a list button (tooltip "Back to lessons") that pops the lesson off the app's navigator, and `LessonInfoButton(lessonId: 25)`, the button that opens these notes.
- Settings shows its own back arrow, which returns to Home.
- A `NavigatorPopHandler` makes the system or browser back button behave sensibly. On Settings it returns to Home. On Login or Home, which are alone in the lesson's stack, it leaves the lesson.

## Example

This is the runnable example in `lib/lessons/25_push_replacement.dart`:

```dart
///
/// Both calls rewrite the navigator's stack. On the app's root navigator they
/// would wipe the lesson list, so the lesson hosts its own nested Navigator
/// and only that stack is replaced or cleared.
class Lesson25LoginFlow extends StatefulWidget {
  const Lesson25LoginFlow({super.key});

  @override
  State<Lesson25LoginFlow> createState() => _Lesson25LoginFlowState();
}

class _Lesson25LoginFlowState extends State<Lesson25LoginFlow> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    // System and browser back pop the nested Navigator first (Settings back
    // to Home); on a screen that is alone in the stack they leave the lesson.
    return NavigatorPopHandler<Object?>(
      onPopWithResult: (_) => _navigatorKey.currentState!.maybePop(),
      child: Navigator(
        key: _navigatorKey,
        onGenerateRoute: (settings) => MaterialPageRoute<void>(
          builder: (context) => const Lesson25Login(),
          settings: settings,
        ),
      ),
    );
  }
}

/// Leaves the lesson for the lesson list. Login and Home have no back arrow
/// by design, so this sits in their AppBar actions instead of `leading`.
class Lesson25ExitButton extends StatelessWidget {
  const Lesson25ExitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.list),
      tooltip: 'Back to lessons',
      onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
    );
  }
}

class Lesson25Login extends StatelessWidget {
  const Lesson25Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        actions: const [Lesson25ExitButton(), LessonInfoButton(lessonId: 25)],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Replace Login with Home: nothing to go back to.
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Lesson25Home()),
            );
          },
          child: const Text('Log in'),
        ),
      ),
    );
  }
}

class Lesson25Home extends StatelessWidget {
  const Lesson25Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'), // no back arrow appears
        actions: const [Lesson25ExitButton(), LessonInfoButton(lessonId: 25)],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Welcome! You are logged in.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Lesson25Settings(),
                  ),
                );
              },
              child: const Text('Open Settings'),
            ),
          ],
        ),
      ),
    );
  }
}

class Lesson25Settings extends StatelessWidget {
  const Lesson25Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')), // back arrow to Home
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Push Login and clear every screen beneath it.
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Lesson25Login()),
              (route) => false,
            );
          },
          child: const Text('Log out'),
        ),
      ),
    );
  }
}
```
