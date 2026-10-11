# Lesson 22: Passing data to a new screen through its constructor

**Date:** Oct 11, 2026

This is lesson 2 of the navigation series.

Yesterday you opened a new screen with `Navigator.push`. Most of the time, though, the new screen needs to know something, like which item you tapped. The simplest way is to hand it over the same way you'd give any widget its settings: through its constructor.

The new screen declares a `final` field (here, `name`), marks it `required` in the constructor, and then uses it in its `build` method like any other variable. On the first screen, you build the new screen inside `MaterialPageRoute`'s `builder` and pass in the value right there, as in `FruitDetailScreen(name: fruit)`.

Each tap creates a fresh detail screen with its own data, so one screen class can show Apple, Banana, or Cherry without any extra code.

## Key points

- Declare the data as a `final` field on the new screen.
- Mark it `required` in the constructor so it can't be forgotten.
- Pass the value when you build the screen in `MaterialPageRoute`'s `builder`.
- One screen class serves every item; each push gets its own copy of the data.

## Code

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: FruitListScreen()));

class FruitListScreen extends StatelessWidget {
  const FruitListScreen({super.key});

  static const fruits = ['Apple', 'Banana', 'Cherry'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fruits')),
      body: ListView(
        children: [
          for (final fruit in fruits)
            ListTile(
              title: Text(fruit),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FruitDetailScreen(name: fruit),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class FruitDetailScreen extends StatelessWidget {
  const FruitDetailScreen({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Center(
        child: Text(
          'You picked $name!',
          style: const TextStyle(fontSize: 28),
        ),
      ),
    );
  }
}
```

## On screen

The first screen has an AppBar titled Fruits and a list of three rows (Apple, Banana, Cherry), each with an arrow on the right. Tapping a row, say Banana, slides in a second screen whose AppBar reads Banana with a back arrow, and the middle says "You picked Banana!" in large text. The back arrow returns to the list, and tapping Cherry instead shows "You picked Cherry!".

## How it is adapted in this app

Inside this app the lesson screen is `Lesson22FruitList`'s own `Scaffold`, and the app's `MaterialApp` lives in `lib/main.dart`. The behavior is the same, with these changes:

- There is no `main()` or `runApp()`; tapping the lesson opens the fruit list directly.
- The classes are named `Lesson22FruitList` and `Lesson22FruitDetail` so they don't clash with other screens in the app. The titles and text are unchanged.
- The Fruits AppBar is the pushed route's AppBar, so it shows a back arrow that returns to the lesson list. It also has `actions: const [LessonInfoButton(lessonId: 22)]`, the button that opens these notes.
- The detail screen is pushed on the app's navigator, and its back arrow returns to the fruit list.

## Example

This is the runnable example in `lib/lessons/22_passing_data.dart`:

```dart
class Lesson22FruitList extends StatelessWidget {
  const Lesson22FruitList({super.key});

  static const fruits = ['Apple', 'Banana', 'Cherry'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fruits'),
        actions: const [LessonInfoButton(lessonId: 22)],
      ),
      body: ListView(
        children: [
          for (final fruit in fruits)
            ListTile(
              title: Text(fruit),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Pushes onto the app's navigator; the detail screen's
                // back arrow returns here.
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => Lesson22FruitDetail(name: fruit),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class Lesson22FruitDetail extends StatelessWidget {
  const Lesson22FruitDetail({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Center(
        child: Text('You picked $name!', style: const TextStyle(fontSize: 28)),
      ),
    );
  }
}
```
