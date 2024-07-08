import "package:device_preview/device_preview.dart";
import "package:flutter/material.dart";
import "package:flutter_availability/flutter_availability.dart";

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      isToolbarVisible: true,
      availableLocales: const [
        Locale("en_US"),
        Locale("nl_NL"),
      ],
      builder: (_) => const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        builder: DevicePreview.appBuilder,
        locale: DevicePreview.locale(context),
        supportedLocales: const [
          Locale("en", "US"),
          Locale("nl", "NL"),
        ],
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
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
            await openAvailabilitiesForUser(context, "", null);
            debugPrint("finishing availability user story");
          },
        ),
      );
}
