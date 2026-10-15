# Lesson 26: BottomNavigationBar

**Date:** Oct 15, 2026

This is lesson 6 of the navigation series.

So far you've been stacking screens with `Navigator.push`. A `BottomNavigationBar` works differently: the bar stays put at the bottom, and tapping an item swaps the body in place.

You keep a selected index in a `StatefulWidget`, point `body` at the page for that index, and in `onTap` call `setState` so the highlight and the content update together. No new route is pushed, so there is no back stack to unwind between tabs.

## Key points

- The bar stays put at the bottom; tapping an item swaps the body in place.
- Keep the selected index (`_currentIndex`) in a `StatefulWidget`.
- Point `body` (and here the AppBar title too) at the page for that index, and pass the index to `currentIndex` so the right item is highlighted.
- `onTap: (index) => setState(() => _currentIndex = index)` updates the highlight and the content together.
- No new route is pushed, so there is no back stack between tabs.

## Code

```dart
import 'package:flutter/material.dart';

class BottomNavLesson extends StatefulWidget {
  const BottomNavLesson({super.key});

  @override
  State<BottomNavLesson> createState() => _BottomNavLessonState();
}

class _BottomNavLessonState extends State<BottomNavLesson> {
  int _currentIndex = 0;

  static const _titles = ['Home', 'Search', 'Profile'];
  static const _bodies = ['Home page', 'Search page', 'Profile page'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_currentIndex])),
      body: Center(
        child: Text(
          _bodies[_currentIndex],
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
```

## On screen

The AppBar title matches the selected tab: Home, Search or Profile. The centered body text says "Home page", "Search page" or "Profile page". The bottom bar has three items: a house (Home), a magnifying glass (Search) and a person (Profile). Home starts selected. Tapping Search or Profile moves the highlight and changes the AppBar title and the body text, without sliding to a new screen.

## How it is adapted in this app

The snippet is already a widget with no `main()` or `runApp()`, so the in-app version is almost the same.

- The class is renamed `Lesson26BottomNav` (state class `_Lesson26BottomNavState`), following the naming of the other navigation lessons.
- The AppBar keeps its changing title, `Text(_titles[_currentIndex])`, and gets `actions: const [LessonInfoButton(lessonId: 26)]`, the button that opens these notes.
- The lesson screen is the pushed route, so the AppBar shows the back arrow to the lesson list. Switching tabs pushes nothing, so that arrow always leads straight back to the list.
- The three `BottomNavigationBarItem`s are formatted one per line; they are unchanged otherwise.

## Example

This is the runnable example in `lib/lessons/26_bottom_navigation_bar.dart`:

```dart
///
/// Tapping an item swaps the body in place; no route is pushed, so the
/// AppBar's back arrow still leads to the lesson list.
class Lesson26BottomNav extends StatefulWidget {
  const Lesson26BottomNav({super.key});

  @override
  State<Lesson26BottomNav> createState() => _Lesson26BottomNavState();
}

class _Lesson26BottomNavState extends State<Lesson26BottomNav> {
  int _currentIndex = 0;

  static const _titles = ['Home', 'Search', 'Profile'];
  static const _bodies = ['Home page', 'Search page', 'Profile page'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        actions: const [LessonInfoButton(lessonId: 26)],
      ),
      body: Center(
        child: Text(
          _bodies[_currentIndex],
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
```
