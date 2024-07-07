import "package:flutter/material.dart";
import "package:flutter_availability/src/util/scope.dart";

/// An input field for time selection
class TimeInputField extends StatelessWidget {
  ///
  const TimeInputField({
    required this.initialValue,
    required this.onTimeChanged,
    super.key,
  });

  ///
  final DateTime? initialValue;

  ///
  final void Function(DateTime) onTimeChanged;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var availabilityScope = AvailabilityScope.of(context);
    var options = availabilityScope.options;
    var translations = options.translations;

    Future<void> onFieldtap() async {
      var time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialValue ?? DateTime.now()),
      );
      if (time != null) {
        onTimeChanged(
          DateTime(
            initialValue?.year ?? DateTime.now().year,
            initialValue?.month ?? DateTime.now().month,
            initialValue?.day ?? DateTime.now().day,
            time.hour,
            time.minute,
          ),
        );
      }
    }

    return TextFormField(
      decoration: InputDecoration(
        suffixIcon: const Icon(Icons.access_time),
        hintText: translations.time,
        hintStyle: theme.inputDecorationTheme.hintStyle,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      initialValue: initialValue != null
          ? translations.timeFormatter(context, initialValue!)
          : null,
      readOnly: true,
      style: options.textStyles.inputFieldTextStyle,
      onTap: onFieldtap,
    );
  }
}
