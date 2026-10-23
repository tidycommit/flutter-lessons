# Lesson 28: A Drawer menu that navigates

**Date:** Oct 17, 2026

This is lesson 8 of the navigation series.

A Drawer is the slide-out menu that appears from the left edge when you tap the three-line "hamburger" icon in the AppBar. You don't have to draw that icon yourself: as soon as you give a Scaffold a `drawer:`, Flutter adds the icon to the AppBar and wires it up, and you can also swipe in from the left edge to open it. Inside the `Drawer` you usually put a `ListView` with a `DrawerHeader` at the top and a `ListTile` for each menu item.

The one trick to remember is that an open drawer counts as something `Navigator.pop` can close. So when a menu item is tapped, call `Navigator.pop(context)` first to slide the drawer shut, then `Navigator.push` to open the new screen. If you skip the pop, the drawer is still open when you come back with the back arrow. For an item that just means "stay here" (like Home), a pop on its own is all you need.

## Key points

- Give the `Scaffold` a `drawer:` and Flutter adds the hamburger icon to the AppBar for you; swiping in from the left edge opens it too.
- Inside the `Drawer`, use a `ListView` (with `padding: EdgeInsets.zero`) holding a `DrawerHeader` and one `ListTile` per menu item.
- An open drawer is something `Navigator.pop` closes.
- For an item that opens a screen: `Navigator.pop(context)` first, then `Navigator.push`. Otherwise the drawer is still open when you come back.
- For a "stay here" item like Home, `Navigator.pop(context)` on its own is enough.

## Code

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomeScreen());
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openPage(BuildContext context, String title) {
    Navigator.pop(context); // close the drawer first
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PageScreen(title: title)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Drawer Tip')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => Navigator.pop(context), // just close it
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => _openPage(context, 'Settings'),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              onTap: () => _openPage(context, 'About'),
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('Tap the menu icon to open the drawer'),
      ),
    );
  }
}

class PageScreen extends StatelessWidget {
  const PageScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('This is the $title page')),
    );
  }
}
```

## On screen

The app opens on a screen with an AppBar titled "Drawer Tip" and a three-line menu icon on its left, plus centered text "Tap the menu icon to open the drawer". Tapping the icon (or swiping in from the left edge) slides out a white drawer over most of the screen, dimming the rest. It has a blue header reading "Menu" and three rows: a house icon with "Home", a gear with "Settings", and an info circle with "About". Tapping Home just slides the drawer closed. Tapping Settings closes the drawer and opens a new screen with an AppBar titled "Settings", a back arrow, and centered text "This is the Settings page". About works the same way with "This is the About page". The back arrow returns to the Drawer Tip screen with the drawer already closed.

## How it is adapted in this app

- This lesson is its own Flutter project. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` is a `LessonApp` from the shared `lesson_kit` package: a `MaterialApp` with the shared theme and the lesson heading as its title, whose `home` is `Lesson28Drawer`.
- `HomeScreen` is renamed `Lesson28Drawer` and `PageScreen` is renamed `Lesson28Page`. The drawer, its header, its three rows and `_openPage` are unchanged.
- The AppBar keeps `title: const Text('Drawer Tip')` with default styling, and gets `actions: const [LessonInfoButton(lessonId: 28)]`, the button that opens these notes. The hamburger stays in the leading slot, as in the snippet.
- Settings and About are pushed on top of the lesson screen, so their back arrow returns to Drawer Tip with the drawer closed, as in the snippet.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 28,
  title: 'A Drawer menu that navigates',
  notesAsset: '28-drawer.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: Lesson28Drawer());

void main() => runApp(lessonApp);

/// Lesson 28: A Drawer menu that navigates.
///
/// Giving the Scaffold a `drawer:` makes the hamburger icon the AppBar's
/// leading widget. The system or browser back button closes an open drawer
/// first, and returns from a pushed page to the drawer screen.
class Lesson28Drawer extends StatelessWidget {
  const Lesson28Drawer({super.key});

  void _openPage(BuildContext context, String title) {
    Navigator.pop(context); // close the drawer first
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => Lesson28Page(title: title)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drawer Tip'),
        actions: const [LessonInfoButton(lessonId: 28)],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => Navigator.pop(context), // just close it
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => _openPage(context, 'Settings'),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              onTap: () => _openPage(context, 'About'),
            ),
          ],
        ),
      ),
      body: const Center(child: Text('Tap the menu icon to open the drawer')),
    );
  }
}

class Lesson28Page extends StatelessWidget {
  const Lesson28Page({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('This is the $title page')),
    );
  }
}
```
