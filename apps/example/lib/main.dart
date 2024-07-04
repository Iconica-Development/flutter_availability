import "package:flutter/material.dart";
import "package:flutter_availability/flutter_availability.dart";

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: AvailabilityUserStory(
          userId: "",
          options: AvailabilityOptions(),
        ),
      );
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: const Center(
          child: Text("Hello World"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            debugPrint("starting availability user story");
            await openAvailabilitiesForUser(context, "anonymous", null);
            debugPrint("finishing availability user story");
          },
        ),
      );
}
