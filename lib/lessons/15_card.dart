import 'package:flutter/material.dart';

/// Lesson 15: A Card holding a ListTile with a person icon, name and role.
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
