import "package:flutter/material.dart";
import "package:flutter_availability/src/util/scope.dart";
import "package:flutter_availability_data_interface/flutter_availability_data_interface.dart";

/// Selection of the template to use for the availability
///
/// This can show multiple templates when the user selects a date range.
/// When updating the templates for a date range where there are multiple
/// different templates used, the user first needs to remove the existing
/// templates.
class AvailabilityTemplateSelection extends StatelessWidget {
  /// Constructor
  const AvailabilityTemplateSelection({
    required this.selectedTemplates,
    required this.onTemplateAdd,
    required this.onTemplatesRemoved,
    super.key,
  });

  /// The currently selected templates
  final List<AvailabilityTemplateModel> selectedTemplates;

  /// Callback for when the user selects a template
  final VoidCallback onTemplateAdd;

  /// Callback for when the user wants to remove the templates
  /// There might be multiple templates and they can only be removed all at once
  final VoidCallback onTemplatesRemoved;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var availabilityScope = AvailabilityScope.of(context);
    var options = availabilityScope.options;
    var translations = options.translations;

    // TODO(Joey): Do not nest ternairy operators
    var titleText = selectedTemplates.isEmpty
        ? translations.availabilityAddTemplateTitle
        : selectedTemplates.length > 1
            ? translations.availabilityUsedTemplates
            : translations.availabilityUsedTemplate;

    var addButton = options.bigTextButtonWrapperBuilder(
      context,
      onTemplateAdd,
      options.bigTextButtonBuilder(
        context,
        onTemplateAdd,
        Text(translations.addButton),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleText,
          style: textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        if (selectedTemplates.isEmpty) ...[
          addButton,
        ] else ...[
          // TODO(Joey): Extract this as a widget
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.colorScheme.primary,
                width: 1,
              ),
              // TODO(Joey): This seems like a repeating borderRadius. I can
              // understand if these are not configurable, but I do think that
              // they should be defined only once.
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var template in selectedTemplates) ...[
                      // TODO(Joey): Extract this as a widget
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Color(template.color),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(template.name, style: textTheme.bodyLarge),
                        ],
                      ),
                      if (template != selectedTemplates.last)
                        const SizedBox(height: 12),
                    ],
                  ],
                ),
                GestureDetector(
                  onTap: onTemplatesRemoved,
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
