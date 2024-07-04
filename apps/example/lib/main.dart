import "package:flutter/material.dart";
import "package:flutter_availability/flutter_availability.dart";

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        home: Home(),
      );
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) => availabilityNavigatorUserStory(
        context,
      );
}
