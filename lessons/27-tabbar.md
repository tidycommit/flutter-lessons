# Lesson 27: Tabs with TabBar, TabBarView, and DefaultTabController

**Date:** Oct 16, 2026

This is lesson 7 of the navigation series.

Yesterday's bottom bar switched tabs at the bottom of the screen. Today's tabs sit at the top, right under the AppBar title, and you can swipe left or right between them.

Three widgets work together:

- `DefaultTabController` wraps the screen and remembers which tab is selected, so you don't need a `StatefulWidget` or `setState`.
- `TabBar` is the row of tab buttons, and you place it in the AppBar's `bottom` slot.
- `TabBarView` holds one page per tab and shows whichever tab is selected.

The one rule is that the counts must match. If `length` is 3, the `TabBar` needs exactly three `Tab` widgets and the `TabBarView` needs exactly three children, in the same order.

Tapping a tab slides to its page, swiping the page moves the underline in the tab bar, and no new route is pushed, so there's no back arrow.

## Key points

- `DefaultTabController(length: 3, child: ...)` wraps the screen and remembers the selected tab; no `StatefulWidget` or `setState` needed.
- `TabBar(tabs: [...])` goes in the AppBar's `bottom` slot.
- `TabBarView(children: [...])` shows one page per tab.
- The counts must match: `length`, the number of `Tab`s and the number of `TabBarView` children, in the same order.
- Tap a tab or swipe the page; either way no route is pushed, so there's no back arrow.

## Code

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: TabsScreen());
  }
}

class TabsScreen extends StatelessWidget {
  const TabsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tabs Tip'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.directions_car), text: 'Car'),
              Tab(icon: Icon(Icons.directions_bike), text: 'Bike'),
              Tab(icon: Icon(Icons.directions_walk), text: 'Walk'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Driving: 10 min')),
            Center(child: Text('Biking: 25 min')),
            Center(child: Text('Walking: 50 min')),
          ],
        ),
      ),
    );
  }
}
```

## On screen

The AppBar says Tabs Tip, and right under the title is a row of three tabs: a car icon labeled Car, a bike icon labeled Bike, and a walking person labeled Walk. Car starts selected, with a colored underline, and the page shows "Driving: 10 min" in the center. Tapping Bike slides the page over to "Biking: 25 min" and moves the underline under Bike. Swiping left from there shows "Walking: 50 min" and highlights Walk. There's no back arrow within the lesson itself, because switching tabs doesn't open a new screen.

## How it is adapted in this app

- `main()` and `MyApp` are dropped; the app already has its `MaterialApp` in `lib/main.dart`. Colors therefore follow the app's theme rather than the plain `MaterialApp` default.
- `TabsScreen` is renamed `Lesson27Tabs`.
- The AppBar keeps `title: const Text('Tabs Tip')` and the `TabBar` in its `bottom` slot, and gets `actions: const [LessonInfoButton(lessonId: 27)]`, the button that opens these notes.
- The standalone version has no back arrow: `TabsScreen` is the app's only screen, and switching tabs pushes nothing. In this app the lesson screen is pushed from the lesson list, so its AppBar shows a back arrow that leads to the list. Switching tabs still pushes nothing, so that one arrow always goes straight back to the list, whichever tab is selected.

## Example

This is the runnable example in `lib/lessons/27_tabbar.dart`:

```dart
///
/// Switching tabs pushes no route, so the AppBar's back arrow always leads
/// straight back to the lesson list.
class Lesson27Tabs extends StatelessWidget {
  const Lesson27Tabs({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tabs Tip'),
          actions: const [LessonInfoButton(lessonId: 27)],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.directions_car), text: 'Car'),
              Tab(icon: Icon(Icons.directions_bike), text: 'Bike'),
              Tab(icon: Icon(Icons.directions_walk), text: 'Walk'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Driving: 10 min')),
            Center(child: Text('Biking: 25 min')),
            Center(child: Text('Walking: 50 min')),
          ],
        ),
      ),
    );
  }
}
```
