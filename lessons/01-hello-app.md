# Lesson 01: Hello app

**Date:** Sep 20, 2026

Every Flutter app starts in `main()`, which calls `runApp()` with a root widget. That root is usually a `MaterialApp`, which sets up theming, navigation and text direction for everything below it. Whatever you pass as `home` becomes the first screen.

A standalone version of this lesson looks like this:

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Hello')),
        body: Center(child: Text('Hello, world!')),
      ),
    ),
  );
}
```

In this repo the `MaterialApp` lives in `lib/main.dart`, so each lesson only provides the widget that goes on screen. Here that is a `StatelessWidget` whose `build` method returns a `Scaffold` with an AppBar and a centered `Text`.

## Key points

- `runApp()` inflates the root widget and attaches it to the screen.
- `MaterialApp` provides the theme, navigator and other app-wide services.
- A `StatelessWidget` describes UI that depends only on its constructor arguments.

## Code

AppBar title supplied by the teacher; the original full code wasn't available.

```dart
class HelloAppLesson extends StatelessWidget {
  const HelloAppLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hello')),
      body: const Center(
        child: Text('Hello, world!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
```

## How it is adapted in this app

- The example's `Scaffold` is the pushed route, so its AppBar shows the back arrow to the lesson list automatically.
- The only addition is `actions: const [LessonInfoButton(lessonId: 1)]` on the AppBar, the button that opens these notes.

## Example

This is the runnable example in `lib/lessons/01_hello_app.dart`:

```dart
class HelloAppLesson extends StatelessWidget {
  const HelloAppLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello'),
        actions: const [LessonInfoButton(lessonId: 1)],
      ),
      body: const Center(
        child: Text('Hello, world!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
```
