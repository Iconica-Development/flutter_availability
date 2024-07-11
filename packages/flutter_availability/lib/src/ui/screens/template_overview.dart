import "package:flutter/material.dart";
import "package:flutter_availability/src/util/scope.dart";
import "package:flutter_availability_data_interface/flutter_availability_data_interface.dart";
import "package:flutter_hooks/flutter_hooks.dart";

/// Overview screen for all the availability templates
class AvailabilityTemplateOverview extends HookWidget {
  /// Constructor
  const AvailabilityTemplateOverview({
    required this.onExit,
    required this.onEditTemplate,
    required this.onAddTemplate,
    this.onSelectTemplate,
    super.key,
  });

  /// Callback for when the user wants to navigate back
  final VoidCallback onExit;

  /// Callback for when the user goes to edit an existing template
  final void Function(AvailabilityTemplateModel template) onEditTemplate;

  /// Callback for when the user goes to create a new template
  final void Function(AvailabilityTemplateType type) onAddTemplate;

  /// Callback for when the user selects a template
  final void Function(AvailabilityTemplateModel template)? onSelectTemplate;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var availabilityScope = AvailabilityScope.of(context);
    var service = availabilityScope.service;
    var options = availabilityScope.options;
    var translations = options.translations;
    var spacing = options.spacing;

    var dayTemplateStream = useMemoized(() => service.getDayTemplates());
    var weekTemplateStream = useMemoized(() => service.getWeekTemplates());

    var dayTemplatesSnapshot = useStream(dayTemplateStream);
    var weekTemplatesSnapshot = useStream(weekTemplateStream);

    var title = Center(
      child: Text(
        translations.templateScreenTitle,
        style: theme.textTheme.displaySmall,
      ),
    );

    var dayTemplateSection = _TemplateListSection(
      sectionTitle: translations.dayTemplates,
      createButtonText: translations.createDayTemplate,
      onEditTemplate: onEditTemplate,
      onSelectTemplate: onSelectTemplate,
      onAddTemplate: () => onAddTemplate(AvailabilityTemplateType.day),
      templatesSnapshot: dayTemplatesSnapshot,
    );

    var weekTemplateSection = _TemplateListSection(
      sectionTitle: translations.weekTemplates,
      createButtonText: translations.createWeekTemplate,
      templatesSnapshot: weekTemplatesSnapshot,
      onEditTemplate: onEditTemplate,
      onSelectTemplate: onSelectTemplate,
      onAddTemplate: () => onAddTemplate(AvailabilityTemplateType.week),
    );

    var body = Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.sidePadding),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            title,
            const SizedBox(height: 24),
            dayTemplateSection,
            const SizedBox(height: 40),
            weekTemplateSection,
            SizedBox(height: spacing.bottomButtonPadding),
          ],
        ),
      ),
    );

    return options.baseScreenBuilder(context, onExit, body);
  }
}

/// Displays a list of templates and a button to create a new template
class _TemplateListSection extends StatelessWidget {
  const _TemplateListSection({
    required this.sectionTitle,
    required this.createButtonText,
    required this.templatesSnapshot,
    required this.onEditTemplate,
    required this.onAddTemplate,
    required this.onSelectTemplate,
  });

  final String sectionTitle;
  final String createButtonText;
  final AsyncSnapshot<List<AvailabilityTemplateModel>> templatesSnapshot;
  final void Function(AvailabilityTemplateModel template) onEditTemplate;
  final VoidCallback onAddTemplate;
  final void Function(AvailabilityTemplateModel template)? onSelectTemplate;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var availabilityScope = AvailabilityScope.of(context);
    var options = availabilityScope.options;

    void onClickTemplate(AvailabilityTemplateModel template) {
      // if the onSelectTemplate is set the user can select a template
      // The user will need to click on the edit button to edit
      (onSelectTemplate ?? onEditTemplate).call(template);
    }

    var templateCreationButton = InkWell(
      hoverColor: Colors.transparent,
      onTap: onAddTemplate,
      child: Container(
        color: Colors.transparent,
        height: 44,
        margin: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add),
            const SizedBox(width: 8),
            options.smallTextButtonBuilder(
              context,
              onAddTemplate,
              Text(
                createButtonText,
              ),
            ),
          ],
        ),
      ),
    );

    return Column(
      children: [
        Text(sectionTitle, style: textTheme.titleMedium),
        const SizedBox(height: 8),
        const Divider(height: 1),
        for (var template
            in templatesSnapshot.data ?? <AvailabilityTemplateModel>[]) ...[
          GestureDetector(
            onTap: () => onClickTemplate(template),
            child: Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                border: Border.all(color: theme.dividerColor, width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(template.color),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    height: 20,
                    width: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(template.name, style: textTheme.bodyLarge),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => onEditTemplate(template),
                    child: const Icon(Icons.edit),
                  ),
                ],
              ),
            ),
          ),
        ],
        if (templatesSnapshot.connectionState == ConnectionState.waiting) ...[
          Center(child: options.loadingIndicatorBuilder(context)),
        ],
        const SizedBox(height: 8),
        templateCreationButton,
      ],
    );
  }
}
