import "package:flutter/material.dart";
import "package:flutter/services.dart";
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
      FocusManager.instance.primaryFocus?.unfocus();
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
class DurationInputField extends StatefulWidget {
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
  State<StatefulWidget> createState() => _DurationInputFieldState();
}

class _DurationInputFieldState extends State<DurationInputField> {
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _onFieldChanged(String value) {
    var duration = int.tryParse(value);
    if (duration != null) {
      widget.onDurationChanged(Duration(minutes: duration));
    } else {
      widget.onDurationChanged(null);
    }
  }

  void _showOverlay(BuildContext context) {
    _overlayEntry = _createOverlayEntry(context);
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry(BuildContext context) => OverlayEntry(
        builder: (context) => GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            _removeOverlay();
          },
          behavior: HitTestBehavior.translucent,
          child: Container(
            color: Colors.transparent,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var availabilityScope = AvailabilityScope.of(context);
    var options = availabilityScope.options;
    var translations = options.translations;

    return Focus(
      onFocusChange: (hasFocus) {
        if (hasFocus) {
          _showOverlay(context);
        } else {
          _removeOverlay();
        }
      },
      child: TextFormField(
        decoration: InputDecoration(
          labelText: translations.time,
          labelStyle: theme.inputDecorationTheme.hintStyle,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          suffixIcon: const Icon(Icons.access_time),
        ),
        initialValue: widget.initialValue?.inMinutes.toString(),
        keyboardType: TextInputType.number,
        style: options.textStyles.inputFieldTextStyle,
        onChanged: _onFieldChanged,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
      ),
    );
  }
}
