import "package:flutter/material.dart";
import "package:flutter_availability/src/service/errors.dart";

///
class DefaultErrorDisplayDialog extends StatelessWidget {
  ///
  const DefaultErrorDisplayDialog({
    required AvailabilityError error,
    super.key,
  }) : _error = error;

  final AvailabilityError _error;

  ///
  static Future<void> defaultErrorDisplay(
    BuildContext context,
    AvailabilityError error,
  ) async {
    await showAdaptiveDialog(
      context: context,
      builder: (context) => DefaultErrorDisplayDialog(error: error),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            Text(_error.name),
            const SizedBox(height: 20),
            Text(_error.description),
          ],
        ),
      );
}
