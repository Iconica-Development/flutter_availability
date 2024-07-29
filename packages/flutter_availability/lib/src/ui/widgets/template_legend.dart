import "package:flutter/material.dart";
import "package:flutter_availability/src/util/scope.dart";
import "package:flutter_availability_data_interface/flutter_availability_data_interface.dart";

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
    var existAvailabilitiesWithoutTemplate = widget.availabilities.data
            ?.any((element) => element.template == null) ??
        false;

    var templatesVisible = templatesAvailable && _templateDrawerOpen;

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

    Widget body = const Divider(
      height: 1,
      thickness: 1,
    );

    if (_templateDrawerOpen && !templatesLoading) {
      body = Container(
        constraints: const BoxConstraints(maxHeight: 152),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            trackVisibility: true,
            thickness: 2,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: 12,
                  ),
                  child: _TemplateLegendItem(
                    name: translations.templateSelectionLabel,
                    backgroundColor: Colors.white,
                    borderColor: colorScheme.primary,
                  ),
                ),
                if (existAvailabilitiesWithoutTemplate) ...[
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 12,
                    ),
                    child: _TemplateLegendItem(
                      name: translations.availabilityWithoutTemplateLabel,
                      backgroundColor: colors.customAvailabilityColor ??
                          colorScheme.secondary,
                    ),
                  ),
                ],
                for (var template in templates) ...[
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 12,
                    ),
                    child: _TemplateLegendItem(
                      name: template.name,
                      backgroundColor: Color(template.color),
                    ),
                  ),
                ],
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 8,
                  ),
                  child: createNewTemplateButton,
                ),
              ],
            ),
          ),
        ),
      );
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
          // TODO(freek): Animation should be used so it doesn't instantly close
          constraints: BoxConstraints(maxHeight: _templateDrawerOpen ? 150 : 0),
          decoration: BoxDecoration(
            border: _templateDrawerOpen
                ? Border.all(
                    color: theme.colorScheme.onSurface,
                    width: 1,
                  )
                : null,
          ),
          padding: const EdgeInsets.only(right: 2),
          child: body,
        ),
        if (!templatesVisible) ...[
          const SizedBox(height: 12),
          if (templatesLoading) ...[
            options.loadingIndicatorBuilder(context),
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
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var availabilityScope = AvailabilityScope.of(context);
    var options = availabilityScope.options;

    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: options.borderRadius,
            border: Border.all(
              color: borderColor ?? Colors.transparent,
            ),
          ),
          width: 20,
          height: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            name,
            style: theme.textTheme.bodyLarge,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
