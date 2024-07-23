import "package:flutter/material.dart";

/// Shows an adaptive circular progress indicator
class DefaultLoader extends StatelessWidget {
  ///
  const DefaultLoader({super.key});

  /// Builder definition for providing a loading indicator implementation
  static Widget builder(
    BuildContext context,
  ) =>
      const DefaultLoader();

  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator.adaptive());
}
