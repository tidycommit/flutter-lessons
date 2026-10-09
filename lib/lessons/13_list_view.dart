import 'package:flutter/material.dart';

/// Lesson 13: A scrolling ListView with three ListTiles.
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
