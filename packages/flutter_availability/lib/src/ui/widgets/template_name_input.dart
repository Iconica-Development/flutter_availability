import "package:flutter/material.dart";
import "package:flutter_availability/src/util/scope.dart";

/// Input section for the template name
class TemplateNameInput extends StatelessWidget {
  ///
  const TemplateNameInput({
    required this.initialValue,
    required this.onNameChanged,
    super.key,
  });

  /// The initial value for the template name
  final String? initialValue;

  /// callback for when the template name is changed
  final void Function(String) onNameChanged;

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
        Text(
          translations.templateTitleLabel,
          style: textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            hintText: translations.templateTitleHintText,
            hintStyle: theme.inputDecorationTheme.hintStyle,
            counterText: "",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          maxLength: 100,
          initialValue: initialValue,
          style: options.textStyles.inputFieldTextStyle,
          onChanged: onNameChanged,
        ),
      ],
    );
  }
}
