import "package:flutter/material.dart";
import "package:flutter_availability/src/ui/widgets/generic_time_selection.dart";
import "package:flutter_availability/src/util/scope.dart";

///
class TemplateTimeSelection extends StatelessWidget {
  ///
  const TemplateTimeSelection({
    required this.startTime,
    required this.endTime,
    required this.onStartChanged,
    required this.onEndChanged,
    super.key,
  });

  ///
  final TimeOfDay? startTime;

  ///
  final TimeOfDay? endTime;

  ///
  final void Function(TimeOfDay) onStartChanged;

  ///
  final void Function(TimeOfDay) onEndChanged;

  @override
  Widget build(BuildContext context) {
    var availabilityScope = AvailabilityScope.of(context);
    var options = availabilityScope.options;
    var translations = options.translations;

    return TimeSelection(
      title: translations.time,
      description: translations.templateTimeLabel,
      startTime: startTime,
      endTime: endTime,
      onStartChanged: onStartChanged,
      onEndChanged: onEndChanged,
    );
  }
}
