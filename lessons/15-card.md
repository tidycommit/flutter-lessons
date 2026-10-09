# Lesson 15: Card with ListTile

**Date:** Oct 4, 2026

`Card` is a Material surface with rounded corners and a subtle elevation, used to group related information. It has no layout of its own; it simply wraps one child.

Putting a `ListTile` inside a `Card` is a quick way to build a contact or summary card: the tile handles the icon, title and subtitle layout, and the card gives it a background and edge. Change the look with `elevation`, `color`, `margin` and `shape`.

## Key points

- A `Card` takes a single `child`.
- `ListTile` inside a `Card` gives tidy spacing for free.
- Wrap the card content in `InkWell` or use `ListTile.onTap` to make it tappable.

## Example

This is the runnable example in `lib/lessons/15_card.dart`:

```dart
class CardLesson extends StatelessWidget {
  const CardLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text('Ada Lovelace'),
              subtitle: Text('Mathematician'),
            ),
          ),
        ],
      ),
    );
  }
}
```
