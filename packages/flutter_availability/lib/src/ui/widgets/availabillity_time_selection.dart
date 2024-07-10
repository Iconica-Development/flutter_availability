import "package:flutter/material.dart";
import "package:flutter_availability/src/ui/widgets/generic_time_selection.dart";
import "package:flutter_availability/src/util/scope.dart";

///
class AvailabilityTimeSelection extends StatelessWidget {
  ///
  const AvailabilityTimeSelection({
    required this.startTime,
    required this.endTime,
    required this.onStartChanged,
    required this.onEndChanged,
    required this.dateRange,
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

  /// The date range for which the availabilities are being managed
  final DateTimeRange dateRange;

  @override
  Widget build(BuildContext context) {
    var availabilityScope = AvailabilityScope.of(context);
    var options = availabilityScope.options;
    var translations = options.translations;

    var isSingleDay = dateRange.start.isAtSameMomentAs(dateRange.end);
    var titleText = isSingleDay
        ? translations.availabilityTimeTitle
        : translations.availabilitiesTimeTitle;

    return TimeSelection(
      title: titleText,
      description: null,
      startTime: startTime,
      endTime: endTime,
      onStartChanged: onStartChanged,
      onEndChanged: onEndChanged,
    );
  }
}
