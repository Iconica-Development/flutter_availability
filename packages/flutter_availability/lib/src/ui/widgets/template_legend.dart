import "package:flutter/material.dart";
import "package:flutter_availability/src/util/scope.dart";
import "package:flutter_availability_data_interface/flutter_availability_data_interface.dart";

/// This shows all the templates of a given month and an option to navigate to
/// the template overview
class TemplateLegend extends StatefulWidget {
  ///
  const TemplateLegend({
    required this.templates,
    required this.onViewTemplates,
    super.key,
  });

  ///
  final List<AvailabilityTemplateModel> templates;

  /// Callback for when the user wants to navigate to the overview of templates
  final VoidCallback onViewTemplates;

  @override
  State<TemplateLegend> createState() => _TemplateLegendState();
}

class _TemplateLegendState extends State<TemplateLegend> {
  bool _templateDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var colorScheme = theme.colorScheme;
    var availabilityScope = AvailabilityScope.of(context);
    var options = availabilityScope.options;
    var colors = options.colors;
    var translations = options.translations;

    var templatesAvailable = widget.templates.isNotEmpty;

    void onDrawerHeaderClick() {
      if (!templatesAvailable) {
        return;
      }
      setState(() {
        _templateDrawerOpen = !_templateDrawerOpen;
      });
    }

    var createNewTemplateButton = GestureDetector(
      onTap: () => widget.onViewTemplates(),
      child: ColoredBox(
        color: Colors.transparent,
        child: Row(
          children: [
            const SizedBox(width: 12),
            const Icon(Icons.add, size: 20),
            const SizedBox(width: 6),
            Text(
              translations.createTemplateButton,
              style: textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
    return Column(
      children: [
        GestureDetector(
          onTap: onDrawerHeaderClick,
          child: ColoredBox(
            color: Colors.transparent,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  translations.templateLegendTitle,
                  style: textTheme.titleMedium,
                ),
                // a button to open a drawer with all the templates
                if (templatesAvailable) ...[
                  Icon(
                    _templateDrawerOpen
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        if (_templateDrawerOpen) ...[
          // show a container with all the templates with a max height and after
          // that scrollable but as small as possible
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.colorScheme.onSurface,
                width: 1,
              ),
            ),
            padding: const EdgeInsets.only(right: 2),
            child: Column(
              children: [
                Container(
                  constraints: const BoxConstraints(
                    maxHeight: 100,
                  ),
                  child: Scrollbar(
                    thumbVisibility: true,
                    trackVisibility: true,
                    thickness: 2,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.templates.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return _TemplateLegendItem(
                            name: translations.templateSelectionLabel,
                            backgroundColor: colors.selectedDayColor ??
                                colorScheme.primaryFixedDim,
                            borderColor: colorScheme.primary,
                          );
                        }
                        var template = widget.templates[index - 1];
                        return _TemplateLegendItem(
                          name: template.name,
                          backgroundColor: Color(template.color),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                createNewTemplateButton,
                const SizedBox(height: 8),
              ],
            ),
          ),
        ] else ...[
          const Divider(height: 1),
        ],
        if (!templatesAvailable) ...[
          const SizedBox(height: 12),
          createNewTemplateButton,
        ],
      ],
    );
  }
}

class _TemplateLegendItem extends StatelessWidget {
  const _TemplateLegendItem({
    required this.name,
    required this.backgroundColor,
    this.borderColor,
  });

  final String name;

  final Color backgroundColor;

  final Color? borderColor;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(
          top: 10,
          left: 12,
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: borderColor ?? Colors.transparent,
                ),
              ),
              width: 20,
              height: 20,
            ),
            const SizedBox(width: 6),
            Text(name, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      );
}
