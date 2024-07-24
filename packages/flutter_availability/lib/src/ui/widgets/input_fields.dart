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
  final TimeOfDay? initialValue;

  ///
  final void Function(TimeOfDay) onTimeChanged;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var availabilityScope = AvailabilityScope.of(context);
    var options = availabilityScope.options;
    var translations = options.translations;

    Future<void> onFieldtap() async {
      var initialTime = initialValue ?? TimeOfDay.now();
      var time = await (options.timePickerBuilder?.call(context, initialTime) ??
          showTimePicker(
            context: context,
            initialTime: initialTime,
          ));
      if (time != null) {
        onTimeChanged(time);
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

/// An input field for giving a duration in minutes
class DurationInputField extends StatelessWidget {
  ///
  const DurationInputField({
    required this.initialValue,
    required this.onDurationChanged,
    super.key,
  });

  ///
  final Duration? initialValue;

  ///
  final void Function(Duration?) onDurationChanged;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var availabilityScope = AvailabilityScope.of(context);
    var options = availabilityScope.options;
    var translations = options.translations;

    void onFieldChanged(String value) {
      var duration = int.tryParse(value);
      if (duration != null) {
        onDurationChanged(Duration(minutes: duration));
      } else {
        onDurationChanged(null);
      }
    }

    return TextFormField(
      decoration: InputDecoration(
        labelText: translations.time,
        labelStyle: theme.inputDecorationTheme.hintStyle,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: const Icon(Icons.access_time),
      ),
      initialValue: initialValue?.inMinutes.toString(),
      keyboardType: TextInputType.number,
      style: options.textStyles.inputFieldTextStyle,
      onChanged: onFieldChanged,
    );
  }
}
