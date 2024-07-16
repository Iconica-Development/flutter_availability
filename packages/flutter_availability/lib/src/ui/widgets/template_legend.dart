import "package:flutter/material.dart";
import "package:flutter_availability/src/service/availability_service.dart";
import "package:flutter_availability/src/util/scope.dart";

/// This shows all the templates of a given month and an option to navigate to
/// the template overview
class TemplateLegend extends StatefulWidget {
  ///
  const TemplateLegend({
    required this.availabilitiesStream,
    required this.onViewTemplates,
    super.key,
  });

  /// The stream of availabilities with templates for the current month
  final Stream<List<AvailabilityWithTemplate>> availabilitiesStream;

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

    return StreamBuilder<List<AvailabilityWithTemplate>>(
      stream: widget.availabilitiesStream,
      builder: (context, snapshot) {
        var templatesLoading =
            snapshot.connectionState == ConnectionState.waiting;
        var templatesAvailable =
            !templatesLoading && (snapshot.data?.isNotEmpty ?? false);
        var templates = snapshot.data?.getUniqueTemplates() ?? [];
        var existAvailabilitiesWithoutTemplate =
            snapshot.data?.any((element) => element.template == null) ?? false;
        void onDrawerHeaderClick() {
          if (!templatesAvailable && !_templateDrawerOpen) {
            return;
          }
          setState(() {
            _templateDrawerOpen = !_templateDrawerOpen;
          });
        }

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
              // TODO(freek): Animation should be used so it doesn't instantly
              // close
              constraints:
                  BoxConstraints(maxHeight: _templateDrawerOpen ? 150 : 0),
              decoration: BoxDecoration(
                border: _templateDrawerOpen
                    ? Border.all(color: theme.colorScheme.onSurface, width: 1)
                    : null,
              ),
              padding: const EdgeInsets.only(right: 2),
              child: _templateDrawerOpen && !templatesLoading
                  // TODO(Joey): A listview inside a scrollview inside the
                  // scrollable that each page has seems like really strange UX
                  // TODO(Joey): No ternary operators in the layout
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            constraints: const BoxConstraints(
                              // TODO(Joey): Not divisible by 4
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
                                // TODO(Joey): This seems like an odd way to
                                // implement appending items
                                itemCount: templates.length + 2,
                                itemBuilder: (context, index) {
                                  if (index == 0) {
                                    // TODO(Joey): Extract this as a widget
                                    return Column(
                                      children: [
                                        _TemplateLegendItem(
                                          name: translations
                                              .templateSelectionLabel,
                                          backgroundColor:
                                              colors.selectedDayColor ??
                                                  colorScheme.primaryFixedDim,
                                          borderColor: colorScheme.primary,
                                        ),
                                        if (existAvailabilitiesWithoutTemplate) ...[
                                          _TemplateLegendItem(
                                            name: translations
                                                .availabilityWithoutTemplateLabel,
                                            backgroundColor: colors
                                                    .customAvailabilityColor ??
                                                colorScheme.secondary,
                                          ),
                                        ],
                                      ],
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
            // TODO(Joey): This is too complex of a check to read the layout
            // There are 8 different combinations parameters with 2 different
            // outcomes
            if (!templatesAvailable &&
                (!_templateDrawerOpen || templatesLoading)) ...[
              const SizedBox(height: 12),
              if (templatesLoading) ...[
                options.loadingIndicatorBuilder(context),
              ] else ...[
                createNewTemplateButton,
              ],
            ],
          ],
        );
      },
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
                // TODO(Joey): Use a global borderRadius
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: borderColor ?? Colors.transparent,
                ),
              ),
              width: 20,
              height: 20,
            ),
            // TODO(Joey): Not divisible by 4
            const SizedBox(width: 6),
            Text(name, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      );
}
