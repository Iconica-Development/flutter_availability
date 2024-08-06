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
        home: const Home(),
      );
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(
          child: Text("Start the user story by tapping the button below"),
        ),
        floatingActionButton: AvailabilityEntryWidget(),
      );
}
