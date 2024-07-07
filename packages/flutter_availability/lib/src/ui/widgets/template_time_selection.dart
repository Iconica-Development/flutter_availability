import "package:flutter/material.dart";
import "package:flutter_availability/src/ui/widgets/input_fields.dart";
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
  final DateTime? startTime;

  ///
  final DateTime? endTime;

  ///
  final void Function(DateTime) onStartChanged;

  ///
  final void Function(DateTime) onEndChanged;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var availabilityScope = AvailabilityScope.of(context);
    var options = availabilityScope.options;
    var translations = options.translations;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(translations.time, style: textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(translations.templateTimeLabel, style: textTheme.bodyMedium),
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
