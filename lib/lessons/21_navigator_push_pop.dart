import 'package:flutter/material.dart';

/// Lesson 21: Moving between screens with Navigator.push and Navigator.pop.
class Lesson21Home extends StatelessWidget {
  const Lesson21Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // The lesson screen above already has a back arrow, so this
        // nested AppBar does not add a second one.
        automaticallyImplyLeading: false,
        title: const Text('Home'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Pushes onto the app's navigator, so Details covers the
            // whole screen and its back arrow returns here.
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) => const Lesson21Details(),
              ),
            );
          },
          child: const Text('Open details'),
        ),
      ),
    );
  }
}

class Lesson21Details extends StatelessWidget {
  const Lesson21Details({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Go back'),
        ),
      ),
    );
  }
}
