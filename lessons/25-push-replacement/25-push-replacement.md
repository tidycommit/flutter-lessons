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

- This lesson is its own Flutter project. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` is a `LessonApp` from the shared `lesson_kit` package: a `MaterialApp` with the shared theme (the same indigo seed and Material 3 as the snippet) and the lesson heading as its title, whose `home` is `Lesson25Login`.
- The screens are named `Lesson25Login`, `Lesson25Home` and `Lesson25Settings`. Their titles, text and buttons are unchanged, and they still call `Navigator.pushReplacement` and `Navigator.pushAndRemoveUntil` on the app's own navigator, so both calls rewrite the real stack as in the snippet.
- Login's and Home's AppBars keep their titles and get `actions: const [LessonInfoButton(lessonId: 25)]`, the button that opens these notes. Neither has a back arrow, which is the point of the lesson.
- Settings shows its own back arrow, which returns to Home, and so does system or browser back.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 25,
  title: 'Leaving screens behind with pushReplacement and pushAndRemoveUntil',
  notesAsset: '25-push-replacement.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: Lesson25Login());

void main() => runApp(lessonApp);

/// Lesson 25: Leaving screens behind with `pushReplacement` and
/// `pushAndRemoveUntil`.
///
/// The project's `MaterialApp` (from `LessonApp`) has Login as its home, so
/// both calls rewrite the app's own stack, just as in the snippet.
class Lesson25Login extends StatelessWidget {
  const Lesson25Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        actions: const [LessonInfoButton(lessonId: 25)],
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
        actions: const [LessonInfoButton(lessonId: 25)],
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
