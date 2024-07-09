import "package:flutter/material.dart";
import "package:flutter_availability/src/service/availability_service.dart";
import "package:flutter_availability/src/util/scope.dart";

/// This shows all the templates of a given month and an option to navigate to
/// the template overview
class TemplateLegend extends StatefulWidget {
  ///
  const TemplateLegend({
    required this.availabilities,
    required this.onViewTemplates,
    super.key,
  });

  /// The stream of availabilities with templates for the current month
  final AsyncSnapshot<List<AvailabilityWithTemplate>> availabilities;

  /// Callback for when the user wants to navigate to the overview of templates
  final VoidCallback onViewTemplates;

  @override
  State<TemplateLegend> createState() => _TemplateLegendState();
}

class _TemplateLegendState extends State<TemplateLegend> {
  bool _templateDrawerOpen = false;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var colorScheme = theme.colorScheme;
    var availabilityScope = AvailabilityScope.of(context);
    var options = availabilityScope.options;
    var colors = options.colors;
    var translations = options.translations;

    var templatesLoading =
        widget.availabilities.connectionState == ConnectionState.waiting;
    var templatesAvailable =
        !templatesLoading && (widget.availabilities.data?.isNotEmpty ?? false);
    var templates = widget.availabilities.data?.getUniqueTemplates() ?? [];

    void onDrawerHeaderClick() {
      if (!templatesAvailable && !_templateDrawerOpen) {
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
        // a button to open/close a drawer with all the templates
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
                if ((templatesAvailable && !templatesLoading) ||
                    _templateDrawerOpen) ...[
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
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          // TODO(freek): Animation should be used so it doesn't instantly close
          constraints: BoxConstraints(maxHeight: _templateDrawerOpen ? 150 : 0),
          decoration: BoxDecoration(
            border: _templateDrawerOpen
                ? Border.all(color: theme.colorScheme.onSurface, width: 1)
                : null,
          ),
          padding: const EdgeInsets.only(right: 2),
          child: _templateDrawerOpen && !templatesLoading
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        constraints: const BoxConstraints(
                          maxHeight: 150,
                        ),
                        child: Scrollbar(
                          controller: _scrollController,
                          thumbVisibility: true,
                          trackVisibility: true,
                          thickness: 2,
                          child: ListView.builder(
                            controller: _scrollController,
                            shrinkWrap: true,
                            itemCount: templates.length + 2,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return _TemplateLegendItem(
                                  name: translations.templateSelectionLabel,
                                  backgroundColor: colors.selectedDayColor ??
                                      colorScheme.primaryFixedDim,
                                  borderColor: colorScheme.primary,
                                );
                              }
                              if (index == templates.length + 1) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                    bottom: 8,
                                  ),
                                  child: createNewTemplateButton,
                                );
                              }
                              var template = templates[index - 1];
                              return _TemplateLegendItem(
                                name: template.name,
                                backgroundColor: Color(template.color),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const Divider(
                  height: 1,
                  thickness: 1,
                ),
        ),
        if (!templatesAvailable &&
            (!_templateDrawerOpen || templatesLoading)) ...[
          const SizedBox(height: 12),
          if (templatesLoading) ...[
            const CircularProgressIndicator.adaptive(),
          ] else ...[
            createNewTemplateButton,
          ],
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
