# Lesson 13: ListView of ListTiles

**Date:** Oct 1, 2026

`ListView` is a scrolling list of widgets. The default constructor takes a fixed `children` list, which is fine for a handful of items. For long or unknown-length lists use `ListView.builder`, which only builds the rows that are on screen.

`ListTile` is a ready-made row with slots for `leading`, `title`, `subtitle` and `trailing` widgets, plus an `onTap` callback. It follows Material spacing so lists look consistent without extra layout code.

## Key points

- `ListView` scrolls automatically when its content is taller than the screen.
- Prefer `ListView.builder` for long lists.
- The home screen of this app is itself a `ListView` of `ListTile`s.

## Example

This is the runnable example in `lib/lessons/13_list_view.dart`:

```dart
class ListViewLesson extends StatelessWidget {
  const ListViewLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        ListTile(
          leading: Icon(Icons.local_grocery_store),
          title: Text('Apples'),
        ),
        ListTile(
          leading: Icon(Icons.local_grocery_store),
          title: Text('Bananas'),
        ),
        ListTile(
          leading: Icon(Icons.local_grocery_store),
          title: Text('Cherries'),
        ),
      ],
    );
  }
}
```
