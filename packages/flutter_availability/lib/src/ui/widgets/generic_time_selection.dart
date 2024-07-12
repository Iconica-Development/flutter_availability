import "package:flutter/material.dart";
import "package:flutter_availability/src/ui/widgets/input_fields.dart";
import "package:flutter_availability/src/util/scope.dart";

///
class TimeSelection extends StatelessWidget {
  ///
  const TimeSelection({
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.onStartChanged,
    required this.onEndChanged,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    super.key,
  });

  /// The title of the time selection
  final String title;

  /// The description of the time selection
  final String? description;

  /// the axis aligment for the column
  final CrossAxisAlignment crossAxisAlignment;

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
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var availabilityScope = AvailabilityScope.of(context);
    var options = availabilityScope.options;
    var translations = options.translations;

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(title, style: textTheme.titleMedium),
        if (description != null) ...[
          const SizedBox(height: 4),
          Text(
            description!,
            style: textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TimeInputField(
                initialValue: startTime,
                onTimeChanged: onStartChanged,
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                translations.timeSeparator,
                style: textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 2,
              child: TimeInputField(
                initialValue: endTime,
                onTimeChanged: onEndChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
