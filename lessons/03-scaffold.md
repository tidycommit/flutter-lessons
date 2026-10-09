# Lesson 03: Scaffold

**Date:** Sep 21, 2026

`Scaffold` implements the basic Material page layout. It has named slots for the common parts of a screen: `appBar` at the top, `body` in the middle, and optional pieces such as `floatingActionButton`, `drawer` and `bottomNavigationBar`.

You fill only the slots you need and the Scaffold positions them for you. It also gives descendants a place to show snack bars and bottom sheets. The example nests a second Scaffold inside the lesson screen so its slots are easy to see.

## Key points

- `appBar` usually holds an `AppBar` with a title and actions.
- `body` takes the remaining space between the top and bottom bars.
- Most screens in an app start with a `Scaffold`.

## Example

This is the runnable example in `lib/lessons/03_scaffold.dart`:

```dart
class ScaffoldLesson extends StatelessWidget {
  const ScaffoldLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // The lesson screen already shows a back button.
        automaticallyImplyLeading: false,
        title: const Text('My page'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: const Center(child: Text('The body fills the space in between.')),
      bottomNavigationBar: const BottomAppBar(
        child: Center(child: Text('Bottom app bar')),
      ),
    );
  }
}
```
