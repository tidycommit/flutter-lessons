import 'package:flutter/material.dart';

/// Lesson 22: Passing data to a new screen through its constructor.
class Lesson22FruitList extends StatelessWidget {
  const Lesson22FruitList({super.key});

  static const fruits = ['Apple', 'Banana', 'Cherry'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // The lesson screen above already has a back arrow, so this
        // nested AppBar does not add a second one.
        automaticallyImplyLeading: false,
        title: const Text('Fruits'),
      ),
      body: ListView(
        children: [
          for (final fruit in fruits)
            ListTile(
              title: Text(fruit),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Pushes onto the app's navigator, so the detail screen
                // covers the whole screen and its back arrow returns here.
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
