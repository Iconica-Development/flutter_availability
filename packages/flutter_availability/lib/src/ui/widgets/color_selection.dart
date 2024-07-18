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
            for (var color in colors.templateColors)
              GestureDetector(
                onTap: () => _onColorClick(color),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: options.borderRadius,
                    border: Border.all(
                      color: color.value == selectedColor
                          ? Colors.black
                          : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: selectedColor == color.value
                      ? const Icon(Icons.check)
                      : null,
                ),
              ),
          ],
        ),
      ],
    );
  }

  /// If the color is selected, deselect it, otherwise select it
  void _onColorClick(Color color) => onColorSelected(
        color.value == selectedColor ? null : color.value,
      );
}
