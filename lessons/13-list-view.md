# Lesson 13: ListView of ListTiles

**Date:** Oct 1, 2026

`ListView` is a scrolling list of widgets. The default constructor takes a fixed `children` list, which is fine for a handful of items. For long or unknown-length lists use `ListView.builder`, which only builds the rows that are on screen.

`ListTile` is a ready-made row with slots for `leading`, `title`, `subtitle` and `trailing` widgets, plus an `onTap` callback. It follows Material spacing so lists look consistent without extra layout code.

## Key points

- `ListView` scrolls automatically when its content is taller than the screen.
- Prefer `ListView.builder` for long lists.
- The home screen of this app is itself a `ListView` of `ListTile`s.

## Code

Original snippet as taught:

```dart
Scaffold(
  appBar: AppBar(title: Text('My List')),
  body: ListView(
    children: [
      ListTile(title: Text('Apples')),
      ListTile(title: Text('Bananas')),
      ListTile(title: Text('Cherries')),
    ],
  ),
)
```

## How it is adapted in this app

- There is no `main()` or `runApp()`. The snippet's `Scaffold` is returned from the `build` method of `ListViewLesson`, a `StatelessWidget`.
- That `Scaffold` is the pushed route, so its AppBar shows the back arrow to the lesson list automatically.
- The AppBar gets `actions: const [LessonInfoButton(lessonId: 13)]`, the button that opens these notes.
- `const` is added where the analyzer asks for it, and the code is run through `dart format`. Nothing else changes.

## Example

This is the runnable example in `lib/lessons/13_list_view.dart`:

```dart
class ListViewLesson extends StatelessWidget {
  const ListViewLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My List'),
        actions: const [LessonInfoButton(lessonId: 13)],
      ),
      body: ListView(
        children: const [
          ListTile(title: Text('Apples')),
          ListTile(title: Text('Bananas')),
          ListTile(title: Text('Cherries')),
        ],
      ),
    );
  }
}
```
