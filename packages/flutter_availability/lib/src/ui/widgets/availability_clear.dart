import "package:flutter/material.dart";
import "package:flutter_availability/src/util/scope.dart";

///
class AvailabilityClearSection extends StatelessWidget {
  ///
  const AvailabilityClearSection({
    required this.range,
    required this.clearAvailable,
    required this.onChanged,
    super.key,
  });

  /// The date range for which the availabilities can be cleared
  /// If the range is a single day, the range will be formatted as a single day
  /// If the range is multiple days, the range will be formatted as a period
  final DateTimeRange range;

  /// Whether the clear available checkbox should be checked
  final bool clearAvailable;

  /// Callback for when the clear available checkbox is toggled
  // ignore: avoid_positional_boolean_parameters
  final void Function(bool isChecked) onChanged;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var availabilityScope = AvailabilityScope.of(context);
    var options = availabilityScope.options;
    var translations = options.translations;

    var isSingleDay = range.start.isAtSameMomentAs(range.end);

    var titleText = isSingleDay
        ? translations.dayMonthFormatter(context, range.start)
        : translations.periodFormatter(context, range);
    var unavailableText = isSingleDay
        ? translations.unavailableForDay
        : translations.unavailableForMultipleDays;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleText,
          style: textTheme.titleMedium,
        ),
        Row(
          children: [
            Checkbox(
              value: clearAvailable,
              onChanged: (value) {
                if (value == null) return;
                onChanged(value);
              },
            ),
            Text(
              unavailableText,
              style: textTheme.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }
}
