import "package:flutter/material.dart";
import "package:flutter_availability/src/util/scope.dart";

/// Default base screen for any availability screen
class DefaultBaseScreen extends StatelessWidget {

  /// Create a base screen
  const DefaultBaseScreen({
    required this.child,
    super.key,
  });
  /// Builder as default option
  static Widget builder(
    BuildContext context,
    VoidCallback onBack,
    Widget child,
  ) =>
      DefaultBaseScreen(child: child);

  /// Content of the page
  final Widget child;

  @override
  Widget build(BuildContext context) {
    var translations = AvailabilityScope.of(context).options.translations;
    return Scaffold(
      appBar: AppBar(
        title: Text(translations.appbarTitle),
      ),
      body: SafeArea(
        child: child,
      ),
    );
  }
}
