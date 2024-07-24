import "dart:math";

import "package:flutter/material.dart";
import "package:flutter_availability/src/util/scope.dart";

/// Widget for selecting a color for a template
/// All available colors for the templates are displayed in a wrap layout
class TemplateColorSelection extends StatelessWidget {
  ///
  const TemplateColorSelection({
    required this.selectedColor,
    required this.onColorSelected,
    super.key,
  });

  /// The selected color for the template
  /// If null, no color is selected
  final int? selectedColor;

  /// Callback for when a color is selected or deselected
  final void Function(int?) onColorSelected;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var availabilityScope = AvailabilityScope.of(context);
    var options = availabilityScope.options;
    var translations = options.translations;
    var colors = options.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translations.templateColorLabel,
          style: textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (var color in colors.templateColors) ...[
              _TemplateColorItem(
                color: color,
                selectedColor: selectedColor,
                onColorSelected: onColorSelected,
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _TemplateColorItem extends StatelessWidget {
  const _TemplateColorItem({
    required this.color,
    required this.selectedColor,
    required this.onColorSelected,
  });

  /// Callback for when a color is selected or deselected
  final void Function(int?) onColorSelected;

  final Color color;

  final int? selectedColor;

  @override
  Widget build(BuildContext context) {
    var availabilityScope = AvailabilityScope.of(context);
    var options = availabilityScope.options;
    var colors = options.colors;

    /// If the color is selected, deselect it, otherwise select it
    void onColorClick(Color color) => onColorSelected(
          color.value == selectedColor ? null : color.value,
        );

    var checkMarkColor = _hasHighContrast(color)
        ? colors.templateColorLightCheckmarkColor
        : colors.templateColorDarkCheckmarkColor;

    var icon = selectedColor == color.value
        ? Icon(Icons.check, color: checkMarkColor)
        : null;

    return GestureDetector(
      onTap: () => onColorClick(color),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          borderRadius: options.borderRadius,
        ),
        child: icon,
      ),
    );
  }
}

/// Computes the relative luminance of a color
/// This is following the formula from the WCAG guidelines
double _relativeLuminance(Color color) {
  double channelLuminance(int channel) {
    var c = channel / 255.0;
    return c <= 0.03928 ? c / 12.92 : pow((c + 0.055) / 1.055, 2.4).toDouble();
  }

  return 0.2126 * channelLuminance(color.red) +
      0.7152 * channelLuminance(color.green) +
      0.0722 * channelLuminance(color.blue);
}

/// Computes the contrast ratio between two colors
/// This is following the formula from the WCAG guidelines
double _contrastRatio(Color color1, Color color2) {
  var luminance1 = _relativeLuminance(color1);
  var luminance2 = _relativeLuminance(color2);
  if (luminance1 > luminance2) {
    return (luminance1 + 0.05) / (luminance2 + 0.05);
  } else {
    return (luminance2 + 0.05) / (luminance1 + 0.05);
  }
}

/// Returns true if the color has high contrast with white
/// This is following the WCAG guidelines
bool _hasHighContrast(Color color) {
  const white = Color(0xFFFFFFFF);
  return _contrastRatio(color, white) > 4.5;
}
