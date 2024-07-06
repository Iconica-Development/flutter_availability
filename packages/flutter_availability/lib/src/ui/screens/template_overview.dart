import "package:flutter/material.dart";
import "package:flutter_availability/src/util/scope.dart";
import "package:flutter_availability_data_interface/flutter_availability_data_interface.dart";

/// Overview screen for all the availability templates
class AvailabilityTemplateOverview extends StatelessWidget {
  /// Constructor
  const AvailabilityTemplateOverview({
    required this.onExit,
    required this.onEditTemplate,
    required this.onAddTemplate,
    super.key,
  });

  /// Callback for when the user wants to navigate back
  final VoidCallback onExit;

  /// Callback for when the user goes to edit an existing template
  final void Function(AvailabilityTemplateModel template) onEditTemplate;

  /// Callback for when the user goes to create a new template
  final void Function(AvailabilityTemplateType type) onAddTemplate;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var availabilityScope = AvailabilityScope.of(context);
    var options = availabilityScope.options;
    var translations = options.translations;
    var spacing = options.spacing;

    var title = Center(
      child: Text(
        translations.templateScreenTitle,
        style: theme.textTheme.displaySmall,
      ),
    );

    var dayTemplateSection = _TemplateListSection(
      sectionTitle: translations.dayTemplates,
      createButtonText: translations.createDayTemplate,
      templates: [
        for (var template in <(Color, String)>[
          (Colors.red, "Template 1"),
          (Colors.blue, "Template 2"),
          (Colors.green, "Template 3"),
          (Colors.yellow, "Template 4"),
        ]) ...[
          AvailabilityTemplateModel(
            userId: "1",
            id: "1",
            name: template.$2,
            templateType: AvailabilityTemplateType.day,
            templateData: DayTemplateData(
              startTime: DateTime.now(),
              endTime: DateTime.now(),
              breaks: [],
            ),
            color: template.$1.value,
          ),
        ],
      ],
      onEditTemplate: onEditTemplate,
      onAddTemplate: () => onAddTemplate(AvailabilityTemplateType.day),
    );

    var weekTemplateSection = _TemplateListSection(
      sectionTitle: translations.weekTemplates,
      createButtonText: translations.createWeekTemplate,
      templates: [
        for (var template in <(Color, String)>[
          (Colors.purple, "Template 5"),
          (Colors.orange, "Template 6"),
          (Colors.teal, "Template 7"),
          (Colors.pink, "Template 8"),
          (Colors.indigo, "Template 9"),
        ]) ...[
          AvailabilityTemplateModel(
            userId: "1",
            id: "1",
            name: template.$2,
            templateType: AvailabilityTemplateType.week,
            templateData: DayTemplateData(
              startTime: DateTime.now(),
              endTime: DateTime.now(),
              breaks: [],
            ),
            color: template.$1.value,
          ),
        ],
      ],
      onEditTemplate: onEditTemplate,
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
    required this.templates,
    required this.onEditTemplate,
    required this.onAddTemplate,
  });

  final String sectionTitle;
  final String createButtonText;
  final List<AvailabilityTemplateModel> templates;
  final void Function(AvailabilityTemplateModel template) onEditTemplate;
  final VoidCallback onAddTemplate;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    var templateCreationButton = GestureDetector(
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
            Text(
              createButtonText,
              style: textTheme.bodyLarge?.copyWith(
                decoration: TextDecoration.underline,
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
        for (var template in templates) ...[
          GestureDetector(
            onTap: () => onEditTemplate(template),
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
                  const Icon(Icons.edit),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 8),
        templateCreationButton,
      ],
    );
  }
}
